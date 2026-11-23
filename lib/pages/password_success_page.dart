import 'package:flutter/material.dart';

class PasswordSuccessPage extends StatelessWidget {
  const PasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF132A60),
      body: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // =======================================================
                      // 1. HEADER ATAS LET'S PAY DENGAN BOLA UNGU
                      // =======================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 50, bottom: 24),
                        decoration: const BoxDecoration(
                          color: Color(0xFF132A60),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: -50,
                              top: 10,
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B8AE0).withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -30,
                              top: -40,
                              child: Container(
                                width: 145,
                                height: 145,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B8AE0).withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const Center(
                              child: Text(
                                "LET'S PAY",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // =======================================================
                      // 2. KARTU SUKSES BERLATAR GRADIENT LEMBUT & CENTANG HIJAU
                      // =======================================================
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFFFFF), Color(0xFFECE7FA)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(36),
                              topRight: Radius.circular(36),
                            ),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Lingkaran dekoratif kanan tengah
                              Positioned(
                                right: -40,
                                top: 120,
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B8AE0).withValues(alpha: 0.25),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              // Lingkaran dekoratif kiri bawah
                              Positioned(
                                left: -60,
                                bottom: 120,
                                child: Container(
                                  width: 170,
                                  height: 170,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B8AE0).withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),

                              // KONTEN UTAMA
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 40,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),

                                    // LINGKARAN CENTANG HIJAU BESAR
                                    Container(
                                      width: 140,
                                      height: 140,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF00B027),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 85,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 36),

                                    // JUDUL HIJAU
                                    const Text(
                                      'Kata Sandi Berhasil Diubah',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF00B027),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // SUB-JUDUL
                                    const Text(
                                      'Kini akun kamu lebih aman.\nSilahkan masuk dengan\nkata sandi baru',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF132A60),
                                        height: 1.4,
                                      ),
                                    ),
                                    const Spacer(),

                                    // TOMBOL GRADIENT "Kembali Ke Login"
                                    Container(
                                      width: double.infinity,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(26),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF2650CE),
                                            Color(0xFF9E65BA)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF2650CE)
                                                .withValues(alpha: 0.35),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        // =======================================================
                                        // LANGSUNG KEMBALI KE HALAMAN LOGIN AWAL
                                        // =======================================================
                                        onPressed: () {
                                          Navigator.of(context).popUntil((route) => route.isFirst);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(26),
                                          ),
                                        ),
                                        child: const Text(
                                          'Kembali Ke Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}