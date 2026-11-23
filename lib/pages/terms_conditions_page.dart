import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4C75D8),
              Color(0xFF6B87DC),
              Color(0xFFB5A7DF),
              Color(0xFFC7B1E4),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Syarat & Ketentuan',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Konten scrollable
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  children: [
                    _buildSection(
                      number: '1',
                      title: 'Penggunaan Layanan',
                      content:
                          'Dengan menggunakan aplikasi LET\'S PAY, Anda setuju untuk menggunakan layanan ini hanya untuk tujuan yang sah dan sesuai dengan hukum yang berlaku di Indonesia.',
                    ),
                    _buildSection(
                      number: '2',
                      title: 'Keamanan Akun',
                      content:
                          'Anda bertanggung jawab penuh atas keamanan akun Anda, termasuk menjaga kerahasiaan kata sandi, PIN, dan kode OTP. Segera laporkan jika ada aktivitas mencurigakan.',
                    ),
                    _buildSection(
                      number: '3',
                      title: 'Data Pribadi',
                      content:
                          'Kami menjaga privasi dan keamanan data pribadi Anda sesuai dengan kebijakan privasi dan hukum perlindungan data yang berlaku di Indonesia.',
                    ),
                    _buildSection(
                      number: '4',
                      title: 'Transaksi & Saldo',
                      content:
                          'Setiap transaksi bersifat final setelah diverifikasi. Pastikan data penerima dan nominal transaksi sudah sesuai sebelum melakukan konfirmasi.',
                    ),
                    _buildSection(
                      number: '5',
                      title: 'Perubahan Ketentuan',
                      content:
                          'LET\'S PAY berhak memperbarui syarat dan ketentuan ini sewaktu-waktu dengan pemberitahuan melalui pembaruan aplikasi.',
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // Tombol "Setuju & Lanjutkan" Diposisikan Rapi di Bagian Bawah Layar
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF14307A),
                        elevation: 3,
                        shadowColor: Colors.black.withValues(alpha: 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Setuju & Lanjutkan',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.95),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
