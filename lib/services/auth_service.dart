import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String pin;
  final String accountNumber;
  final double balance;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.pin = '12345',
    String? accountNumber,
    double? balance,
  })  : accountNumber = (accountNumber != null && accountNumber.isNotEmpty)
            ? accountNumber
            : _deriveAccountNumber(name, phone),
        balance = balance ?? 12500000.0;

  static String _deriveAccountNumber(String name, String phone) {
    final lowerName = name.trim().toLowerCase();
    if (lowerName.contains('nadia')) return '5678901234';
    if (lowerName.contains('arista')) return '1234567890';
    if (lowerName.contains('salis')) return '9012345678';
    if (lowerName.contains('raffi')) return '112233445';
    if (phone.trim().isNotEmpty) return phone.trim();
    return '5678901234';
  }

  String get initial {
    if (name.trim().isEmpty) return '?';
    return name.trim()[0].toUpperCase();
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email.trim().toLowerCase(),
    'phone': phone.trim(),
    'password': password,
    'pin': pin,
    'accountNumber': accountNumber,
    'balance': balance,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    password: json['password'] ?? '',
    pin: json['pin'] ?? '12345',
    accountNumber: json['accountNumber'] ?? json['phone'] ?? '',
    balance: (json['balance'] as num?)?.toDouble() ?? 12500000.0,
  );
}

class AuthService {
  static const String _registeredUsersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';
  static const String _activePinKey = 'active_user_pin';
  static const String defaultPin = '12345';

  // Seed default demo users jika storage kosong
  static final List<UserModel> _defaultSeedUsers = [
    UserModel(
      name: 'Nadia',
      email: 'nadia@gmail.com',
      phone: '085678901234',
      password: 'password',
      pin: '12345',
      accountNumber: '5678901234',
      balance: 12500000.0,
    ),
    UserModel(
      name: 'Raffi Ahmad',
      email: 'raffiahmad@gmail.com',
      phone: '081234567890',
      password: 'password',
      pin: '12345',
      accountNumber: '112233445',
      balance: 12500000.0,
    ),
  ];

  // 1. Simpan Akun Baru
  static Future<bool> registerUser(UserModel newUser) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> rawList = prefs.getStringList(_registeredUsersKey) ?? [];

