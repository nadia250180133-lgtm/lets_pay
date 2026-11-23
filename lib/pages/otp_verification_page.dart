import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'create_new_password_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String identifier; // Email atau Nomor HP yang dikirim dari halaman 1

  const OtpVerificationPage({
    super.key,
    required this.identifier,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // 5 Controller dan 5 FocusNode untuk 5 Digit OTP
  final List<TextEditingController> _otpControllers =
      List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(5, (_) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = 30;
  bool _canResend = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      }
    });
  }

  void _resendOtp() {
    if (!_canResend) return;

    // Reset isi kotak OTP
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _otpFocusNodes[0].requestFocus();

    _startCountdown();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode OTP baru telah dikirim ke ${widget.identifier}'),
        backgroundColor: const Color(0xFF132A60),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((e) => e.text).join();

    if (otp.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan lengkap 5 digit kode OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // -----------------------------------------------------------------------
      // SLOT INTEGRASI BACKEND: Verifikasi kode OTP ke server / API
      // -----------------------------------------------------------------------
      await Future.delayed(const Duration(milliseconds: 800)); // Simulasi request

      if (!mounted) return;

      // Navigasi ke Halaman 3 (Buat Kata Sandi Baru)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNewPasswordPage(
            identifier: widget.identifier,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 52,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _otpFocusNodes[index].hasFocus
              ? const Color(0xFF2650CE)
              : Colors.black87,
          width: _otpFocusNodes[index].hasFocus ? 1.8 : 1.0,
        ),
      ),
      child: Center(
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            // Deteksi tombol backspace untuk mundur kotak
            if (event is RawKeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace &&
                _otpControllers[index].text.isEmpty &&
                index > 0) {
              _otpFocusNodes[index - 1].requestFocus();
            }
          },
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 4) {
                  _otpFocusNodes[index + 1].requestFocus();
                } else {
                  _otpFocusNodes[index].unfocus();
                  _verifyOtp(); // Otomatis verifikasi jika 5 digit terisi
                }
              }
            },
          ),
        ),
      ),
    );
  }

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
                      // 1. HEADER BIRU NAVY DENGAN TOMBOL BACK & LET'S PAY
                      // =======================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 44, bottom: 24),
                        decoration: const BoxDecoration(
                          color: Color(0xFF132A60),
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
                                  color: const Color(0xFF8B8AE0).withValues(alpha: 0.35),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -30,
                              top: -30,
                              child: Container(
                                width: 145,
                                height: 145,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B8AE0).withValues(alpha: 0.35),
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
                                      onPressed: () => Navigator.pop(context),
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
                      // 2. KARTU PUTIH VERIFIKASI OTP
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Verifikasi OTP',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Masukkan 5 digit kode yang telah\ndikirim ke ${widget.identifier}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 36),

                              // 5 KOTAK INPUT OTP
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  5,
                                  (index) => _buildOtpBox(index),
                                ),
                              ),
                              const SizedBox(height: 36),

                              // TEKS COUNTDOWN / TOMBOL KIRIM ULANG
                              _canResend
                                  ? TextButton(
                                      onPressed: _resendOtp,
                                      child: const Text(
                                        'Kirim Ulang OTP',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2650CE),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Kirim ulang (00:${_secondsRemaining.toString().padLeft(2, '0')})',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                              const SizedBox(height: 36),

                              // TOMBOL VERIFIKASI (GRADIENT SESUAI DESAIN)
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
                                  onPressed: _isLoading ? null : _verifyOtp,
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
                                          'Verifikasi',
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