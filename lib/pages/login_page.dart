import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import service & halaman tujuan
import '../services/auth_service.dart';
import 'dashboard_page.dart';
import 'register_page.dart';

// Class untuk menyimpan data sesi akun yang aktif (dipertahankan agar kompatibel dengan halaman lain)
class UserSession {
  static String activeUser = "Nadia";
  static String accountNumber = "5678901234";
  static String balance = "Rp 12.500.000";
  static double balanceAmount = 12500000.0;
  static bool rememberMe = false;

  static void setSession({
    required String name,
    required String account,
    double? balance,
  }) {
    activeUser = name;
    accountNumber = account;
    if (balance != null) {
      balanceAmount = balance;
      UserSession.balance = formatRupiah(balance);
    }
  }

  static void deduct(double amount) {
    balanceAmount = (balanceAmount - amount).clamp(0.0, double.infinity);
    balance = formatRupiah(balanceAmount);
  }

  static String formatRupiah(double value) {
    final intVal = value.toInt();
    final str = intVal.toString();
    final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formatted = str.replaceAllMapped(regExp, (Match m) => '${m[1]}.');
    return 'Rp $formatted';
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller input
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Status password, remember me, & loading
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Notifikasi pop-up yang rapi
  void _showNotification(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF1B41A8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Fungsi proses login terintegrasi
  Future<void> _handleLogin() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    // 1. Validasi input
    if (identifier.isEmpty) {
      _showNotification('Email atau Nomor HP wajib diisi', isError: true);
      return;
    }

    if (password.isEmpty) {
      _showNotification('Kata sandi wajib diisi', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // 2. Verifikasi ke AuthService (bisa cek Email atau Nomor HP)
    final user = await AuthService.loginUser(identifier, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user != null) {
      // Simpan ke sesi aktif
      UserSession.setSession(
        name: user.name,
        account: user.accountNumber,
        balance: user.balance,
      );
      UserSession.rememberMe = _rememberMe;

      _showNotification('Selamat datang kembali, ${user.name}!', isError: false);

      // 3. Masuk ke Dashboard dengan nama akun yang sebenarnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            userName: user.name,
            accountNumber: user.accountNumber,
            balance: UserSession.formatRupiah(user.balance),
          ),
        ),
        (route) => false,
      );
    } else {
      _showNotification(
        'Email/No HP atau kata sandi salah. Silakan periksa kembali atau daftar akun baru.',
        isError: true,
      );
    }
  }

  // Navigasi Lupa Kata Sandi
  void _goToForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Silakan hubungi Call Center atau cek email pemulihan.',
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Navigasi ke Daftar Akun
  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF3B64D8),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // ================= 1. HEADER ATAS GRADASI =================
            Container(
              width: double.infinity,
              height: screenSize.height * 0.35,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF3358D4),
                    Color(0xFF5577DC),
                    Color(0xFFA197DC),
                    Color(0xFFBCAEE5),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: -40,
                    top: 50,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -30,
                    top: -20,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 26,
                          ),
                          tooltip: 'Kembali',
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            "LET'S PAY",
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= 2. KARTU PUTIH FORM LOGIN =================
            Positioned(
              top: screenSize.height * 0.22,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(42),
                    topRight: Radius.circular(42),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 36),

                        Text(
                          'Masuk Ke Akunmu',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Lanjutkan untuk menggunakan\nLET’S PAY',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Input Email / HP
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.black87,
                              width: 1.2,
                            ),
                          ),
                          child: TextField(
                            controller: _identifierController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Email atau Nomor HP',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Input Kata Sandi
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.black87,
                              width: 1.2,
                            ),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _handleLogin(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Kata Sandi',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.black87,
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Tombol Masuk
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF6B87DC),
                                Color(0xFFC7B1E4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6B87DC).withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
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
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Masuk',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Ingat Saya & Lupa Kata Sandi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) {
                                      setState(() {
                                        _rememberMe = val ?? false;
                                      });
                                    },
                                    activeColor: const Color(0xFF6B87DC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                      color: Colors.black87,
                                      width: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _rememberMe = !_rememberMe;
                                    });
                                  },
                                  child: Text(
                                    'Ingat saya?',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: _goToForgotPassword,
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                'Lupa kata sandi?',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2546C4),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 60),

                        // Link Daftar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun? ',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            GestureDetector(
                              onTap: _goToRegister,
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                'Daftar',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}