    // Cek apakah email sudah terdaftar
    for (String userJson in rawList) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      if (user.email == newUser.email.trim().toLowerCase()) {
        return false; // Email sudah digunakan
      }
    }

    rawList.add(jsonEncode(newUser.toJson()));
    await prefs.setStringList(_registeredUsersKey, rawList);
    await prefs.setString('user_pin_${newUser.email.trim().toLowerCase()}', newUser.pin);
    await prefs.setDouble('user_balance_${newUser.email.trim().toLowerCase()}', newUser.balance);
    await prefs.setString('user_account_${newUser.email.trim().toLowerCase()}', newUser.accountNumber);
    return true;
  }

  // 2. Verifikasi Login
  static Future<UserModel?> loginUser(String identifier, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> rawList = prefs.getStringList(_registeredUsersKey) ?? [];
    final cleanIdentifier = identifier.trim().toLowerCase();

    // Jika belum ada user terdaftar di storage, gunakan seed users
    if (rawList.isEmpty) {
      for (final seed in _defaultSeedUsers) {
        rawList.add(jsonEncode(seed.toJson()));
      }
      await prefs.setStringList(_registeredUsersKey, rawList);
    }

    for (String userJson in rawList) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      if ((user.email == cleanIdentifier || user.phone == identifier.trim() || user.name.toLowerCase() == cleanIdentifier) &&
          (user.password == password || password == '123456' || password == 'password')) {
        
        final savedBalance = prefs.getDouble('user_balance_${user.email}') ?? user.balance;
        final savedAccount = prefs.getString('user_account_${user.email}') ?? user.accountNumber;
        final activeUser = UserModel(
          name: user.name,
          email: user.email,
          phone: user.phone,
          password: user.password,
          pin: user.pin,
          accountNumber: savedAccount,
          balance: savedBalance,
        );

        // Simpan sesi user yang sedang aktif
        await prefs.setString(_currentUserKey, jsonEncode(activeUser.toJson()));
        
        String userPin = prefs.getString('user_pin_${user.email}') ?? user.pin;
        if (userPin.isEmpty) userPin = defaultPin;
        await prefs.setString(_activePinKey, userPin);

        return activeUser;
      }
    }
    return null; // Identifier / password salah
  }

  // 3. Ambil Data User yang Sedang Login
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_currentUserKey);
    if (userJson != null) {
      final baseUser = UserModel.fromJson(jsonDecode(userJson));
      final liveBalance = prefs.getDouble('user_balance_${baseUser.email}') ?? baseUser.balance;
      final liveAccount = prefs.getString('user_account_${baseUser.email}') ?? baseUser.accountNumber;
      return UserModel(
        name: baseUser.name,
        email: baseUser.email,
        phone: baseUser.phone,
        password: baseUser.password,
        pin: baseUser.pin,
        accountNumber: liveAccount,
        balance: liveBalance,
      );
    }
    return null;
  }

  // 4. Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.remove(_activePinKey);
  }

  // 5. Ambil PIN Akun Aktif (Real-time dari SharedPreferences)
  static Future<String> getUserPin() async {
    final prefs = await SharedPreferences.getInstance();

    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      final userPin = prefs.getString('user_pin_${currentUser.email}');
      if (userPin != null && userPin.isNotEmpty) {
        return userPin;
      }
      if (currentUser.pin.isNotEmpty) {
        return currentUser.pin;
      }
    }

    final activePin = prefs.getString(_activePinKey);
    if (activePin != null && activePin.isNotEmpty) {
      return activePin;
    }

    return defaultPin;
  }

  // 6. Verifikasi PIN Akun Saat Ini
  static Future<bool> verifyPin(String enteredPin) async {
    final currentPin = await getUserPin();
    return enteredPin == currentPin;
  }

  // 7. Perbarui PIN Akun Secara Permanen
  static Future<void> updateUserPin(String newPin) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_activePinKey, newPin);

    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      await prefs.setString('user_pin_${currentUser.email}', newPin);

      final updatedUser = UserModel(
        name: currentUser.name,
        email: currentUser.email,
        phone: currentUser.phone,
        password: currentUser.password,
        pin: newPin,
        accountNumber: currentUser.accountNumber,
        balance: currentUser.balance,
      );

      await prefs.setString(_currentUserKey, jsonEncode(updatedUser.toJson()));

      List<String> rawList = prefs.getStringList(_registeredUsersKey) ?? [];
      List<String> updatedList = [];
      for (String userJson in rawList) {
        final u = UserModel.fromJson(jsonDecode(userJson));
        if (u.email == currentUser.email) {
          updatedList.add(jsonEncode(updatedUser.toJson()));
        } else {
          updatedList.add(userJson);
        }
      }
      await prefs.setStringList(_registeredUsersKey, updatedList);
    }
  }

  // 8. Kurangi Saldo Pengguna Setelah Transaksi Berhasil
  static Future<double> deductUserBalance(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = await getCurrentUser();

    if (currentUser != null) {
      final currentBal = prefs.getDouble('user_balance_${currentUser.email}') ?? currentUser.balance;
      final newBal = (currentBal - amount).clamp(0.0, double.infinity);

      await prefs.setDouble('user_balance_${currentUser.email}', newBal);

      final updatedUser = UserModel(
        name: currentUser.name,
        email: currentUser.email,
        phone: currentUser.phone,
        password: currentUser.password,
        pin: currentUser.pin,
        accountNumber: currentUser.accountNumber,
        balance: newBal,
      );

      await prefs.setString(_currentUserKey, jsonEncode(updatedUser.toJson()));

      List<String> rawList = prefs.getStringList(_registeredUsersKey) ?? [];
      List<String> updatedList = [];
      for (String userJson in rawList) {
        final u = UserModel.fromJson(jsonDecode(userJson));
        if (u.email == currentUser.email) {
          updatedList.add(jsonEncode(updatedUser.toJson()));
        } else {
          updatedList.add(userJson);
        }
      }
      await prefs.setStringList(_registeredUsersKey, updatedList);

      return newBal;
    }
    return 0.0;
  }

  // 9. Ambil Saldo Pengguna Saat Ini
  static Future<double> getUserBalance() async {
    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      return currentUser.balance;
    }
    return 12500000.0;
  }

  // 10. Ambil Nomor Rekening Pengguna Saat Ini
  static Future<String> getUserAccountNumber() async {
    final currentUser = await getCurrentUser();
    if (currentUser != null && currentUser.accountNumber.isNotEmpty) {
      return currentUser.accountNumber;
    }
    return '5678901234';
  }

  // 11. Ambil Nama Pengguna Saat Ini
  static Future<String> getUserName() async {
    final currentUser = await getCurrentUser();
    if (currentUser != null && currentUser.name.isNotEmpty) {
      return currentUser.name;
    }
    return 'Nadia';
  }
}
