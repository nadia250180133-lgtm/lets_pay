import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/notification_service.dart';
import '../models/notification_model.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

// =========================================================================
// 1. MODEL TRANSAKSI (DINAMIS UNTUK SEMUA FITUR PEMBAYARAN)
// =========================================================================
class TransactionModel {
  final String transactionType;
  final String recipientName;
  final String provider;
  final String accountNumber;
  final String sourceAccountName;
  final String sourceBank;
  final String sourceAccountNumber;
  final double amount;
  final double adminFee;
  final DateTime dateTime;
  final String receiptNumber;
  final String transactionNumber;
  final String terminalId;

  TransactionModel({
    required this.transactionType,
    required this.recipientName,
    required this.provider,
    required this.accountNumber,
    String? sourceAccountName,
    this.sourceBank = "LET'S PAY",
    String? sourceAccountNumber,
    required this.amount,
    this.adminFee = 0.0,
    DateTime? dateTime,
    String? receiptNumber,
    String? transactionNumber,
    this.terminalId = '*********7890',
  })  : sourceAccountName = (sourceAccountName != null && sourceAccountName.isNotEmpty)
            ? sourceAccountName
            : UserSession.activeUser,
        sourceAccountNumber = (sourceAccountNumber != null && sourceAccountNumber.isNotEmpty)
            ? sourceAccountNumber
            : UserSession.accountNumber,
        dateTime = dateTime ?? DateTime.now(),
        receiptNumber = receiptNumber ?? _generateReceiptNumber(),
        transactionNumber = transactionNumber ?? _generateTransactionNumber();

  double get totalAmount => amount + adminFee;

  static String _generateReceiptNumber() {
    final random = Random();
    return '033${random.nextInt(89999999) + 10000000}${DateTime.now().year}';
  }

  static String _generateTransactionNumber() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final code = List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
    return 'FT262$code';
  }

  static String formatRupiah(double value) {
    final intVal = value.toInt();
    final str = intVal.toString();
    final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formatted = str.replaceAllMapped(regExp, (Match m) => '${m[1]}.');
    return 'Rp $formatted';
  }
}

// =========================================================================
// 2. MODAL BOTTOM SHEET: KONFIRMASI PEMBAYARAN (SESUAI GAMBAR 3)
// Digunakan secara terintegrasi oleh Transfer, Top Up, VA, Pulsa/Data, PLN, BPJS
// =========================================================================
void showPaymentConfirmationBottomSheet({
  required BuildContext context,
  required TransactionModel transaction,
  required double currentBalance,
  String? customItemLabel,
  String? customItemValue,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) {
      final initialLetter = transaction.sourceAccountName.trim().isNotEmpty
          ? transaction.sourceAccountName.trim()[0].toUpperCase()
          : 'U';

      final String adminFeeText = transaction.adminFee == 0
          ? 'Gratis (Rp 0)'
          : TransactionModel.formatRupiah(transaction.adminFee);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                'Konfirmasi Pembayaran',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF132F65),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildSheetRow('Jenis Transaksi', transaction.transactionType),
            const SizedBox(height: 10),
            _buildSheetRow(
              transaction.transactionType.toLowerCase().contains('transfer')
                  ? 'Bank / Tujuan'
                  : (transaction.transactionType.toLowerCase().contains('pulsa') ||
                          transaction.transactionType.toLowerCase().contains('paket')
                      ? 'Operator'
                      : 'Penyedia Layanan'),
              transaction.provider,
            ),
            const SizedBox(height: 10),
            _buildSheetRow(
              transaction.transactionType.toLowerCase().contains('pulsa') ||
                      transaction.transactionType.toLowerCase().contains('paket')
                  ? 'Nomor Handphone'
                  : (transaction.transactionType.toLowerCase().contains('pln')
                      ? 'No. Meter / ID Pel'
                      : (transaction.transactionType.toLowerCase().contains('virtual')
                          ? 'Nomor Virtual Account'
                          : 'Nomor Tujuan')),
              transaction.accountNumber,
            ),
            if (customItemLabel != null && customItemValue != null) ...[
              const SizedBox(height: 10),
              _buildSheetRow(customItemLabel, customItemValue),
            ] else ...[
              const SizedBox(height: 10),
              _buildSheetRow('Nominal', TransactionModel.formatRupiah(transaction.amount)),
            ],
            const SizedBox(height: 10),
            _buildSheetRow('Biaya Admin', adminFeeText),
            const Divider(height: 24, thickness: 1, color: Color(0xFFF1F1F5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Pembayaran',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  TransactionModel.formatRupiah(transaction.totalAmount),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E5BB8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card Rekening Sumber (Dinamis Akun Login: Nama, Inisial, Saldo)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EDF7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCE93D8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        initialLetter,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.sourceAccountName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${TransactionModel.formatRupiah(currentBalance)},00',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Bayar Sekarang -> Membuka PinConfirmationPage satu pintu
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF132F65),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(modalContext); // Tutup bottomsheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PinConfirmationPage(
                        transaction: transaction,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Bayar Sekarang',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildSheetRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: const Color(0xFF6B7280),
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(width: 12),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    ],
  );
}

