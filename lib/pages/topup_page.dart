import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import PinConfirmationPage (di mana TransactionModel & BottomSheet juga sudah ada)
import 'pin_confirmation_page.dart';
import 'login_page.dart';

// Model E-Wallet
class EWalletItem {
  final String id;
  final String name;
  final Color brandColor;
  final IconData icon;

  const EWalletItem({
    required this.id,
    required this.name,
    required this.brandColor,
    required this.icon,
  });
}

final List<EWalletItem> listEWallet = [
  const EWalletItem(
    id: 'gopay',
    name: 'GoPay',
    brandColor: Color(0xFF00AED6),
    icon: Icons.account_balance_wallet_rounded,
  ),
  const EWalletItem(
    id: 'dana',
    name: 'DANA',
    brandColor: Color(0xFF118EEA),
    icon: Icons.account_balance_wallet_outlined,
  ),
  const EWalletItem(
    id: 'ovo',
    name: 'OVO',
    brandColor: Color(0xFF4C2A86),
    icon: Icons.circle_outlined,
  ),
  const EWalletItem(
    id: 'shopeepay',
    name: 'ShopeePay',
    brandColor: Color(0xFFEE4D2D),
    icon: Icons.shopping_bag_outlined,
  ),
];

// NAMA CLASS TETAP TopUpPage SUPAYA TIDAK MERUSAK DASHBOARD
class TopUpPage extends StatefulWidget {
  final String? senderName;
  final String? senderAccount;
  final double? currentBalance;

  const TopUpPage({
    super.key,
    this.senderName,
    this.senderAccount,
    this.currentBalance,
  });

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _searchController = TextEditingController();
  List<EWalletItem> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _filteredList = listEWallet;
  }

  void _filterEWallet(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredList = listEWallet;
      } else {
        _filteredList = listEWallet
            .where((item) =>
                item.name.toLowerCase().contains(query.trim().toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D254C), // Biru Header
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context), // Kembali ke Dashboard
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'E-Wallet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Konten Melengkung dengan Gradasi
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF3F0FC),
                      Color(0xFFE5DCF8),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    children: [
                      // Banner "Pilih E-Wallet"
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9EDF5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0D254C),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Pilih E-Wallet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D254C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Pencarian
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterEWallet,
                          decoration: InputDecoration(
                            hintText: 'Cari E-Wallet',
                            hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
                            prefixIcon: const Icon(Icons.search, color: Colors.black45),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.black45),
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterEWallet('');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Daftar E-Wallet
                      if (_filteredList.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'E-Wallet tidak ditemukan',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final item = _filteredList[index];
                            return InkWell(
                              onTap: () {
                                // Pindah ke halaman kedua (Pengisian)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TopUpDetailPage(
                                      selectedWallet: item,
                                      senderName: widget.senderName,
                                      senderAccount: widget.senderAccount,
                                      currentBalance: widget.currentBalance,
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: item.brandColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: item.name == 'OVO'
                                            ? const Text(
                                                'ovo',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Icon(item.icon, color: Colors.white, size: 26),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0D254C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
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

// Halaman Kedua: Pengisian Nomor Handphone dan Nominal
class TopUpDetailPage extends StatefulWidget {
  final EWalletItem selectedWallet;
  final String? senderName;
  final String? senderAccount;
  final double? currentBalance;

  const TopUpDetailPage({
    super.key,
    required this.selectedWallet,
    this.senderName,
    this.senderAccount,
    this.currentBalance,
  });

  @override
  State<TopUpDetailPage> createState() => _TopUpDetailPageState();
}

class _TopUpDetailPageState extends State<TopUpDetailPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isPhoneValid = false;

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
    _phoneController.addListener(() {
      final text = _phoneController.text.trim();
      setState(() {
        _isPhoneValid = text.length >= 10 && text.length <= 14;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onLanjutkan() {
    // Sembunyikan keyboard saat menekan tombol
    FocusScope.of(context).unfocus();

    // 1. Validasi E-Wallet terpilih
    if (widget.selectedWallet.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih E-Wallet terlebih dahulu'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 2. Validasi Nomor Handphone (10 - 14 digit)
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor handphone tidak boleh kosong'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (phone.length < 10 || phone.length > 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan 10–14 digit nomor handphone'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 3. Validasi Nominal Pembayaran (harus diisi dan > Rp0)
    final cleanAmount = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanAmount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nominal pembayaran harus diisi'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final amount = double.tryParse(cleanAmount) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nominal pembayaran harus lebih dari Rp0'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 4. Bungkus ke TransactionModel sesuai format halaman Transaksi Berhasil & Bukti Transaksi
    final transaction = TransactionModel(
      transactionType: 'Top Up ${widget.selectedWallet.name}',
      recipientName: 'Top Up ${widget.selectedWallet.name}',
      provider: widget.selectedWallet.name,
      accountNumber: phone,
      sourceAccountName: _effectiveSenderName,
      sourceBank: "LET'S PAY",
      sourceAccountNumber: _effectiveSenderAccount,
      amount: amount,
      adminFee: 0.0,
      dateTime: DateTime.now(),
    );

    // Buka Bottom Sheet Konfirmasi Pembayaran Sesuai Alur Terintegrasi (Gambar 3)
    showPaymentConfirmationBottomSheet(
      context: context,
      transaction: transaction,
      currentBalance: _effectiveCurrentBalance,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wallet = widget.selectedWallet;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF3F0FC),
              Color(0xFFE5DCF8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF0D254C), size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'E-Wallet',
                          style: TextStyle(
                            color: Color(0xFF0D254C),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Form Pengisian
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Merchant',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
                      ),
                      const SizedBox(height: 10),

                      // Kartu Merchant Dinamis
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: wallet.brandColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: wallet.name == 'OVO'
                                    ? const Text('ovo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                    : Icon(wallet.icon, color: Colors.white, size: 24),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              wallet.name,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Input Nomor Handphone
                      const Text(
                        'Nomor Handphone',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(14),
                          ],
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.black45),
                            hintText: 'Masukkan No Handphone',
                            hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      if (!_isPhoneValid)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Text(
                            'Silahkan masukkan 10–14 digit nomor handphone',
                            style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Input Total
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _CurrencyInputFormatter(),
                          ],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
                          decoration: const InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 8.0, top: 12.0, bottom: 12.0),
                              child: Text(
                                'Rp',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D254C)),
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            hintText: 'Masukkan nominal',
                            hintStyle: TextStyle(color: Colors.black38, fontSize: 15, fontWeight: FontWeight.normal),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tombol Lanjutkan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D254C),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                    onPressed: _onLanjutkan,
                    child: const Text(
                      'Lanjutkan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
}

// Formatter Titik Ribuan Murni Dart (Tanpa perlu package intl)
class _CurrencyInputFormatter extends TextInputFormatter {
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

    final buffer = StringBuffer();
    for (int i = 0; i < cleanText.length; i++) {
      if (i > 0 && (cleanText.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(cleanText[i]);
    }

    final newString = buffer.toString();

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}