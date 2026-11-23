import 'package:flutter/material.dart';

import 'pin_confirmation_page.dart';
import 'login_page.dart';

// Model Tipe Layanan PLN
class PlnTypeItem {
  final String name;
  final String typeKey; // 'tagihan' atau 'token'
  final Color color;
  final IconData icon;

  const PlnTypeItem({
    required this.name,
    required this.typeKey,
    required this.color,
    required this.icon,
  });
}

// ============================================================================
// 1. HALAMAN PILIH LAYANAN PLN (Tagihan Listrik / Token Listrik)
// ============================================================================
class PlnSelectionPage extends StatefulWidget {
  final String? senderName;
  final String? senderAccount;
  final dynamic currentBalance;

  const PlnSelectionPage({
    super.key,
    this.senderName,
    this.senderAccount,
    this.currentBalance,
  });

  @override
  State<PlnSelectionPage> createState() => _PlnSelectionPageState();
}

typedef PlnPage = PlnSelectionPage;

class _PlnSelectionPageState extends State<PlnSelectionPage> {
  final List<PlnTypeItem> _plnServices = const [
    PlnTypeItem(
      name: 'Tagihan Listrik (Pascabayar)',
      typeKey: 'tagihan',
      color: Color(0xFFF59E0B),
      icon: Icons.lightbulb_rounded,
    ),
    PlnTypeItem(
      name: 'Token Listrik (Prabayar)',
      typeKey: 'token',
      color: Color(0xFF10B981),
      icon: Icons.electric_bolt_rounded,
    ),
  ];

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
                    'Listrik PLN',
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
                                Icons.bolt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Pilih Layanan Listrik',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF132F65),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _plnServices.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final item = _plnServices[index];
                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlnDetailPage(
                                      plnService: item,
                                      senderName: widget.senderName,
                                      senderAccount: widget.senderAccount,
                                      currentBalance: widget.currentBalance,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                                        child: Icon(item.icon, color: Colors.white, size: 24),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
// 2. HALAMAN DETAIL INPUT & PEMBAYARAN PLN
// ============================================================================
class PlnDetailPage extends StatefulWidget {
  final PlnTypeItem plnService;
  final String? senderName;
  final String? senderAccount;
  final dynamic currentBalance;

  const PlnDetailPage({
    super.key,
    required this.plnService,
    this.senderName,
    this.senderAccount,
    this.currentBalance,
  });

  @override
  State<PlnDetailPage> createState() => _PlnDetailPageState();
}

class _PlnDetailPageState extends State<PlnDetailPage> {
  final TextEditingController _meterController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool _isKeyboardVisible = false;
  String _activeField = 'meter'; // 'meter' atau 'amount'

  @override
  void dispose() {
    _meterController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _typeChar(String char) {
    final bool isDigit = RegExp(r'^[0-9]$').hasMatch(char);
    if (!isDigit) return;

    if (_activeField == 'meter') {
      if (_meterController.text.length < 16) {
        setState(() {
          _meterController.text = _meterController.text + char;
        });
      }
    } else {
      if (_amountController.text.length < 9) {
        if (_amountController.text.isEmpty && char == '0') return;
        setState(() {
          _amountController.text = _amountController.text + char;
        });
      }
    }
  }

  void _backspace() {
    if (_activeField == 'meter') {
      if (_meterController.text.isNotEmpty) {
        setState(() {
          _meterController.text = _meterController.text
              .substring(0, _meterController.text.length - 1);
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

  String get _effectiveSenderName => (widget.senderName != null && widget.senderName!.isNotEmpty)
      ? widget.senderName!
      : UserSession.activeUser;
  String get _effectiveSenderAccount => (widget.senderAccount != null && widget.senderAccount!.isNotEmpty)
      ? widget.senderAccount!
      : UserSession.accountNumber;
  double get _effectiveCurrentBalance => (widget.currentBalance is num)
      ? (widget.currentBalance as num).toDouble()
      : UserSession.balanceAmount;

  void _onLanjutkanPressed() {
    _closeKeyboard();
    final meter = _meterController.text.trim();
    final amount = _amountController.text.trim();

    if (meter.isEmpty || meter.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silahkan masukkan 11-12 digit No. Meter / ID Pelanggan!'),
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

    final double parsedAmount = double.tryParse(amount) ?? 0.0;
    final bool isTagihan = widget.plnService.typeKey == 'tagihan';

    final transaction = TransactionModel(
      transactionType: isTagihan ? 'Tagihan Listrik' : 'Token Listrik',
      recipientName: isTagihan ? 'PLN Pascabayar' : 'PLN Prabayar',
      provider: 'PT PLN (Persero)',
      accountNumber: meter,
      sourceAccountName: _effectiveSenderName,
      sourceBank: "LET'S PAY",
      sourceAccountNumber: _effectiveSenderAccount,
      amount: parsedAmount,
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
    return Scaffold(
      backgroundColor: const Color(0xFF132F65),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
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
                  Text(
                    widget.plnService.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label No Meter / ID Pelanggan
                      const Text(
                        'No. Meter / ID Pelanggan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF132F65),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Kolom Input Meter
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeField = 'meter';
                            _isKeyboardVisible = true;
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
                              color: (_isKeyboardVisible && _activeField == 'meter')
                                  ? const Color(0xFF132F65)
                                  : Colors.grey.shade300,
                              width: (_isKeyboardVisible && _activeField == 'meter') ? 1.8 : 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.flash_on, color: Color(0xFFF59E0B), size: 22),
                              const SizedBox(width: 10),
                              if (_meterController.text.isEmpty) ...[
                                Text(
                                  'Masukkan 11-12 digit No. Meter',
                                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                                ),
                              ] else ...[
                                Text(
                                  _meterController.text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Label Nominal
                      const Text(
                        'Nominal Pembayaran',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF132F65),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Kolom Input Nominal
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeField = 'amount';
                            _isKeyboardVisible = true;
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
                                Text(
                                  'Masukkan nominal pembayaran',
                                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
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
                              ],
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Tombol Lanjutkan
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

            // Keyboard Virtual Bawaan
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
          _buildKeyRow(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _buildKeyRow(['@', '#', '\$', '_', '&', '-', '+', '(', ')', '/']),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                _buildSpecialButton(
                  child: const Icon(Icons.keyboard_capslock, size: 20, color: Colors.black87),
                  onTap: () {},
                ),
                Expanded(
                  child: _buildKeyRow(['*', '"', '\'', ':', ';', '!', '?']),
                ),
                _buildSpecialButton(
                  child: const Icon(Icons.backspace_outlined, size: 20, color: Colors.black87),
                  onTap: _backspace,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
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