// =========================================================================
// 3. HALAMAN KONFIRMASI PIN (SESUAI GAMBAR 2)
// Mendukung Keypad Numpad Layar dan Keyboard Fisik Laptop / HP
// =========================================================================
class PinConfirmationPage extends StatefulWidget {
  final TransactionModel transaction;
  final String? correctPin;

  const PinConfirmationPage({
    super.key,
    required this.transaction,
    this.correctPin,
  });

  @override
  State<PinConfirmationPage> createState() => _PinConfirmationPageState();
}

class _PinConfirmationPageState extends State<PinConfirmationPage> {
  final FocusNode _focusNode = FocusNode();
  String _currentPin = '';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onKeyPress(String val) {
    if (_currentPin.length < 5) {
      setState(() {
        _currentPin += val;
        _isError = false;
      });
      if (_currentPin.length == 5) {
        _verifyPin(_currentPin);
      }
    }
  }

  void _onBackspace() {
    if (_currentPin.isNotEmpty) {
      setState(() {
        _currentPin = _currentPin.substring(0, _currentPin.length - 1);
        _isError = false;
      });
    }
  }

  Future<void> _recordTransactionNotification(TransactionModel trx) async {
    final typeLower = trx.transactionType.toLowerCase();
    TransactionType notifType = TransactionType.lainnya;

    if (typeLower.contains('qris')) {
      notifType = TransactionType.qris;
    } else if (typeLower.contains('pulsa')) {
      notifType = TransactionType.pulsa;
    } else if (typeLower.contains('paket') || typeLower.contains('data')) {
      notifType = TransactionType.paketData;
    } else if (typeLower.contains('virtual') || typeLower.contains('va')) {
      notifType = TransactionType.virtualAccount;
    } else if (typeLower.contains('pln') || typeLower.contains('listrik')) {
      notifType = TransactionType.pln;
    } else if (typeLower.contains('wallet') ||
        typeLower.contains('gopay') ||
        typeLower.contains('dana') ||
        typeLower.contains('ovo') ||
        typeLower.contains('shopeepay') ||
        typeLower.contains('top up')) {
      notifType = TransactionType.ewallet;
    } else if (typeLower.contains('bca')) {
      notifType = TransactionType.transferBca;
    } else if (typeLower.contains('transfer') || typeLower.contains('bank')) {
      notifType = TransactionType.transferBank;
    }

    final totalAmount = trx.totalAmount;
    final formattedAmount = NotificationService.formatRupiah(totalAmount);

    await NotificationService.instance.addTransactionNotification(
      transactionId: trx.transactionNumber.isNotEmpty
          ? trx.transactionNumber
          : trx.receiptNumber,
      title: '${trx.transactionType} Berhasil',
      description:
          'Pembayaran ${trx.provider} ke ${trx.recipientName} (${trx.accountNumber}) sebesar $formattedAmount berhasil diproses.',
      type: notifType,
      amount: totalAmount,
      recipient: trx.recipientName,
    );
  }

