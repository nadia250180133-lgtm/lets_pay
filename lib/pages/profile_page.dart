import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'information_account_page.dart';
import 'call_center_page.dart';
import 'create_new_password_page.dart';
import 'change_pin_page.dart';
import 'login_page.dart';
import '../services/auth_service.dart' as app_auth;
import '../services/profile_storage_service.dart';

// ========================================================
// SERVICE PENGATURAN TOGGLE (PIN, Password, Notifikasi)
// ========================================================
class SettingsService {
  static const String _keyPin = 'is_pin_enabled';
  static const String _keyPassword = 'is_password_enabled';
  static const String _keyNotifications = 'is_notifications_enabled';

  static Future<Map<String, bool>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'pin': prefs.getBool(_keyPin) ?? false,
      'password': prefs.getBool(_keyPassword) ?? false,
      'notifications': prefs.getBool(_keyNotifications) ?? true,
    };
  }

  static Future<void> setPinEnabled(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPin, val);
  }

  static Future<void> setPasswordEnabled(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPassword, val);
  }

  static Future<void> setNotificationsEnabled(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, val);
  }
}

// ========================================================
// SERVICE AUTENTIKASI (Data User & Logout)
// ========================================================
class AuthService {
  static String get userName => UserSession.activeUser;
  static String get accountNumber => UserSession.accountNumber;
  static String get email => '${UserSession.activeUser.toLowerCase()}@gmail.com';

  static Future<void> logout(BuildContext context) async {
    await app_auth.AuthService.logout();
    await ProfileStorageService.clearAuthSession();
    UserSession.activeUser = 'Pengguna';

    if (!context.mounted) return;
    // Arahkan ke halaman Login dan hapus seluruh tumpukan halaman sebelumnya
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}

// ========================================================
// HALAMAN PROFIL
// ========================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isNotificationsEnabled = true;
  String _displayName = UserSession.activeUser;
  String _displayEmail = '${UserSession.activeUser.toLowerCase()}@gmail.com';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsService.loadSettings();
    final currentUser = await app_auth.AuthService.getCurrentUser();
    setState(() {
      _isNotificationsEnabled = settings['notifications'] ?? true;
      if (currentUser != null && currentUser.name.isNotEmpty) {
        _displayName = currentUser.name;
        _displayEmail = currentUser.email;
      } else {
        _displayName = AuthService.userName;
        _displayEmail = AuthService.email;
      }
    });
  }

  void _showLogoutDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: const BoxDecoration(
            color: Color(0xFFECEBF7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apakah kamu yakin untuk keluar dari Let’s Pay?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F1E36),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Setelah keluar kamu harus memasukkan informasi login kamu untuk menggunakan layanan kami.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2E0F2),
                    foregroundColor: const Color(0xFF0F1E36),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Batal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    AuthService.logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2E0F2),
                    foregroundColor: const Color(0xFF0F1E36),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Keluar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFDEC8F5),
              Color(0xFFB1B6F0),
              Color(0xFF5073E5),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.55),
                              ),
                              child: Center(
                                child: Text(
                                  _displayName.isNotEmpty ? _displayName[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: -4,
                              child: Container(
                                width: 34,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8652D7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 19),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Information Account
                      ProfileMenuItem(
                        icon: Icons.account_circle_outlined,
                        title: 'Information Account',
                        fontWeight: FontWeight.w600,
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const InformationAccountPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 6),

                      // Login & Security
                      Row(
                        children: const [
                          Icon(Icons.shield_outlined, color: Colors.white, size: 26),
                          SizedBox(width: 14),
                          Text('Login & Security', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),

                      ProfileMenuItem(
                        leftPadding: 40,
                        icon: Icons.vpn_key_outlined,
                        title: 'Ubah PIN',
                        iconSize: 22,
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: const RouteSettings(name: 'ChangePinOldPage'),
                              builder: (context) => const ChangePinOldPage(),
                            ),
                          );
                        },
                      ),

                      ProfileMenuItem(
                        leftPadding: 40,
                        icon: Icons.lock_outline_rounded,
                        title: 'Ubah Kata Sandi',
                        iconSize: 22,
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateNewPasswordPage(
                                identifier: _displayEmail.isNotEmpty ? _displayEmail : 'user@gmail.com',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // App Settings
                      Row(
                        children: const [
                          Icon(Icons.language_rounded, color: Colors.white, size: 26),
                          SizedBox(width: 14),
                          Text('App Settings', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),

                      ProfileMenuItem(
                        leftPadding: 40,
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        iconSize: 23,
                        trailing: ProfileSwitchToggle(
                          value: _isNotificationsEnabled,
                          onChanged: (val) {
                            setState(() => _isNotificationsEnabled = val);
                            SettingsService.setNotificationsEnabled(val);
                          },
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Others
                      Row(
                        children: const [
                          Icon(Icons.more_horiz_rounded, color: Colors.white, size: 26),
                          SizedBox(width: 14),
                          Text('Others', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),

                      ProfileMenuItem(
                        leftPadding: 40,
                        icon: Icons.help_outline_rounded,
                        title: 'Help Center',
                        iconSize: 23,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CallCenterPage()),
                          );
                        },
                      ),

                      ProfileMenuItem(
                        leftPadding: 40,
                        icon: Icons.logout_rounded,
                        title: 'Log Out',
                        iconSize: 23,
                        onTap: _showLogoutDialog,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation
              const CustomBottomNav(selectedIndex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Menu Item
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final double iconSize;
  final double leftPadding;
  final FontWeight fontWeight;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.iconSize = 26,
    this.leftPadding = 0,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: 10, bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: iconSize),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: fontWeight),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

// Toggle Switch
class ProfileSwitchToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ProfileSwitchToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: value ? const Color(0xFF42445E) : Colors.white.withValues(alpha: 0.4),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// Bottom Navigation
class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNav({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              if (selectedIndex != 0) Navigator.of(context).popUntil((r) => r.isFirst);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_rounded, size: 28, color: selectedIndex == 0 ? const Color(0xFF0F2648) : const Color(0xFFC4C7D0)),
                const SizedBox(height: 4),
                Text('Beranda', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selectedIndex == 0 ? const Color(0xFF0F2648) : const Color(0xFFC4C7D0))),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: const Color(0xFFFBBF24), borderRadius: BorderRadius.circular(22)),
                child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 2),
              const Text('QRIS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.black)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_rounded, size: 28, color: selectedIndex == 2 ? const Color(0xFF0F2648) : const Color(0xFFC4C7D0)),
              const SizedBox(height: 4),
              Text('Profil', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selectedIndex == 2 ? const Color(0xFF0F2648) : const Color(0xFFC4C7D0))),
            ],
          ),
        ],
      ),
    );
  }
}