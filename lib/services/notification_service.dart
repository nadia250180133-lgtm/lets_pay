import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  static const String _storageKey = 'lets_pay_notifications_v1';
  final ValueNotifier<List<NotificationItem>> notificationsNotifier =
      ValueNotifier<List<NotificationItem>>([]);

  final Set<String> _processedTransactionIds = <String>{};

  List<NotificationItem> get notifications => notificationsNotifier.value;

  /// Helper format Rupiah tanpa memerlukan package intl
  static String formatRupiah(num amount) {
    final int intVal = amount.toInt();
    final String str = intVal.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'Rp $str';
  }

  /// Inisialisasi service saat aplikasi dibuka
  Future<void> init() async {
    await loadNotifications();
    _initDefaultPromosIfEmpty();
  }

  /// Memuat notifikasi dari memori lokal (SharedPreferences)
  Future<void> loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonList = prefs.getStringList(_storageKey);

      if (jsonList != null && jsonList.isNotEmpty) {
        final List<NotificationItem> items = jsonList
            .map((str) => NotificationItem.fromJson(str))
            .toList();

        items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        notificationsNotifier.value = items;
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }

  /// Simpan perubahan ke local storage
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> jsonList =
          notificationsNotifier.value.map((item) => item.toJson()).toList();
      await prefs.setStringList(_storageKey, jsonList);
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  /// Tambah notifikasi transaksi berhasil
  Future<void> addTransactionNotification({
    required String transactionId,
    required String title,
    required String description,
    required TransactionType type,
    double? amount,
    String? recipient,
  }) async {
    if (_processedTransactionIds.contains(transactionId)) {
      return;
    }
    _processedTransactionIds.add(transactionId);

    final newItem = NotificationItem(
      id: transactionId,
      title: title,
      description: description,
      category: NotificationCategory.transaksi,
      transactionType: type,
      amount: amount,
      recipient: recipient,
      timestamp: DateTime.now(),
    );

    final currentList = List<NotificationItem>.from(notificationsNotifier.value);
    currentList.insert(0, newItem);
    notificationsNotifier.value = currentList;

    await _saveToStorage();
  }

  /// Tambah notifikasi promo
  Future<void> addPromoNotification({
    required String id,
    required String title,
    required String description,
  }) async {
    if (notificationsNotifier.value.any((item) => item.id == id)) {
      return;
    }

    final newItem = NotificationItem(
      id: id,
      title: title,
      description: description,
      category: NotificationCategory.promo,
      timestamp: DateTime.now(),
    );

    final currentList = List<NotificationItem>.from(notificationsNotifier.value);
    currentList.insert(0, newItem);
    notificationsNotifier.value = currentList;

    await _saveToStorage();
  }

  /// Tambah notifikasi waktu sholat
  Future<void> addPrayerNotification({
    required String prayerName,
    DateTime? prayerTime,
  }) async {
    final now = prayerTime ?? DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    final prayerId = "sholat_${prayerName.toLowerCase()}_$todayStr";

    if (notificationsNotifier.value.any((item) => item.id == prayerId)) {
      return;
    }

    final newItem = NotificationItem(
      id: prayerId,
      title: "Waktu Sholat $prayerName Telah Tiba",
      description: "Saatnya menunaikan ibadah sholat $prayerName.",
      category: NotificationCategory.sholat,
      timestamp: now,
    );

    final currentList = List<NotificationItem>.from(notificationsNotifier.value);
    currentList.insert(0, newItem);
    notificationsNotifier.value = currentList;

    await _saveToStorage();
  }

  /// Inisialisasi default promo sesuai gambar referensi ketiga
  void _initDefaultPromosIfEmpty() {
    final current = notificationsNotifier.value;
    final hasCashback = current.any((item) => item.id == 'promo_cashback_reward');
    final hasHemat = current.any((item) => item.id == 'promo_rekomendasi_hemat');

    final List<NotificationItem> toAdd = [];

    if (!hasCashback) {
      toAdd.add(
        NotificationItem(
          id: 'promo_cashback_reward',
          title: 'Cashback/Reward',
          description:
              'Selamat! Kamu dapat cashback Rp10.000 dari transaksi QRIS. Cek saldo poinmu!',
          category: NotificationCategory.promo,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      );
    }

    if (!hasHemat) {
      toAdd.add(
        NotificationItem(
          id: 'promo_rekomendasi_hemat',
          title: 'Rekomendasi Hemat',
          description:
              'Beli pulsa hari ini dapat polsu kuota 5GB. Cuma sampai jam 12 malam!.',
          category: NotificationCategory.promo,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      );
    }

    if (toAdd.isNotEmpty) {
      final updatedList = List<NotificationItem>.from(current)..addAll(toAdd);
      updatedList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      notificationsNotifier.value = updatedList;
      _saveToStorage();
    }
  }

  List<NotificationItem> getAll() {
    final list = List<NotificationItem>.from(notificationsNotifier.value);
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  List<NotificationItem> getTransactions() {
    final list = notificationsNotifier.value
        .where((item) => item.category == NotificationCategory.transaksi)
        .toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  List<NotificationItem> getPromos() {
    final list = notificationsNotifier.value
        .where((item) => item.category == NotificationCategory.promo)
        .toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }
}