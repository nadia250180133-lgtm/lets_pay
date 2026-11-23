import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import 'profile_page.dart' hide AuthService;

// ============================================================================
// 1. HALAMAN MASUKKAN PIN LAMA (SCREENSHOT 2 & 3)
// ============================================================================
class ChangePinOldPage extends StatefulWidget {
  const ChangePinOldPage({super.key});

  @override
  State<ChangePinOldPage> createState() => _ChangePinOldPageState();
}

class _ChangePinOldPageState extends State<ChangePinOldPage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _currentPin = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onPinChanged(String value) {
    setState(() {
      _currentPin = value;
    });
  }

  Future<void> _handleContinue() async {
    if (_currentPin.length != 5) return;

    final isValid = await AuthService.verifyPin(_currentPin);
    if (!mounted) return;

    if (isValid) {
      // PIN Benar -> Lanjut ke Halaman Atur PIN Baru
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChangePinNewPage(),
        ),
      );
    } else {
      // PIN Salah -> Tampilkan Pesan Error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN lama yang kamu masukkan salah. Silakan coba lagi.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      _pinController.clear();
      setState(() {
        _currentPin = '';
      });
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2040),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Ornamen Lingkaran Biru Keabu-abuan
              Positioned(
                top: -30,
                left: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7E84AC),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: -50,
                right: -40,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xFF888FB8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  // Header Bar (Back button & LET'S PAY)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Text(
                          "LET’S PAY",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Konten Putih dengan Rounding Melengkung
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(36),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 36),
                                  const Text(
                                    'Masukkan PIN Lama',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    'Masukkan 5 digit PIN Transaksi kamu',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 48),

                                  // 5 Kotak Input PIN
                                  GestureDetector(
                                    onTap: () => _focusNode.requestFocus(),
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: List.generate(5, (index) {
                                        final isFilled = index < _currentPin.length;
                                        return Container(
                                          width: 54,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Colors.black87,
                                              width: 1.2,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: isFilled
                                              ? Text(
                                                  _currentPin[index],
                                                  style: const TextStyle(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : null,
                                        );
                                      }),
                                    ),
                                  ),

                                  // Hidden TextField untuk menerima input keyboard
                                  Opacity(
                                    opacity: 0.0,
                                    child: SizedBox(
                                      height: 1,
                                      width: 1,
                                      child: TextField(
                                        controller: _pinController,
                                        focusNode: _focusNode,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(5),
                                        ],
                                        onChanged: _onPinChanged,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Tombol Lanjutkan (Hanya muncul jika PIN sudah 5 digit)
                          if (_currentPin.length == 5)
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 36),
                              child: SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _handleContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF132F65),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Lanjutkan',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 2. HALAMAN ATUR PIN BARU (SCREENSHOT 4 & 5)
// ============================================================================
class ChangePinNewPage extends StatefulWidget {
  const ChangePinNewPage({super.key});

  @override
  State<ChangePinNewPage> createState() => _ChangePinNewPageState();
}

class _ChangePinNewPageState extends State<ChangePinNewPage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _currentPin = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onPinChanged(String value) {
    setState(() {
      _currentPin = value;
    });
  }

  Future<void> _handleSavePin() async {
    if (_currentPin.length != 5) return;

    // Simpan PIN baru ke penyimpanan data akun pengguna secara permanen
    await AuthService.updateUserPin(_currentPin);
    if (!mounted) return;

    // Pindah ke Halaman PIN Berhasil Diganti
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePinSuccessPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2040),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Ornamen Lingkaran Biru Keabu-abuan
              Positioned(
                top: -30,
                left: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7E84AC),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: -50,
                right: -40,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xFF888FB8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  // Header Bar (Back button & LET'S PAY)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Text(
                          "LET’S PAY",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Konten Putih dengan Rounding Melengkung
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(36),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 36),
                                  const Text(
                                    'Atur PIN Baru',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    'Masukkan 5 digit PIN baru kamu',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 48),

                                  // 5 Kotak Input PIN
                                  GestureDetector(
                                    onTap: () => _focusNode.requestFocus(),
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: List.generate(5, (index) {
                                        final isFilled = index < _currentPin.length;
                                        return Container(
                                          width: 54,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Colors.black87,
                                              width: 1.2,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: isFilled
                                              ? Text(
                                                  _currentPin[index],
                                                  style: const TextStyle(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : null,
                                        );
                                      }),
                                    ),
                                  ),

                                  // Hidden TextField untuk menerima input keyboard
                                  Opacity(
                                    opacity: 0.0,
                                    child: SizedBox(
                                      height: 1,
                                      width: 1,
                                      child: TextField(
                                        controller: _pinController,
                                        focusNode: _focusNode,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(5),
                                        ],
                                        onChanged: _onPinChanged,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Tombol Lanjutkan (Hanya muncul jika PIN baru sudah 5 digit)
                          if (_currentPin.length == 5)
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 36),
                              child: SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _handleSavePin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF132F65),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Lanjutkan',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 3. HALAMAN PIN BERHASIL DIGANTI
// ============================================================================
class ChangePinSuccessPage extends StatelessWidget {
  const ChangePinSuccessPage({super.key});

  void _goToProfile(BuildContext context) {
    bool poppedToProfile = false;
    Navigator.popUntil(context, (route) {
      if (route.settings.name == 'ProfilePage') {
        poppedToProfile = true;
        return true;
      }
      return route.isFirst;
    });

    if (!poppedToProfile) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: 'ProfilePage'),
          builder: (context) => const ProfilePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2040),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Ornamen Lingkaran Biru Keabu-abuan
              Positioned(
                top: -30,
                left: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7E84AC),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: -50,
                right: -40,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xFF888FB8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  // Header Bar (Back button & LET'S PAY)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                            onPressed: () => _goToProfile(context),
                          ),
                        ),
                        const Text(
                          "LET’S PAY",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Konten Putih dengan Rounding Melengkung
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(36),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),

                          // Ikon Perisai dengan Centang
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFE2EAF8),
                              border: Border.all(
                                color: const Color(0xFF132F65),
                                width: 2.2,
                              ),
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              size: 48,
                              color: Color(0xFF132F65),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Tulisan SELAMAT
                          const Text(
                            'SELAMAT',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Tombol / Indikator Biru "PIN Berhasil Diganti"
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => _goToProfile(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF3B72FF), Color(0xFFD3D8FD)],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Text(
                                  'PIN Berhasil Diganti',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
