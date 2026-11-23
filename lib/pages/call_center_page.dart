import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'call_phone_page.dart';
import 'chat_cs_page.dart';

class CallCenterPage extends StatelessWidget {
  const CallCenterPage({super.key});

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
                  Color(0xFF6B7CD4), // Biru atas
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
            top: size.height * 0.22,
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

          // 4. Konten Halaman Menu Call Center
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Tombol Kembali ke Welcome Page
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Judul: "LET’S PAY" (Warna Biru Tua Pekat)
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
                  const SizedBox(height: 4),

                  // Sub-judul: "Call Center"
                  Text(
                    'Call Center',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Deskripsi
                  Text(
                    'Butuh bantuan akun atau transaksi?\nPilih cara menghubungi kami.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.95),
                      height: 1.45,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Lingkaran Transparan dengan Ikon Headset Besar
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.headset_mic_rounded,
                        color: Colors.white,
                        size: 85,
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // 1. Tombol Opsi: "Telepon Call Center" -> Buka TeleponCallCenterPage
                  Container(
                    width: double.infinity,
                    height: 68,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
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
                        backgroundColor: const Color(0xFF1C41B0), // Biru pekat
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeleponCallCenterPage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.call_outlined, color: Colors.white, size: 26),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Telepon Call Center',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Bicara langsung dengan tim kami',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Tombol Opsi: "Chat dengan CS" -> Buka ChatCsPage
                  Container(
                    width: double.infinity,
                    height: 68,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
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
                        backgroundColor: const Color(0xFFBD9FC6).withValues(alpha: 0.55),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.45),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatCsPage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 25),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chat dengan CS',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sampaikan pertanyaan lewat pesan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Catatan Keamanan Bagian Bawah
                  Column(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: Colors.white.withValues(alpha: 0.85),
                        size: 22,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Jaga keamanan akunmu. Jangan bagikan\nPIN, kata sandi, atau kode OTP.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.88),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}