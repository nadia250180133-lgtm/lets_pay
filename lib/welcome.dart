import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  /// Callback untuk mempertahankan fungsionalitas tombol & routing yang sudah ada
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;
  final VoidCallback? onCallCenterPressed;

  const WelcomePage({
    super.key,
    this.onLoginPressed,
    this.onRegisterPressed,
    this.onCallCenterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient Persis Sesuai Gambar
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6B7CD4), // Biru atas
                  Color(0xFF8B88CA),
                  Color(0xFFA796C4),
                  Color(0xFFBF9FBD), // Mauve / Lilac bawah
                ],
                stops: [0.0, 0.32, 0.68, 1.0],
              ),
            ),
          ),

          // 2. Lingkaran Ambient Kanan (Sesuai Desain Asli)
          Positioned(
            top: size.height * 0.24,
            right: -size.width * 0.22,
            child: Container(
              width: size.width * 0.70,
              height: size.width * 0.70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.09),
              ),
            ),
          ),

          // 3. Lingkaran Ambient Kiri Tengah (Sesuai Desain Asli)
          Positioned(
            top: size.height * 0.50,
            left: -size.width * 0.28,
            child: Container(
              width: size.width * 0.75,
              height: size.width * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // 4. Lingkaran Ambient Kiri Bawah (Di Belakang Tombol)
          Positioned(
            bottom: size.height * 0.08,
            left: -size.width * 0.16,
            child: Container(
              width: size.width * 0.52,
              height: size.width * 0.52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          // 5. Seluruh Konten Sesuai Desain
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Ikon Call Center di Pojok Kanan Atas
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: onCallCenterPressed ??
                          () {
                            Navigator.pushNamed(context, '/help');
                          },
                      child: const Icon(
                        Icons.headset_mic_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.032),

                  // Teks: "Selamat Datang di"
                  const Text(
                    'Selamat Datang di',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Teks: "LET’S PAY" (Warna Biru Tua Pekat sesuai gambar asli)
                  const Text(
                    'LET’S PAY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1C2487), // Navy pekat persis desain
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Teks Deskripsi
                  Text(
                    'Semua kebutuhan transaksi kamu\ndalam satu aplikasi. Lebih mudah,\nlebih cepat, lebih aman.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.95),
                      height: 1.45,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Gambar Ilustrasi 3D Kartu & Gembok Biru
                  SizedBox(
                    height: size.height * 0.28,
                    child: Center(
                      child: Image.asset(
                        'assets/images/illustration.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Jika file belum di-copy, tampilkan informasi bantuan
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'File assets/images/illustration.png belum ditemukan.\nPastikan file gambar 3D sudah ditaruh di assets/images/ dan restart aplikasi.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Tombol "Masuk"
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF102766).withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C41B0), // Biru solid sesuai gambar
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: onLoginPressed ??
                          () {
                            // Menjaga routing login yang sudah ada
                            Navigator.pushNamed(context, '/login');
                          },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tombol "Daftar"
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBD9FC6).withValues(alpha: 0.55), // Transparan Lilac
                        foregroundColor: Colors.white,
                        elevation: 0,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.45),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: onRegisterPressed ??
                          () {
                            // Menjaga routing register yang sudah ada
                            Navigator.pushNamed(context, '/register');
                          },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Link Bawah: "Butuh bantuan? Call Center"
                  GestureDetector(
                    onTap: onCallCenterPressed ??
                        () {
                          Navigator.pushNamed(context, '/help');
                        },
                    child: Text(
                      'Butuh bantuan? Call Center',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.9),
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}