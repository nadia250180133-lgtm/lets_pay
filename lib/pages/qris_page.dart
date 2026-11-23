import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import PinConfirmationPage & TransactionModel
import 'pin_confirmation_page.dart';
import 'login_page.dart';

// Import Service dan Model Notifikasi
import '../services/notification_service.dart';
import '../models/notification_model.dart';

class QrisPage extends StatefulWidget {
  const QrisPage({super.key});

  @override
  State<QrisPage> createState() => _QrisPageState();
}

class _QrisPageState extends State<QrisPage> {
  bool _isFlashOn = false;

  // Fungsi proses pembayaran QRIS ke PinConfirmationPage
  Future<void> _prosesBayarQris({
    required String merchantName,
    required double amount,
  }) async {
    final transaction = TransactionModel(
      transactionType: 'QRIS',
      recipientName: merchantName,
      provider: 'QRIS',
      accountNumber: 'NMID: ID102003004050',
      sourceAccountName: UserSession.activeUser,
      sourceBank: "LET'S PAY",
      sourceAccountNumber: UserSession.accountNumber,
      amount: amount,
      adminFee: 0.0,
      dateTime: DateTime.now(),
    );

    // Navigasi ke PinConfirmationPage dan menunggu hasil konfirmasi PIN
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinConfirmationPage(
          transaction: transaction,
        ),
      ),
    );

    // ========================================================================
    // JIKA PEMBAYARAN DI PIN BERHASIL (result == true)
    // ========================================================================
    if (result == true) {
      final formattedAmount = TransactionModel.formatRupiah(amount);

      // Pemicu Notifikasi Real-time sesuai Gambar Referensi 1 & 2
      await NotificationService.instance.addTransactionNotification(
        transactionId: 'qris_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Pembayaran QRIS Kamu Berhasil!',
        description:
            'Pembayaran $formattedAmount di $merchantName sukses! Terima kasih telah bertransaksi.',
        type: TransactionType.qris,
        amount: amount,
        recipient: merchantName,
      );
    }
  }

  // Dialog Konfirmasi Pembayaran QRIS saat barcode terdeteksi / galeri dipilih
  void _showQrisConfirmationDialog({
    String merchant = 'Kopi Kenangan - Plaza',
    double amount = 28000.0,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Konfirmasi Pembayaran QRIS',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D254C),
                ),
              ),
              const SizedBox(height: 14),

              // Info Merchant
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAA612),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.storefront, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            merchant,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D254C),
                            ),
                          ),
                          Text(
                            'NMID: ID102003004050',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nominal', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
                  Text(
                    TransactionModel.formatRupiah(amount),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D254C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Biaya Layanan', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
                  Text('Rp 0', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Pembayaran', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF0D254C))),
                  Text(
                    TransactionModel.formatRupiah(amount),
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0D254C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tombol Lanjut ke PIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D254C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _prosesBayarQris(
                      merchantName: merchant,
                      amount: amount,
                    );
                  },
                  child: Text(
                    'Lanjutkan ke PIN',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Scan QRIS', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Arahkan kamera ke kode QRIS pembayaran',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 30),

          // Area Kotak Scanner QRIS (Tap untuk simulasi scan)
          Center(
            child: GestureDetector(
              onTap: () {
                _showQrisConfirmationDialog();
              },
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEAA612), width: 3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.qr_code_scanner_rounded, size: 100, color: Colors.white30),
                    Positioned(
                      bottom: 12,
                      child: Text(
                        'LET\'S PAY QRIS',
                        style: GoogleFonts.poppins(color: const Color(0xFFEAA612), fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Tombol Lampu Kilat & Galeri
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isFlashOn = !_isFlashOn;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isFlashOn ? 'Lampu kilat dinyalakan' : 'Lampu kilat dimatikan'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: _isFlashOn ? const Color(0xFFEAA612) : Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 40),
              IconButton(
                onPressed: () {
                  // Simulasi memilih QR dari Galeri
                  _showQrisConfirmationDialog(
                    merchant: 'Indomaret Point',
                    amount: 45000.0,
                  );
                },
                icon: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Tombol Petunjuk Tap Layar
          TextButton(
            onPressed: () => _showQrisConfirmationDialog(),
            child: Text(
              'Tekan kotak untuk simulasi scan',
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}