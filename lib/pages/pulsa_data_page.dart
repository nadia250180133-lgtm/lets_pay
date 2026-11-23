import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_page.dart';
import 'pin_confirmation_page.dart';

// Model Nominal Pulsa & Paket Data
class PulsaItem {
  final int nominal;
  final int harga;

  const PulsaItem({required this.nominal, required this.harga});
}

class PaketDataItem {
  final String kuota;
  final String masaAktif;
  final int harga;

  const PaketDataItem({
    required this.kuota,
    required this.masaAktif,
    required this.harga,
  });

  String get label => '$kuota / $masaAktif';
}

class PulsaDataPage extends StatefulWidget {
  final String? senderName;
  final String? senderAccount;
  final double? currentBalance;

  const PulsaDataPage({
    super.key,
    this.senderName,
    this.senderAccount,
    this.currentBalance,
  });

  @override
  State<PulsaDataPage> createState() => _PulsaDataPageState();
}

class _PulsaDataPageState extends State<PulsaDataPage> {
  bool _isPulsaSelected = true; // true = Pulsa, false = Paket Data
  String _phoneNumber = '';
  late final TextEditingController _phoneController;

  // State pilihan item
  PulsaItem? _selectedPulsa;
  PaketDataItem? _selectedPaketData;

  String get _effectiveSenderName => (widget.senderName != null && widget.senderName!.isNotEmpty)
      ? widget.senderName!
      : UserSession.activeUser;
  String get _effectiveSenderAccount => (widget.senderAccount != null && widget.senderAccount!.isNotEmpty)
      ? widget.senderAccount!
      : UserSession.accountNumber;
  double get _effectiveCurrentBalance => widget.currentBalance ?? UserSession.balanceAmount;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Daftar Pilihan Pulsa (Tetap dipertahankan)
  final List<PulsaItem> _pulsaList = const [
    PulsaItem(nominal: 15000, harga: 15000),
    PulsaItem(nominal: 25000, harga: 25000),
    PulsaItem(nominal: 50000, harga: 50000),
    PulsaItem(nominal: 100000, harga: 100000),
    PulsaItem(nominal: 150000, harga: 150000),
    PulsaItem(nominal: 200000, harga: 200000),
  ];

  // Daftar 10 Pilihan Paket Data / Kuota Sesuai Desain
  final List<PaketDataItem> _paketDataList = const [
    PaketDataItem(kuota: '3 GB', masaAktif: '3 hari', harga: 15000),
    PaketDataItem(kuota: '3 GB', masaAktif: '5 hari', harga: 20000),
    PaketDataItem(kuota: '5 GB', masaAktif: '5 hari', harga: 25000),
    PaketDataItem(kuota: '5 GB', masaAktif: '7 hari', harga: 30000),
    PaketDataItem(kuota: '7 GB', masaAktif: '14 hari', harga: 40000),
    PaketDataItem(kuota: '9 GB', masaAktif: '14 hari', harga: 50000),
    PaketDataItem(kuota: '15 GB', masaAktif: '15 hari', harga: 65000),
    PaketDataItem(kuota: '25 GB', masaAktif: '30 hari', harga: 85000),
    PaketDataItem(kuota: '50 GB', masaAktif: '30 hari', harga: 125000),
    PaketDataItem(kuota: '100 GB', masaAktif: '60 hari', harga: 200000),
  ];

