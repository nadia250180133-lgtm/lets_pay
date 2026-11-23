import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_cs_page.dart';

class TeleponCallCenterPage extends StatelessWidget {
  const TeleponCallCenterPage({super.key});

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

          // 3. Lingkaran Ambient Kiri Bawah
          Positioned(
            top: size.height * 0.48,
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

          // 4. Konten Halaman Telepon Call Center (Bebas Overflow & RenderFlex error)
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),

                            // Tombol Kembali (Panah Kiri)
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

                            SizedBox(height: size.height * 0.025),

                            // Header: "LET’S PAY" (Warna Biru Tua Pekat)
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

                            // Sub-header: "Telepon Call Center"
                            Text(
                              'Telepon Call Center',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Deskripsi
                            Text(
                              'Bicara langsung dengan tim kami\nuntuk bantuan akun dan transaksi.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.95),
                                height: 1.45,
                              ),
                            ),

                            const Spacer(flex: 2),

                            // Lingkaran Transparan dengan Ikon Headset Besar
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.18),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.headset_mic_rounded,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ),

                            const Spacer(flex: 2),

                            // Kartu Notifikasi: "Nomor layanan belum tersedia"
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBD9FC6).withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nomor layanan belum tersedia',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Layanan telepon belum dapat digunakan.\nSilakan hubungi CS melalui chat.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(alpha: 0.90),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Tombol "Telepon Call Center" (Menampilkan info layanan belum tersedia saat diklik)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(28),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Layanan telepon saat ini belum tersedia. Silakan hubungi CS melalui chat.',
                                        style: GoogleFonts.poppins(fontSize: 13),
                                      ),
                                      backgroundColor: const Color(0xFF1C2487),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5E739E).withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.call_outlined, color: Colors.white, size: 22),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Telepon Call Center',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Tombol Aktif: "Chat dengan CS" (Biru Pekat -> Navigasi ke ChatCsPage)
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
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
                                  backgroundColor: const Color(0xFF1C41B0),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ChatCsPage()),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 22),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        'Chat dengan CS',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Catatan Keamanan Bawah (Menggunakan Expanded agar bebas horizontal overflow)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color: Colors.white.withValues(alpha: 0.85),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Jaga keamanan akunmu. Jangan bagikan PIN, kata sandi, atau kode OTP.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withValues(alpha: 0.88),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
