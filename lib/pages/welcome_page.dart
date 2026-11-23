import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'call_center_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient Persis Sesuai Desain
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6B7CD4), // Biru periwinkle atas
                  Color(0xFF8B88CA),
                  Color(0xFFA796C4),
                  Color(0xFFBF9FBD), // Mauve / Lilac bawah
                ],
                stops: [0.0, 0.32, 0.68, 1.0],
              ),
            ),
          ),

          // 2. Lingkaran Ambient Kanan Atas
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

          // 3. Lingkaran Ambient Kiri Tengah
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

          // 4. Lingkaran Ambient Kiri Bawah
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

          // 5. Seluruh Konten Halaman
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Ikon Headset / Call Center (Kanan Atas) -> Buka Halaman CallCenterPage
                  Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CallCenterPage(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.headset_mic_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.032),

                  // Teks: "Selamat Datang di"
                  Text(
                    'Selamat Datang di',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 22.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Teks: "LET’S PAY" (Warna Biru Tua Pekat sesuai gambar asli)
                  Text(
                    'LET’S PAY',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1C2487),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Teks Deskripsi
                  Text(
                    'Semua kebutuhan transaksi kamu\ndalam satu aplikasi. Lebih mudah,\nlebih cepat, lebih aman.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
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
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Tombol "Masuk" -> Langsung Buka Halaman Login
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
                        backgroundColor: const Color(0xFF1C41B0), // Biru pekat sesuai desain
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Masuk',
                        style: GoogleFonts.poppins(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tombol "Daftar" -> Langsung Buka Halaman Registrasi
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Daftar',
                        style: GoogleFonts.poppins(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Link Teks: "Butuh bantuan? Call Center" -> Buka Halaman CallCenterPage
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CallCenterPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        'Butuh bantuan? Call Center',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.9),
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white.withValues(alpha: 0.9),
                        ),
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