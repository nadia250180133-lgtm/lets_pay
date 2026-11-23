import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class InformationAccountPage extends StatefulWidget {
  const InformationAccountPage({super.key});

  @override
  State<InformationAccountPage> createState() => _InformationAccountPageState();
}

class _InformationAccountPageState extends State<InformationAccountPage> {
  String _userName = '';
  String _phoneNumber = '';
  String _email = '';
  final String _statusEmail = 'Terverifikasi';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Ambil data akun yang sedang login dari AuthService / SharedPreferences
    final currentUser = await AuthService.getCurrentUser();

    if (mounted) {
      setState(() {
        if (currentUser != null && currentUser.name.isNotEmpty) {
          _userName = currentUser.name;
          _phoneNumber = currentUser.phone.isNotEmpty ? currentUser.phone : '-';
          _email = currentUser.email.isNotEmpty ? currentUser.email : '-';
        } else {
          // Fallback awal jika belum ada sesi spesifik
          _userName = UserSession.activeUser;
          _phoneNumber = UserSession.accountNumber;
          _email = '${UserSession.activeUser.toLowerCase()}@gmail.com';
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String initialLetter =
        _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U';

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
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Text(
                      'Informasi Akun',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),

                            // Avatar Inisial Sesuai Nama Pengguna
                            Center(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.white.withValues(alpha: 0.55),
                                    ),
                                    child: Center(
                                      child: Text(
                                        initialLetter,
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
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Card Info Kontak (Nama & Nomor HP Akun Aktif)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F0F9),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Info Kontak',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F1E36),
                                    ),
                                  ),
                                  const Divider(
                                      color: Color(0xFFD4D2E2), height: 24),
                                  const Text(
                                    'Nama',
                                    style: TextStyle(
                                        fontSize: 13, color: Color(0xFF7A7E8D)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _userName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F1E36),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Nomor HP',
                                    style: TextStyle(
                                        fontSize: 13, color: Color(0xFF7A7E8D)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _phoneNumber,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F1E36),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Card Email (Email & Status Verifikasi Akun Aktif)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F0F9),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F1E36),
                                    ),
                                  ),
                                  const Divider(
                                      color: Color(0xFFD4D2E2), height: 24),
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 13, color: Color(0xFF7A7E8D)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _email,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F1E36),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Status Email',
                                    style: TextStyle(
                                        fontSize: 13, color: Color(0xFF7A7E8D)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _statusEmail,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F1E36),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
