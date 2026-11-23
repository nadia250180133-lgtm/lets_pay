import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'transfer_page.dart';
// Import halaman login untuk logout
import 'login_page.dart';
import 'topup_page.dart';
import 'virtual_account_page.dart';
import 'pln_page.dart';
import 'profile_page.dart' show ProfilePage;
import 'qris_page.dart';
import 'pulsa_data_page.dart';
import 'bpjs_program_page.dart';
import 'prayer_time_page.dart';
import 'notification_page.dart';
import '../services/auth_service.dart';

class DashboardPage extends StatefulWidget {
  final String? userName;
  final String? accountNumber;
  final String? balance;

  const DashboardPage({
    super.key,
    this.userName,
    this.accountNumber,
    this.balance,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isSaldoVisible = false;

  // Data akun dinamis (diambil dari sesi login)
  late String _currentUserName;
  late String _nomorAkun;
  late String _saldoNominal;

  @override
  void initState() {
    super.initState();
    // Gunakan nama akun yang diteruskan saat login, atau default dari sesi
    _currentUserName = widget.userName ?? UserSession.activeUser;
    _nomorAkun = widget.accountNumber ?? UserSession.accountNumber;
    _saldoNominal = widget.balance ?? UserSession.balance;
    _refreshUserData();
  }

  // Fungsi menyegarkan data user & saldo secara real-time
  Future<void> _refreshUserData() async {
    final liveUser = await AuthService.getCurrentUser();
    if (mounted) {
      setState(() {
        if (liveUser != null) {
          _currentUserName = liveUser.name;
          _nomorAkun = liveUser.accountNumber;
          _saldoNominal = UserSession.formatRupiah(liveUser.balance);
        } else {
          _currentUserName = UserSession.activeUser;
          _nomorAkun = UserSession.accountNumber;
          _saldoNominal = UserSession.balance;
        }
      });
    }
  }

  // Fungsi menyalin nomor rekening
  void _copyNomorAkun() {
    Clipboard.setData(ClipboardData(text: _nomorAkun));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Nomor akun $_nomorAkun disalin!',
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Fungsi keluar akun (Logout)
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Keluar Akun',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun $_currentUserName?',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B3E9E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: Text('Keluar', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // NAVIGASI FITUR TRANSAKSI
  // =========================================================================

  void _navigateToFeature(String featureName, Widget? targetPage) {
    if (targetPage != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
    } else {
      // Jika fitur belum dibuat / halaman sedang dalam pengembangan
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeatureComingSoonPage(featureName: featureName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE7F6), // Background soft lilac sesuai desain
      
      // ================= 1. KONTEN DASHBOARD (SCROLLABLE SECARA PENUH) =================
      body: Stack(
        children: [
          // Background Header Gradasi Biru
          Container(
            height: 230,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1B3E9E),
                  Color(0xFF264DBF),
                  Color(0xFF335DD6),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              // Padding bawah 110 agar saat scroll ke paling bawah, banner promo tidak tertutup Bottom Bar
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER: Foto Profil, "Halo, [Nama]!", Lonceng & Logout ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF2042A5),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Halo, $_currentUserName!', // NAMA DINAMIS
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // TOMBOL NOTIFIKASI -> TERHUBUNG LANGSUNG KE NotificationPage
                        IconButton(
                          onPressed: () {
                            _navigateToFeature('Notifikasi', const NotificationPage());
                          },
                          icon: const Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        IconButton(
                          onPressed: _handleLogout,
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- KARTU 1: SUMBER AKUN UTAMA ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Color(0xFFE4DAF5), // Gradasi lilac di bawah kartu
                          ],
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sumber Akun Utama',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                _nomorAkun,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: _copyNomorAkun,
                                behavior: HitTestBehavior.opaque,
                                child: const Icon(
                                  Icons.copy_outlined,
                                  size: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Total Saldo',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                _isSaldoVisible ? _saldoNominal : 'Rp • • • • •',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  letterSpacing: _isSaldoVisible ? 0.5 : 2.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSaldoVisible = !_isSaldoVisible;
                                  });
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Icon(
                                  _isSaldoVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- KARTU 2: LAYANAN TRANSAKSI UTAMA ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Layanan Transaksi Utama',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMenuButton(
                          icon: Icons.swap_horiz,
                          label: 'Transfer',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransferPage(
                                  senderName: _currentUserName,
                                  senderAccount: _nomorAkun,
                                  currentBalance: UserSession.balanceAmount,
                                ),
                              ),
                            ).then((_) => _refreshUserData());
                          },
                        ),
                        _buildMenuButton(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Top up',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TopUpPage(
                                  senderName: _currentUserName,
                                  senderAccount: _nomorAkun,
                                  currentBalance: UserSession.balanceAmount,
                                ),
                              ),
                            ).then((_) => _refreshUserData());
                          },
                        ),
                        // TOMBOL VA: Terhubung ke VirtualAccountPage
                        _buildMenuButton(
                          icon: Icons.receipt_long_outlined,
                          label: 'VA',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VirtualAccountPage(
                                  senderName: _currentUserName,
                                  senderAccount: _nomorAkun,
                                  currentBalance: UserSession.balanceAmount,
                                ),
                              ),
                            ).then((_) => _refreshUserData());
                          },
                        ),
                        // TOMBOL QRIS: Terhubung ke QrisPage
                        _buildMenuButton(
                          icon: Icons.crop_free,
                          label: 'QRIS',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const QrisPage()),
                            ).then((_) => _refreshUserData());
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- KARTU 3: KATEGORI LAINNYA ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Kategori Lainnya',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // TOMBOL PULSA & DATA: Terhubung langsung ke PulsaDataPage
                        _buildMenuButton(
                          icon: Icons.smartphone,
                          label: 'Pulsa & Data',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PulsaDataPage(
                                  senderName: _currentUserName,
                                  senderAccount: _nomorAkun,
                                  currentBalance: UserSession.balanceAmount,
                                ),
                              ),
                            ).then((_) => _refreshUserData());
                          },
                        ),
                        _buildMenuButton(
                          icon: Icons.bolt,
                          label: 'PLN',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlnPage(
                                  senderName: _currentUserName,
                                  senderAccount: _nomorAkun,
                                  currentBalance: UserSession.balanceAmount,
                                ),
                              ),
                            ).then((_) => _refreshUserData());
                          },
                        ),
                        _buildMenuButton(
                          icon: Icons.favorite_outline,
                          label: 'BPJS',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BpjsProgramPage(
                                  senderName: _currentUserName,
                                  senderAccount: _nomorAkun,
                                  currentBalance: _saldoNominal,
                                ),
                              ),
                            ).then((_) => _refreshUserData());
                          },
                        ),
                        // TOMBOL LAINNYA: Terhubung langsung ke PrayerTimePage (Waktu Sholat)
                        _buildMenuButton(
                          icon: Icons.grid_view,
                          label: 'Lainnya',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrayerTimePage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- KARTU 4: PROMO & DISKON ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Promo & Diskon',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlnPage(
                              senderName: _currentUserName,
                              senderAccount: _nomorAkun,
                              currentBalance: UserSession.balanceAmount,
                            ),
                          ),
                        ).then((_) => _refreshUserData());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFF143B8A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            // Ornamen transparan
                            Positioned(
                              left: 10,
                              top: 10,
                              child: Container(
                                width: 60,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 35,
                              top: 40,
                              child: Container(
                                width: 60,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'KHUSUS UNTUK ANDA',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Isi Ulang Token Listrik? GAMPANG',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Dapatkan cashback hingga 20%',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Hanya dari transaksi 10 Ribu bisa dapat diskon!!',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // ================= 2. FIXED BOTTOM NAVIGATION BAR =================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 84,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 70,
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tombol Beranda (Aktif)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.home,
                              color: Color(0xFF1B3E9E),
                              size: 28,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Beranda',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 60),

                        // Tombol Profil (Langsung buka ProfilePage)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: const RouteSettings(name: 'ProfilePage'),
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.grey.shade400,
                                size: 28,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Profil',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol Bulat Kuning QRIS (Floating di tengah) -> TERHUBUNG KE QrisPage
                  Positioned(
                    top: -12,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QrisPage(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9B815),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFF9B815).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'QRIS',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              letterSpacing: 0.5,
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
        ],
      ),
    );
  }

  // Helper widget tombol menu
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF869EC4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF142B59),
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// Halaman Coming Soon untuk fitur yang belum dibuat
class FeatureComingSoonPage extends StatelessWidget {
  final String featureName;

  const FeatureComingSoonPage({super.key, required this.featureName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3E9E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          featureName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF869EC4).withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  size: 48,
                  color: Color(0xFF1B3E9E),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Fitur $featureName Segera Hadir',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}