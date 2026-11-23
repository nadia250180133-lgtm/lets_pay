import 'package:shared_preferences/shared_preferences.dart';

class ProfileStorageService {
  // Simpan foto profil per akun pengguna
  static Future<void> saveProfileImage(String userId, String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_$userId', imagePath);
  }

  // Ambil foto profil per akun pengguna
  static Future<String?> getProfileImage(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image_$userId');
  }

  // Simpan status toggle (PIN, Password, Notifications) per akun
  static Future<void> saveToggleStatus(String userId, String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${key}_$userId', value);
  }

  // Ambil status toggle per akun
  static Future<bool> getToggleStatus(String userId, String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${key}_$userId') ?? defaultValue;
  }

  // Bersihkan sesi aktif saat Log Out (tanpa menghapus data profil tersimpan)
  static Future<void> clearAuthSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await prefs.remove('active_user_token');
  }
}