  Future<void> _verifyPin(String enteredPin) async {
    final activePin = widget.correctPin ?? await AuthService.getUserPin();
    if (enteredPin == activePin) {
      // 1. Kurangi Saldo Pengguna yang Sedang Login
      await AuthService.deductUserBalance(widget.transaction.totalAmount);

      // 2. Catat Notifikasi
      await _recordTransactionNotification(widget.transaction);

      if (!mounted) return;

      // 3. Langsung Pindah ke Transaksi Berhasil (Gambar 4)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TransaksiBerhasilScreen(
            transaction: widget.transaction,
          ),
        ),
      );
    } else {
      if (!mounted) return;
      setState(() {
        _isError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PIN yang kamu masukkan salah. Silakan coba lagi.',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(milliseconds: 350), () {
        if (!mounted) return;
        setState(() {
          _currentPin = '';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF132F65), // Biru gelap atas
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: RawKeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKey: (event) {
            if (event is RawKeyDownEvent) {
              final keyLabel = event.logicalKey.keyLabel;
              if (RegExp(r'^[0-9]$').hasMatch(keyLabel)) {
                _onKeyPress(keyLabel);
              } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
                _onBackspace();
              }
            }
          },
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                // Ornamen Lingkaran Header
                Positioned(
                  top: -30,
                  left: -30,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7E84AC).withOpacity(0.3),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFF888FB8).withOpacity(0.25),
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
                          Text(
                            "LET'S PAY",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Konten Putih dengan Rounding Besar
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 32),
                            Text(
                              'Konfirmasi PIN',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Masukkan 5 digit PIN Transaksi kamu',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF4B5563),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 36),

                            // 5 Kotak Input PIN (Gambar 2)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  final isFilled = index < _currentPin.length;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    width: 52,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _isError
                                            ? Colors.red
                                            : (isFilled
                                                ? const Color(0xFF132F65)
                                                : Colors.black87),
                                        width: 1.3,
                                      ),
                                    ),
                                    child: Center(
                                      child: isFilled
                                          ? Container(
                                              width: 14,
                                              height: 14,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFF132F65),
                                              ),
                                            )
                                          : null,
                                    ),
                                  );
                                }),
                              ),
                            ),

                            const Spacer(),

                            // Keypad Numpad Layar Sesuai Gambar 2
                            _buildKeypad(),
                            const SizedBox(height: 24),
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
      ),
    );
  }

  Widget _buildKeypad() {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'backspace'],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: rows.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((val) {
                if (val.isEmpty) {
                  return const SizedBox(width: 72, height: 50);
                }
                if (val == 'backspace') {
                  return InkWell(
                    onTap: _onBackspace,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 72,
                      height: 50,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.backspace_outlined,
                        size: 26,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }
                return InkWell(
                  onTap: () => _onKeyPress(val),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 72,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      val,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// =========================================================================
// 4. HALAMAN TRANSAKSI BERHASIL (SESUAI GAMBAR 4)
// Satu halaman tunggal untuk seluruh fitur transaksi dengan data dinamis
// =========================================================================
class TransaksiBerhasilScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransaksiBerhasilScreen({
    super.key,
    required this.transaction,
  });

  String _formatReceiptDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final day = dt.day;
    final month = months[dt.month - 1];
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');
    return '$day $month $year • $hour:$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    final bool isTransfer = transaction.transactionType.toLowerCase().contains('transfer');

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4C67C8),
                Color(0xFF737EC7),
                Color(0xFFA6A6D0),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Top Bar (Back Arrow, Logo LET'S PAY, Tagline, Forward Arrow)
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "LET'S PAY",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const Spacer(),

                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Dompet Digital",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Untuk Hidup Lebih Praktis",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                          tooltip: 'Kembali ke Dashboard',
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Centang Hijau
                    Container(
                      width: 76,
                      height: 76,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Transaksi Berhasil',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF14172C),
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      _formatReceiptDate(transaction.dateTime),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF2C324E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Ribbon Bar Nominal (Sesuai Gambar 4)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A6894).withOpacity(0.55),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isTransfer ? 'Nominal Transfer' : 'Nominal Pembayaran',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: const Color(0xFF101828),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            TransactionModel.formatRupiah(transaction.amount).toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF101828),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Nama Penerima
                    _buildReceiptItem(
                      'Nama Penerima',
                      transaction.recipientName,
                      subText1: transaction.provider,
                      subText2: transaction.accountNumber,
                    ),
                    const SizedBox(height: 14),

                    // Rekening Sumber (Dinamis Akun Login)
                    _buildReceiptItem(
                      'Rekening Sumber',
                      transaction.sourceAccountName,
                      subText1: transaction.sourceBank,
                      subText2: transaction.sourceAccountNumber,
                    ),
                    const SizedBox(height: 14),

                    // Nominal Transaksi
                    _buildSimpleRow(
                      isTransfer ? 'Nominal Transfer' : 'Nominal Transaksi',
                      TransactionModel.formatRupiah(transaction.amount),
                    ),
                    const SizedBox(height: 14),

                    // Biaya Admin
                    _buildSimpleRow(
                      'Biaya Admin',
                      TransactionModel.formatRupiah(transaction.adminFee),
                    ),
                    const SizedBox(height: 14),

                    // Total
                    _buildSimpleRow(
                      'Total',
                      TransactionModel.formatRupiah(transaction.totalAmount),
                      isBold: true,
                    ),
                    const SizedBox(height: 14),

                    // Nomor Struk
                    _buildSimpleRow(
                      'Nomor Struk',
                      transaction.receiptNumber,
                    ),
                    const SizedBox(height: 14),

                    // Nomor Transaksi
                    _buildSimpleRow(
                      'Nomor Transaksi',
                      transaction.transactionNumber,
                    ),
                    const SizedBox(height: 14),

                    // Terminal
                    _buildSimpleRow(
                      'Terminal',
                      transaction.terminalId,
                    ),
                    const SizedBox(height: 36),

                    // Catatan Penutup Sesuai Gambar 4
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Terima kasih telah menggunakan layanan\nLET’S PAY. Semoga layanan kami\nmendatangkan manfaat bagi anda.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF1A1A24),
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.5,
            color: const Color(0xFF14172C),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14.5,
            color: const Color(0xFF14172C),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptItem(String title, String primaryName,
      {String? subText1, String? subText2}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14.5,
            color: const Color(0xFF14172C),
            fontWeight: FontWeight.w500,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              primaryName,
              style: GoogleFonts.poppins(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF14172C),
              ),
            ),
            if (subText1 != null && subText1.isNotEmpty)
              Text(
                subText1,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF20263E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (subText2 != null && subText2.isNotEmpty)
              Text(
                subText2,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF20263E),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// Alias class BuktiTransaksiScreen ke TransaksiBerhasilScreen agar kompatibel
typedef BuktiTransaksiScreen = TransaksiBerhasilScreen;
