import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

// Model Data E-Wallet
class EWalletItem {
  final String name;
  final Color color;
  final IconData icon;
  final bool isOvo;

  const EWalletItem({
    required this.name,
    required this.color,
    required this.icon,
    this.isOvo = false,
  });
}

// ============================================================================
// 1. HALAMAN PILIH E-WALLET (GoPay, DANA, OVO, ShopeePay)
// ============================================================================
class EWalletSelectionPage extends StatefulWidget {
  final String? senderName;
  final String? senderAccount;
  final dynamic currentBalance;

  const EWalletSelectionPage({
    super.key,
    this.senderName,
    this.senderAccount,
    this.currentBalance,
  });

  @override
  State<EWalletSelectionPage> createState() => _EWalletSelectionPageState();
}

typedef EWalletPage = EWalletSelectionPage;

class _EWalletSelectionPageState extends State<EWalletSelectionPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<EWalletItem> _eWallets = const [
    EWalletItem(
      name: 'GoPay',
      color: Color(0xFF00AED6),
      icon: Icons.account_balance_wallet_rounded,
    ),
    EWalletItem(
      name: 'DANA',
      color: Color(0xFF118EEA),
      icon: Icons.bookmark_rounded,
    ),
    EWalletItem(
      name: 'OVO',
      color: Color(0xFF4C3299),
      icon: Icons.circle,
      isOvo: true,
    ),
    EWalletItem(
      name: 'ShopeePay',
      color: Color(0xFFEE4D2D),
      icon: Icons.shopping_bag_outlined,
    ),
  ];

  List<EWalletItem> _filteredWallets = [];

  @override
  void initState() {
    super.initState();
    _filteredWallets = _eWallets;
  }

  void _filterWallets(String query) {
    setState(() {
      _filteredWallets = _eWallets
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
      backgroundColor: const Color(0xFF132F65), // Header Navy Blue
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'E-Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F8FD),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5EDF7),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF132F65),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Pilih E-Wallet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF132F65),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      TextField(
                        controller: _searchController,
                        onChanged: _filterWallets,
                        decoration: InputDecoration(
                          hintText: 'Cari E-Wallet',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Color(0xFF132F65)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _filteredWallets.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final item = _filteredWallets[index];
                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EWalletDetailPage(
                                      wallet: item,
                                      senderName: widget.senderName,
                                      currentBalance: widget.currentBalance,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: item.color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: item.isOvo
                                            ? const Text(
                                                'ovo',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 15,
                                                ),
                                              )
                                            : Icon(item.icon, color: Colors.white, size: 24),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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

// ============================================================================
// 2. HALAMAN INPUT DENGAN FILTER HANYA ANGKA (MUTLAK ANTI-HURUF)
// ============================================================================
class EWalletDetailPage extends StatefulWidget {
  final EWalletItem wallet;
  final String? senderName;
  final dynamic currentBalance;

  const EWalletDetailPage({
    super.key,
    required this.wallet,
    this.senderName,
    this.currentBalance,
  });

  @override
  State<EWalletDetailPage> createState() => _EWalletDetailPageState();
}

class _EWalletDetailPageState extends State<EWalletDetailPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool _isKeyboardVisible = false;
  String _activeField = 'phone'; // 'phone' atau 'amount'
  bool _isNumberMode = true; // Default langsung ke mode angka

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // FILTER MUTLAK: HANYA IZINKAN ANGKA 0 - 9 (HURUF OTOMATIS DITOLAK)
  // ==========================================================================
  void _typeChar(String char) {
    // Jika bukan angka 0-9, langsung batalkan/abaikan!
    final bool isDigit = RegExp(r'^[0-9]$').hasMatch(char);
    if (!isDigit) return;

    if (_activeField == 'phone') {
      // Maksimal 14 digit untuk nomor handphone
      if (_phoneController.text.length < 14) {
        setState(() {
          _phoneController.text = _phoneController.text + char;
        });
      }
    } else {
      // Untuk nominal (maksimal 9 digit / ratusan juta rupiah)
      if (_amountController.text.length < 9) {
        // Cegah angka 0 di awal jika kolom masih kosong
        if (_amountController.text.isEmpty && char == '0') return;
        setState(() {
          _amountController.text = _amountController.text + char;
        });
      }
    }
  }

  // Tombol Hapus (Backspace)
  void _backspace() {
    if (_activeField == 'phone') {
      if (_phoneController.text.isNotEmpty) {
        setState(() {
          _phoneController.text = _phoneController.text
              .substring(0, _phoneController.text.length - 1);
        });
      }
    } else {
      if (_amountController.text.isNotEmpty) {
        setState(() {
          _amountController.text = _amountController.text
              .substring(0, _amountController.text.length - 1);
        });
      }
    }
  }

  void _closeKeyboard() {
    setState(() {
      _isKeyboardVisible = false;
    });
  }

  void _onLanjutkanPressed() {
    _closeKeyboard();
    final phone = _phoneController.text.trim();
    final amount = _amountController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silahkan masukkan 10-14 digit nomor handphone!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silahkan masukkan nominal pembayaran!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Konfirmasi Top Up',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Merchant:'),
                  Text(widget.wallet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('No. Handphone:'),
                  Text(phone, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nominal:'),
                  Text('Rp $amount', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF132F65),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () async {
                    // 1. Parsing nominal dan format mata uang Rupiah
                    final double parsedAmount = double.tryParse(amount) ?? 0.0;
                    final String formattedAmount =
                        NotificationService.formatRupiah(parsedAmount);

                    // 2. Tambahkan notifikasi transaksi real-time ke NotificationService
                    await NotificationService.instance.addTransactionNotification(
                      transactionId: 'ewallet_${DateTime.now().millisecondsSinceEpoch}',
                      title: 'Top Up E-Wallet kamu berhasil!',
                      description: 'Top up ${widget.wallet.name} sebesar $formattedAmount ke $phone berhasil.',
                      type: TransactionType.ewallet,
                      amount: parsedAmount,
                      recipient: phone,
                    );

                    if (!context.mounted) return;

                    // 3. Navigasi dan umpan balik sukses
                    Navigator.pop(context);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Top up ${widget.wallet.name} berhasil diproses!'),
                        backgroundColor: const Color(0xFF16A34A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Bayar Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
    final phone = _phoneController.text.trim();
    final bool isPhoneValid = phone.isEmpty || (phone.length >= 10 && phone.length <= 14);

    return Scaffold(
      backgroundColor: const Color(0xFF132F65), // Header Navy Blue
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    'E-Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Card Putih Utama
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Nama Merchant
                      const Text(
                        'Nama Merchant',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF132F65),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Card Nama Merchant Aktif
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: widget.wallet.color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: widget.wallet.isOvo
                                    ? const Text(
                                        'ovo',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                      )
                                    : Icon(widget.wallet.icon, color: Colors.white, size: 24),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              widget.wallet.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Nomor Handphone Label
                      const Text(
                        'Nomor Handphone',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF132F65),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Kolom Nomor Handphone (Klik untuk Memunculkan Keyboard)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeField = 'phone';
                            _isKeyboardVisible = true;
                            _isNumberMode = true; // Otomatis mode angka
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: double.infinity,
                          height: 54,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (_isKeyboardVisible && _activeField == 'phone')
                                  ? const Color(0xFF132F65)
                                  : (isPhoneValid ? Colors.grey.shade300 : Colors.redAccent),
                              width: (_isKeyboardVisible && _activeField == 'phone') ? 1.8 : 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey.shade400, size: 22),
                              const SizedBox(width: 10),
                              if (_phoneController.text.isEmpty) ...[
                                if (_isKeyboardVisible && _activeField == 'phone')
                                  Container(
                                    width: 2,
                                    height: 20,
                                    margin: const EdgeInsets.only(right: 3),
                                    color: const Color(0xFF132F65),
                                  ),
                                Text(
                                  'Masukkan nomor handphone',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  _phoneController.text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                if (_isKeyboardVisible && _activeField == 'phone')
                                  Container(
                                    width: 2,
                                    height: 20,
                                    margin: const EdgeInsets.only(left: 2),
                                    color: const Color(0xFF132F65),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // Peringatan Merah 10-14 Digit
                      if (!isPhoneValid) ...[
                        const SizedBox(height: 6),
                        const Text(
                          'Silahkan masukkan 10-14 digit nomor handphone',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // 3. Total Nominal Label
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF132F65),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Kolom Nominal (Klik untuk Memunculkan Keyboard)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeField = 'amount';
                            _isKeyboardVisible = true;
                            _isNumberMode = true; // Otomatis mode angka
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: double.infinity,
                          height: 54,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (_isKeyboardVisible && _activeField == 'amount')
                                  ? const Color(0xFF132F65)
                                  : const Color(0xFF1E293B),
                              width: (_isKeyboardVisible && _activeField == 'amount') ? 1.8 : 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Rp',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF132F65),
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (_amountController.text.isEmpty) ...[
                                if (_isKeyboardVisible && _activeField == 'amount')
                                  Container(
                                    width: 2,
                                    height: 20,
                                    margin: const EdgeInsets.only(right: 3),
                                    color: const Color(0xFF132F65),
                                  ),
                                Text(
                                  'Masukkan nominal',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  _amountController.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                if (_isKeyboardVisible && _activeField == 'amount')
                                  Container(
                                    width: 2,
                                    height: 20,
                                    margin: const EdgeInsets.only(left: 2),
                                    color: const Color(0xFF132F65),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // 4. Tombol Lanjutkan
                      if (!_isKeyboardVisible) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF132F65),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              elevation: 2,
                            ),
                            onPressed: _onLanjutkanPressed,
                            child: const Text(
                              'Lanjutkan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // KEYBOARD VIRTUAL
            if (_isKeyboardVisible)
              _buildKeyboardWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardWidget() {
    return Container(
      color: const Color(0xFFFAF7FD),
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toolbar Keyboard
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE9FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_left, color: Color(0xFF9333EA), size: 18),
                ),
                const Text('GIF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const Icon(Icons.settings_outlined, size: 20, color: Colors.black87),
                const Icon(Icons.g_translate_outlined, size: 20, color: Colors.black87),
                const Icon(Icons.sentiment_satisfied_outlined, size: 20, color: Colors.black87),
                const Icon(Icons.more_horiz, size: 20, color: Colors.black87),
                const Icon(Icons.mic_none, size: 20, color: Colors.black87),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Baris 1: Angka 1 2 3 4 5 6 7 8 9 0
          _buildKeyRow(
            _isNumberMode
                ? ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']
                : ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
          ),
          const SizedBox(height: 5),

          // Baris 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _buildKeyRow(
              _isNumberMode
                  ? ['@', '#', '\$', '_', '&', '-', '+', '(', ')', '/']
                  : ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
            ),
          ),
          const SizedBox(height: 5),

          // Baris 3 (Dengan Shift dan Backspace)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                _buildSpecialButton(
                  child: const Icon(Icons.keyboard_capslock, size: 20, color: Colors.black87),
                  onTap: () {},
                ),
                Expanded(
                  child: _buildKeyRow(
                    _isNumberMode
                        ? ['*', '"', '\'', ':', ';', '!', '?']
                        : ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
                  ),
                ),
                _buildSpecialButton(
                  child: const Icon(Icons.backspace_outlined, size: 20, color: Colors.black87),
                  onTap: _backspace,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // Baris 4: ?123, Spasi, Enter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                _buildSpecialButton(
                  width: 50,
                  child: Text(
                    _isNumberMode ? 'ABC' : '?123',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onTap: () {
                    setState(() {
                      _isNumberMode = !_isNumberMode;
                    });
                  },
                ),
                const SizedBox(width: 4),
                _buildSpecialButton(
                  width: 38,
                  child: const Text('😊 ,', style: TextStyle(fontSize: 11)),
                  onTap: () {},
                ),
                const SizedBox(width: 4),
                _buildSpecialButton(
                  width: 38,
                  child: const Icon(Icons.language, size: 18),
                  onTap: () {},
                ),
                const SizedBox(width: 4),
                // Spasi
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _buildSpecialButton(
                  width: 38,
                  child: const Text('.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {},
                ),
                const SizedBox(width: 4),
                // Enter / Selesai
                InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: _closeKeyboard,
                  child: Container(
                    width: 52,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC48EF4),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.keyboard_return, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Baris Bawah: Tombol Tutup Keyboard
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.keyboard_arrow_down, size: 26, color: Colors.black87),
                  onPressed: _closeKeyboard,
                ),
                const Icon(Icons.keyboard_alt_outlined, size: 20, color: Colors.black87),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((char) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.2),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _typeChar(char),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    char,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpecialButton({
    required Widget child,
    required VoidCallback onTap,
    double? width,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: width ?? 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}