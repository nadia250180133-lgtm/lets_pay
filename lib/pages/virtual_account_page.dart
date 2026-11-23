import 'package:flutter/material.dart';

// Import PinConfirmationPage dan TransactionModel
import 'pin_confirmation_page.dart';
import 'login_page.dart';

// ============================================================================
// 1. HALAMAN UTAMA VIRTUAL ACCOUNT (Kursor Rapi di Sebelah Kiri)
// ============================================================================
class VirtualAccountPage extends StatefulWidget {
  final String? senderName;
  final String? senderAccount;
  final dynamic currentBalance;

  const VirtualAccountPage({
    super.key,
    this.senderName,
    this.senderAccount,
    this.currentBalance,
  });

  @override
  State<VirtualAccountPage> createState() => _VirtualAccountPageState();
}

class _VirtualAccountPageState extends State<VirtualAccountPage> {
  final TextEditingController _vaController = TextEditingController();
  bool _isKeyboardVisible = false; // Status keyboard muncul
  bool _isNumberMode = false; // Toggle huruf / angka

  @override
  void dispose() {
    _vaController.dispose();
    super.dispose();
  }

  void _typeChar(String char) {
    setState(() {
      _vaController.text = _vaController.text + char;
    });
  }

  void _backspace() {
    if (_vaController.text.isNotEmpty) {
      setState(() {
        _vaController.text =
            _vaController.text.substring(0, _vaController.text.length - 1);
      });
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

  void _showConfirmationSheet() {
    _closeKeyboard();
    final vaNumber = _vaController.text.trim().isEmpty
        ? '09876543211234097643'
        : _vaController.text.trim();

    const String institutionName = 'Shopee Indonesia';
    const double vaAmount = 129000.0;

    // Siapkan data transaksi Virtual Account dinamis
    final transactionData = TransactionModel(
      transactionType: 'Virtual Account',
      recipientName: institutionName,
      provider: 'Shopee VA',
      accountNumber: vaNumber,
      sourceAccountName: _effectiveSenderName,
      sourceBank: "LET'S PAY",
      sourceAccountNumber: _effectiveSenderAccount,
      amount: vaAmount,
      adminFee: 0.0,
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
    final displayName = _effectiveSenderName;
    final displayBalance = '${TransactionModel.formatRupiah(_effectiveCurrentBalance)},00';

    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A), // Navy Blue Header
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                  ),
                  const Text(
                    'Virtual Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. INPUT FIELD DENGAN KURSOR TEPAT DI KIRI SETELAH HURUF
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isKeyboardVisible = true;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isKeyboardVisible
                                  ? const Color(0xFF1E3A8A)
                                  : const Color(0xFF1E293B),
                              width: _isKeyboardVisible ? 1.8 : 1.2,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (_vaController.text.isEmpty) ...[
                                  // Kursor berada di paling kiri jika teks masih kosong
                                  if (_isKeyboardVisible)
                                    Container(
                                      width: 2,
                                      height: 20,
                                      margin: const EdgeInsets.only(right: 3),
                                      color: const Color(0xFF1E3A8A),
                                    ),
                                  Text(
                                    'No. Virtual Account',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ] else ...[
                                  // Teks yang diketik
                                  Text(
                                    _vaController.text,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  // Kursor menempel langsung di sebelah kiri/tepat setelah huruf terakhir
                                  if (_isKeyboardVisible)
                                    Container(
                                      width: 2,
                                      height: 20,
                                      margin: const EdgeInsets.only(left: 2),
                                      color: const Color(0xFF1E3A8A),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Rekening Sumber Label
                      const Text(
                        'Rekening  Sumber',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 3. Card Rekening Sumber (Raffi - Rp 500.000,00)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1EDF2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFC084FC),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'R',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  displayBalance,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // 4. Tombol Lanjutkan (Hanya muncul jika keyboard sedang ditutup)
                      if (!_isKeyboardVisible) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC45BFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              if (_vaController.text.isEmpty) {
                                setState(() {
                                  _isKeyboardVisible = true;
                                });
                              } else {
                                _showConfirmationSheet();
                              }
                            },
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
                        const SizedBox(height: 14),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ================================================================
            // 5. KEYBOARD VIRTUAL MUNCUL DARI BAWAH
            // ================================================================
            if (_isKeyboardVisible)
              _buildVirtualKeyboardWidget(),
          ],
        ),
      ),
    );
  }

  // WIDGET KEYBOARD PERSIS SEPERTI GAMBAR
  Widget _buildVirtualKeyboardWidget() {
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

          // Baris 1: Huruf atau Angka
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
                  onTap: () => _typeChar(','),
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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _typeChar(' '),
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
                ),
                const SizedBox(width: 4),
                _buildSpecialButton(
                  width: 38,
                  child: const Text('.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () => _typeChar('.'),
                ),
                const SizedBox(width: 4),
                // Enter / Selesai
                InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: _showConfirmationSheet,
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

          // Baris Bawah: Tombol Tutup Keyboard (Panah Bawah)
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
