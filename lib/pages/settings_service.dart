import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyPin = 'is_pin_enabled';
  static const String _keyPassword = 'is_password_enabled';
  static const String _keyNotifications = 'is_notifications_enabled';

  /// Memuat semua pengaturan
  static Future<Map<String, bool>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'pin': prefs.getBool(_keyPin) ?? false,
      'password': prefs.getBool(_keyPassword) ?? false,
      'notifications': prefs.getBool(_keyNotifications) ?? true,
    };
  }

  static Future<void> setPinEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPin, value);
  }

  static Future<void> setPasswordEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPassword, value);
  }

  static Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, value);
  }
}