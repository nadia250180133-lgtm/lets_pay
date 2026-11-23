import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pin_confirmation_page.dart';
import 'login_page.dart';

class BpjsPaymentPage extends StatefulWidget {
  final String programName;
  final String logoAsset;
  final String? senderName;
  final String? senderAccount;
  final String? currentBalance;

  const BpjsPaymentPage({
    super.key,
    this.programName = 'BPJS Kesehatan',
    this.logoAsset = 'assets/images/bpjs_kesehatan.png',
    this.senderName,
    this.senderAccount,
    this.currentBalance,
  });

  @override
  State<BpjsPaymentPage> createState() => _BpjsPaymentPageState();
}

class _BpjsPaymentPageState extends State<BpjsPaymentPage> {
  final TextEditingController _vaController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _vaController.addListener(_validateInputs);
    _amountController.addListener(_validateInputs);
  }

  void _validateInputs() {
    final rawAmount = _amountController.text.replaceAll('.', '').replaceAll(',', '').trim();
    final isValid = _vaController.text.trim().isNotEmpty &&
        rawAmount.isNotEmpty &&
        (double.tryParse(rawAmount) ?? 0) > 0;

    if (isValid != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isValid;
      });
    }
  }

  @override
  void dispose() {
    _vaController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String get _effectiveSenderName => (widget.senderName != null && widget.senderName!.isNotEmpty)
      ? widget.senderName!
      : UserSession.activeUser;
  String get _effectiveSenderAccount => (widget.senderAccount != null && widget.senderAccount!.isNotEmpty)
      ? widget.senderAccount!
      : UserSession.accountNumber;
  double get _effectiveCurrentBalance => (widget.currentBalance != null && double.tryParse(widget.currentBalance!) != null)
      ? double.parse(widget.currentBalance!)
      : UserSession.balanceAmount;

  // ==========================================================================
  // AKSI TOMBOL LANJUTKAN (TERHUBUNG KE PIN & TRANSAKSI)
  // ==========================================================================
  void _onContinuePressed() {
    if (!_isButtonEnabled) return;

    final rawAmountString = _amountController.text.replaceAll('.', '').replaceAll(',', '').trim();
    final double amount = double.tryParse(rawAmountString) ?? 0.0;
    final String vaNumber = _vaController.text.trim();
    const double adminFee = 2500.0;

    // Membuat objek TransactionModel sesuai struktur data proyek Anda
    final transactionData = TransactionModel(
      transactionType: 'BPJS',
      recipientName: widget.programName, // BPJS Kesehatan
      provider: 'BPJS Kesehatan',
      accountNumber: vaNumber,
      sourceAccountName: _effectiveSenderName,
      sourceBank: "LET'S PAY",
      sourceAccountNumber: _effectiveSenderAccount,
      amount: amount,
      adminFee: adminFee,
      dateTime: DateTime.now(),
    );

    // Buka Bottom Sheet Konfirmasi Pembayaran Sesuai Alur Terintegrasi (Gambar 3)
    showPaymentConfirmationBottomSheet(
      context: context,
      transaction: transactionData,
      currentBalance: _effectiveCurrentBalance,
    );
  }

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
              Color(0xFFE8E9F6),
              Color(0xFFEEEFFB),
              Color(0xFFF8F5FE),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Back Button + Judul
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Text(
                      'BPJS',
                      style: TextStyle(
                        color: Color(0xFF0F2B5C),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Konten
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // A. Penyedia Layanan
                        const Text(
                          'Penyedia Layanan',
                          style: TextStyle(
                            color: Color(0xFF0F2B5C),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              _buildBpjsLogo(widget.logoAsset),
                              const SizedBox(width: 14),
                              Text(
                                widget.programName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // B. Nomor VA
                        const Text(
                          'Nomor VA',
                          style: TextStyle(
                            color: Color(0xFF0F2B5C),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _vaController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Masukkan nomor VA',
                              hintStyle: TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xFF556080),
                                size: 22,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // C. Total
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: Color(0xFF0F2B5C),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _RupiahInputFormatter(),
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Masukkan nominal',
                              hintStyle: TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 14,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 16, right: 10),
                                child: Text(
                                  'Rp',
                                  style: TextStyle(
                                    color: Color(0xFF0F2B5C),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // D. Tombol Lanjutkan
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled ? _onContinuePressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F2B5C),
                      disabledBackgroundColor: const Color(0xFF0F2B5C).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: _isButtonEnabled ? 4 : 0,
                    ),
                    child: const Text(
                      'Lanjutkan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  Widget _buildBpjsLogo(String assetPath) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.health_and_safety, color: Colors.teal, size: 28);
          },
        ),
      ),
    );
  }
}

class _RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final chars = cleanText.split('').reversed.toList();
    final buffer = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(chars[i]);
    }
    final formattedText = buffer.toString().split('').reversed.join('');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}