  String _formatRupiah(int amount) {
    String str = amount.toString();
    return str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // Deteksi otomatis operator dari nomor HP
  String _detectOperator(String phone) {
    if (phone.startsWith('0811') ||
        phone.startsWith('0812') ||
        phone.startsWith('0813') ||
        phone.startsWith('0821') ||
        phone.startsWith('0822') ||
        phone.startsWith('0852') ||
        phone.startsWith('0853')) {
      return 'Telkomsel';
    } else if (phone.startsWith('0814') ||
        phone.startsWith('0815') ||
        phone.startsWith('0816') ||
        phone.startsWith('0855') ||
        phone.startsWith('0856') ||
        phone.startsWith('0857') ||
        phone.startsWith('0858')) {
      return 'Indosat Ooredoo';
    } else if (phone.startsWith('0817') ||
        phone.startsWith('0818') ||
        phone.startsWith('0819') ||
        phone.startsWith('0859') ||
        phone.startsWith('0877') ||
        phone.startsWith('0878')) {
      return 'XL Axiata';
    } else if (phone.startsWith('0895') ||
        phone.startsWith('0896') ||
        phone.startsWith('0897') ||
        phone.startsWith('0898') ||
        phone.startsWith('0899')) {
      return 'Tri (3)';
    } else if (phone.startsWith('0881') ||
        phone.startsWith('0882') ||
        phone.startsWith('0883') ||
        phone.startsWith('0888')) {
      return 'Smartfren';
    }
    return 'Operator Seluler';
  }

  void _proceedToConfirmation() {
    FocusScope.of(context).unfocus();

    if (_phoneNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor handphone minimal 10 digit!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_isPulsaSelected && _selectedPulsa == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih nominal pulsa terlebih dahulu!'),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_isPulsaSelected && _selectedPaketData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih paket kuota terlebih dahulu!'),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final int total = _isPulsaSelected ? _selectedPulsa!.harga : _selectedPaketData!.harga;
    final String operatorName = _detectOperator(_phoneNumber);
    final String serviceName = _isPulsaSelected ? 'Pulsa Reguler' : 'Paket Data';
    final String itemDetail = _isPulsaSelected
        ? 'Rp ${_formatRupiah(_selectedPulsa!.nominal)}'
        : _selectedPaketData!.label;

    final transactionData = TransactionModel(
      transactionType: serviceName,
      recipientName: _isPulsaSelected
          ? '$operatorName ${_formatRupiah(_selectedPulsa!.nominal)}'
          : '$operatorName - ${_selectedPaketData!.label}',
      provider: operatorName,
      accountNumber: _phoneNumber,
      sourceAccountName: _effectiveSenderName,
      sourceBank: "LET'S PAY",
      sourceAccountNumber: _effectiveSenderAccount,
      amount: total.toDouble(),
      adminFee: 0.0,
      dateTime: DateTime.now(),
    );

    // Buka Bottom Sheet Konfirmasi Terintegrasi Sesuai Gambar 3
    showPaymentConfirmationBottomSheet(
      context: context,
      transaction: transactionData,
      currentBalance: _effectiveCurrentBalance,
      customItemLabel: _isPulsaSelected ? 'Nominal' : 'Pilihan Paket',
      customItemValue: itemDetail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3D8B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pulsa & Paket data',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // Konten Utama
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE5E9F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Tab Toggle (Pulsa vs Paket Data)
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPulsaSelected = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: _isPulsaSelected ? const Color(0xFF132F65) : Colors.white70,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Pulsa',
                                        style: TextStyle(
                                          color: _isPulsaSelected ? Colors.white : Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPulsaSelected = false;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: !_isPulsaSelected ? const Color(0xFF132F65) : Colors.white70,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Paket Data',
                                        style: TextStyle(
                                          color: !_isPulsaSelected ? Colors.white : Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // 2. Input Nomor Handphone (Menggunakan Keyboard Bawaan Perangkat / Laptop)
                            const Text(
                              'No Handphone',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 8),

                            Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCDCE2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.call_rounded, size: 20, color: Colors.black54),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(14),
                                      ],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Masukkan Handphone',
                                        hintStyle: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          _phoneNumber = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            // 3. Pilihan Nominal (Dinamis: Pulsa atau Paket Data)
                            Text(
                              _isPulsaSelected ? 'Pilih Nominal' : 'Pilih Nominal Kuota',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 10),

                            if (_isPulsaSelected)
                              // Tab Pulsa
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 2.2,
                                ),
                                itemCount: _pulsaList.length,
                                itemBuilder: (context, index) {
                                  final item = _pulsaList[index];
                                  final isSelected = _selectedPulsa?.nominal == item.nominal;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedPulsa = item;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFF1E5BB8) : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFF132F65) : Colors.black12,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Rp ${_formatRupiah(item.nominal)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Harga: Rp ${_formatRupiah(item.harga)}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isSelected ? Colors.white70 : Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            else
                              // Tab Paket Data
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1.85,
                                ),
                                itemCount: _paketDataList.length,
                                itemBuilder: (context, index) {
                                  final item = _paketDataList[index];
                                  final isSelected = _selectedPaketData?.label == item.label;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedPaketData = item;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFF1E5BB8) : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFF132F65) : Colors.black12,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item.kuota,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? Colors.white : const Color(0xFF132F65),
                                            ),
                                          ),
                                          Text(
                                            'Masa aktif ${item.masaAktif}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isSelected ? Colors.white70 : Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            'Rp ${_formatRupiah(item.harga)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                            const SizedBox(height: 28),

                            // 4. Tombol Lanjutkan
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF132F65),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                                onPressed: _proceedToConfirmation,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Lanjutkan',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
