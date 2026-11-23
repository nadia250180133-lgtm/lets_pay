import 'package:flutter/material.dart';
// 1. IMPORT HALAMAN VERIFIKASI OTP:
import 'otp_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email atau nomor HP wajib diisi';
    }
    final input = value.trim();
    final isNumeric = RegExp(r'^[0-9+]+$').hasMatch(input);

    if (isNumeric) {
      final cleanPhone = input.replaceAll('+', '');
      if (cleanPhone.length < 9 || cleanPhone.length > 15) {
        return 'Nomor HP tidak valid (minimal 9-15 digit)';
      }
      return null;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(input)) {
      return 'Format email atau nomor HP tidak valid';
    }
    return null;
  }

  // ===========================================================================
  // FUNGSI INI SUDAH DIARAHKAN LANGSUNG KE OTP_VERIFICATION_PAGE
  // ===========================================================================
  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus(); // Tutup keyboard

    setState(() => _isLoading = true);
    final input = _identifierController.text.trim();

    try {
      // Simulasi proses pengiriman kode ke backend/server
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      // Beri notifikasi singkat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode OTP sedang dikirim ke $input'),
          backgroundColor: const Color(0xFF2650CE),
          duration: const Duration(seconds: 2),
        ),
      );

      // LANGSUNG PINDAH KE HALAMAN 2 (VERIFIKASI OTP)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationPage(
            identifier: input, // Mengirimkan nomor HP/email ke halaman OTP
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF324CBF),
      resizeToAvoidBottomInset: true,
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
                      // 1. HEADER GRADIENT BIRU-UNGU (LINGKARAN & LOGO)
                      // =======================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 44, bottom: 24),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2C4AC4), Color(0xFF7E84DB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: -50,
                              top: 25,
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -25,
                              top: -25,
                              child: Container(
                                width: 135,
                                height: 135,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      onPressed: () {
                                        if (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pushReplacementNamed(context, '/login');
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
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
                          ],
                        ),
                      ),

                      // =======================================================
                      // 2. CARD PUTIH UTAMA (MEMENUHI HINGGA UJUNG PALING BAWAH)
                      // =======================================================
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(36),
                              topRight: Radius.circular(36),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Lupa Kata Sandi?',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Masukkan email atau nomor HP\nuntuk mereset kata sandi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // ILUSTRASI GEMBOK 3D & AMPLOP
                                SizedBox(
                                  height: 190,
                                  child: Image.asset(
                                    'assets/images/forgot_password_lock.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                            bottom: 12,
                                            child: Container(
                                              width: 180,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE4DEF5),
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.lock_rounded,
                                            size: 110,
                                            color: Color(0xFF0284C7),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // KOLOM EMAIL ATAU NOMOR HP
                                TextFormField(
                                  controller: _identifierController,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText: 'Email atau Nomor HP',
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(color: Colors.black87),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(color: Colors.black87),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF2C4AC4),
                                        width: 1.8,
                                      ),
                                    ),
                                  ),
                                  validator: _validateInput,
                                ),
                                const SizedBox(height: 22),

                                // TOMBOL GRADIENT "Kirim Tautan Reset"
                                Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF2650CE), Color(0xFF9E65BA)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF2650CE).withValues(alpha: 0.35),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleResetPassword,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Text(
                                            'Kirim Tautan Reset',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
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