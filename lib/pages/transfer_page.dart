import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';
import 'pin_confirmation_page.dart';

// =========================================================================
// MODEL DATA BANK & PENERIMA
// =========================================================================
class BankModel {
  final String id;
  final String name;
  final String shortName;
  final Widget logo;

  const BankModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logo,
  });
}

class RecipientModel {
  final String name;
  final String accountNumber;
  final String displayMasked;
  final String initials;
  final Color badgeColor;
  final String bankName;

  const RecipientModel({
    required this.name,
    required this.accountNumber,
    required this.displayMasked,
    required this.initials,
    required this.badgeColor,
    required this.bankName,
  });
}

// =========================================================================
// 1. HALAMAN UTAMA TRANSFER (SESUAI GAMBAR 1)
// Tata letak rapi, proporsional, berada di tengah, dan tidak keluar batas layar
// =========================================================================
class TransferPage extends StatefulWidget {
  final String? senderName;
  final String? senderAccount;
  final double? currentBalance;
  final BankModel? initialSelectedBank;

  const TransferPage({
    super.key,
    this.senderName,
    this.senderAccount,
    this.currentBalance,
    this.initialSelectedBank,
  });

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  // Mode: null = default (pilihan bank & sesama), 'sesama' = transfer sesama, 'bank' = transfer bank
  String? _transferMode;
  BankModel? _selectedBank;

  bool _isBalanceVisible = false;
  final TextEditingController _targetAccountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _detectedRecipientName;

  String get _effectiveSenderName => widget.senderName ?? UserSession.activeUser;
  String get _effectiveSenderAccount => widget.senderAccount ?? UserSession.accountNumber;
  double get _effectiveCurrentBalance => widget.currentBalance ?? UserSession.balanceAmount;

  // Daftar Penerima Favorit
  final List<RecipientModel> _favorites = const [
    RecipientModel(
      name: 'Arista',
      accountNumber: '1234567890',
      displayMasked: '1234••••',
      initials: 'Ar',
      badgeColor: Color(0xFF132F65),
      bankName: 'Bank Central Asia (BCA)',
    ),
    RecipientModel(
      name: 'Nadia',
      accountNumber: '5678901234',
      displayMasked: '5678••••',
      initials: 'Na',
      badgeColor: Color(0xFFE52929),
      bankName: 'Bank Mandiri',
    ),
    RecipientModel(
      name: 'Salis',
      accountNumber: '9012345678',
      displayMasked: '9012••••',
      initials: 'Sa',
      badgeColor: Color(0xFFB84AE0),
      bankName: "LET'S PAY",
    ),
  ];

  final Map<String, String> _knownUsers = {
    '1234567890': 'Arista Zahra',
    '5678901234': 'Nadia Putri',
    '9012345678': 'Salis Kurnia',
    '7312345678': 'Surya Insomnia',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedBank != null) {
      _transferMode = 'bank';
      _selectedBank = widget.initialSelectedBank;
    }
    _targetAccountController.addListener(_onAccountChanged);
  }

  @override
  void dispose() {
    _targetAccountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onAccountChanged() {
    final text = _targetAccountController.text.trim();
    if (text == _effectiveSenderAccount && _transferMode == 'sesama') {
      setState(() => _detectedRecipientName = 'Tidak bisa transfer ke rekening sendiri');
      return;
    }

    if (text.length >= 8) {
      if (_knownUsers.containsKey(text)) {
        setState(() => _detectedRecipientName = _knownUsers[text]);
      } else {
        int hash = text.hashCode.abs() % 4;
        List<String> randomNames = ['Surya Insomnia', 'Budi Santoso', 'Siti Rahma', 'Dimas Pratama'];
        setState(() {
          _knownUsers[text] = randomNames[hash];
          _detectedRecipientName = randomNames[hash];
        });
      }
    } else {
      setState(() => _detectedRecipientName = null);
    }
  }

  String _formatCurrency(double amount) {
    String str = amount.toStringAsFixed(0);
    return str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _selectFavorite(RecipientModel recipient) {
    if (_transferMode == 'bank' && _selectedBank != null) {
      if (recipient.bankName != _selectedBank!.name) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Bank Berbeda', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: Text(
              '${recipient.name} menggunakan rekening ${recipient.bankName}, sedangkan saat ini Anda memilih ${_selectedBank!.name}.\n\nApakah ingin beralih ke ${recipient.bankName}?',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF132F65),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _targetAccountController.text = recipient.accountNumber;
                    _detectedRecipientName = recipient.name;
                  });
                },
                child: Text('Gunakan Nomor', style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          ),
        );
        return;
      }
    }

    setState(() {
      _targetAccountController.text = recipient.accountNumber;
      _detectedRecipientName = recipient.name;
    });
  }

  void _validateAndProceed() {
    final target = _targetAccountController.text.trim();
    final amountText = _amountController.text.replaceAll('.', '').trim();

    if (target.isEmpty) {
      _showSnackbar('Masukkan nomor rekening tujuan!');
      return;
    }

    if (target == _effectiveSenderAccount && _transferMode == 'sesama') {
      _showSnackbar('Anda tidak dapat mentransfer ke rekening sendiri!');
      return;
    }

    if (amountText.isEmpty) {
      _showSnackbar('Masukkan nominal transfer!');
      return;
    }

    final double amount = double.tryParse(amountText) ?? 0;
    if (amount <= 0) {
      _showSnackbar('Nominal transfer harus lebih dari Rp 0!');
      return;
    }

    final double adminFee = (_transferMode == 'bank') ? 2500 : 0;
    if ((amount + adminFee) > _effectiveCurrentBalance) {
      _showSnackbar('Saldo tidak mencukupi untuk transfer & biaya admin!');
      return;
    }

    final recipientName = _detectedRecipientName ?? 'Penerima Terdaftar';
    final targetBankName = (_transferMode == 'bank' && _selectedBank != null)
        ? _selectedBank!.name
        : "LET'S PAY";

    final transaction = TransactionModel(
      transactionType: _transferMode == 'bank' ? 'Transfer Bank' : 'Transfer Sesama',
      recipientName: recipientName,
      provider: targetBankName,
      accountNumber: target,
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
      transaction: transaction,
      currentBalance: _effectiveCurrentBalance,
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1EEFB),
      body: Stack(
        children: [
          // Background Header Melengkung Biru Gelap
          Container(
            height: 180,
            decoration: const BoxDecoration(color: Color(0xFF132F65)),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  left: 60,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  top: -50,
                  right: -20,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () {
                            if (_transferMode != null) {
                              setState(() {
                                _transferMode = null;
                                _selectedBank = null;
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 38),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F0FA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Transfer',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF132F65),
                                ),
                              ),
                              const SizedBox(height: 18),

                              // CARD TOTAL SALDO (SESUAI GAMBAR 1)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.white, Color(0xFFE7D6F5)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Saldo',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                                          child: Icon(
                                            _isBalanceVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            size: 20,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Sumber Akun Utama',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      _isBalanceVisible
                                          ? 'Rp ${_formatCurrency(_effectiveCurrentBalance)}'
                                          : 'Rp ••••••',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF132F65),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // CARD TUJUAN TRANSFER (SESUAI GAMBAR 1)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Tujuan Transfer',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF132F65),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F5FA),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.star_outline_rounded, color: Colors.redAccent, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Favorit',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF132F65),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // PILIHAN TUJUAN: Pilih bank & Sesama side-by-side (Gambar 1)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              final BankModel? chosen = await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const BankSelectionPage()),
                                              );
                                              if (chosen != null) {
                                                setState(() {
                                                  _transferMode = 'bank';
                                                  _selectedBank = chosen;
                                                });
                                              }
                                            },
                                            borderRadius: BorderRadius.circular(16),
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: _transferMode == 'bank'
                                                    ? const Color(0xFFE5EDF7)
                                                    : const Color(0xFFF0F4F8),
                                                borderRadius: BorderRadius.circular(16),
                                                border: _transferMode == 'bank'
                                                    ? Border.all(color: const Color(0xFF132F65), width: 1.5)
                                                    : null,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFF132F65),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(Icons.account_balance, color: Colors.white, size: 18),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      _selectedBank != null ? _selectedBank!.shortName : 'Pilih bank',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 13,
                                                        color: const Color(0xFF132F65),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _transferMode = 'sesama';
                                                _selectedBank = null;
                                              });
                                            },
                                            borderRadius: BorderRadius.circular(16),
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: _transferMode == 'sesama'
                                                    ? const Color(0xFFE5EDF7)
                                                    : const Color(0xFFF0F4F8),
                                                borderRadius: BorderRadius.circular(16),
                                                border: _transferMode == 'sesama'
                                                    ? Border.all(color: const Color(0xFF132F65), width: 1.5)
                                                    : null,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: Colors.grey.shade300),
                                                    ),
                                                    child: const Icon(Icons.person_outline, color: Color(0xFF132F65), size: 18),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      'Sesama',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 13,
                                                        color: const Color(0xFF132F65),
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

                                    const SizedBox(height: 18),

                                    Text(
                                      'Nomor Tujuan',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Container(
                                      constraints: const BoxConstraints(minHeight: 48),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F9FC),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.search, color: Colors.grey, size: 22),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextField(
                                              controller: _targetAccountController,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                                              decoration: InputDecoration(
                                                hintText: 'Masukkan nomor rekening',
                                                hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade500),
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    if (_detectedRecipientName != null) ...[
                                      const SizedBox(height: 6),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(
                                          _detectedRecipientName == 'Tidak bisa transfer ke rekening sendiri'
                                              ? '⚠️ Rekening milik Anda sendiri'
                                              : 'Penerima: $_detectedRecipientName',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _detectedRecipientName == 'Tidak bisa transfer ke rekening sendiri'
                                                ? Colors.redAccent
                                                : const Color(0xFF132F65),
                                          ),
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 16),

                                    Text(
                                      'Nominal',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Container(
                                      constraints: const BoxConstraints(minHeight: 48),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F9FC),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Rp',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFF132F65),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextField(
                                              controller: _amountController,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                                              decoration: InputDecoration(
                                                hintText: 'Masukkan nominal',
                                                hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade500),
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                              ),
                                              onChanged: (val) {
                                                if (val.isNotEmpty) {
                                                  String clean = val.replaceAll('.', '');
                                                  double? num = double.tryParse(clean);
                                                  if (num != null) {
                                                    String formatted = _formatCurrency(num);
                                                    if (formatted != val) {
                                                      _amountController.value = TextEditingValue(
                                                        text: formatted,
                                                        selection: TextSelection.collapsed(offset: formatted.length),
                                                      );
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // CARD PENERIMA FAVORIT (SESUAI GAMBAR 1)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Penerima Favorit',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF132F65),
                                          ),
                                        ),
                                        Text(
                                          '3 pilihan',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: _favorites.map((fav) {
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: InkWell(
                                              onTap: () => _selectFavorite(fav),
                                              borderRadius: BorderRadius.circular(16),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF7F9FC),
                                                  borderRadius: BorderRadius.circular(18),
                                                ),
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: fav.badgeColor,
                                                      child: Text(
                                                        fav.initials,
                                                        style: GoogleFonts.poppins(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      fav.name,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      fav.displayMasked,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 11,
                                                        color: Colors.grey.shade600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // TOMBOL LANJUTKAN (SESUAI GAMBAR 1)
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF132F65),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: _validateAndProceed,
                                  child: Text(
                                    'Lanjutkan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 2. HALAMAN PILIH BANK (PERSIS SESUAI SCREENSHOT TERBARU)
// =========================================================================
class BankSelectionPage extends StatefulWidget {
  const BankSelectionPage({super.key});

  @override
  State<BankSelectionPage> createState() => _BankSelectionPageState();
}

class _BankSelectionPageState extends State<BankSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  List<BankModel> _filteredBanks = [];

  // Daftar 8 Bank
  final List<BankModel> _allBanks = [
    BankModel(
      id: 'bsi',
      name: 'Bank Syariah Indonesia (BSI)',
      shortName: 'BSI',
      logo: _buildLogoBadge('BSI', Colors.teal, isBSI: true),
    ),
    BankModel(
      id: 'bri',
      name: 'Bank Rakyat Indonesia (BRI)',
      shortName: 'BRI',
      logo: _buildLogoBadge('BRI', const Color(0xFF00529C)),
    ),
    BankModel(
      id: 'mandiri',
      name: 'Bank Mandiri',
      shortName: 'Mandiri',
      logo: _buildLogoBadge('mandiri', const Color(0xFF003066), isMandiri: true),
    ),
    BankModel(
      id: 'bca',
      name: 'Bank Central Asia (BCA)',
      shortName: 'BCA',
      logo: _buildLogoBadge('BCA', const Color(0xFF005BAC)),
    ),
    BankModel(
      id: 'btn',
      name: 'Bank Tabungan Negara (BTN)',
      shortName: 'BTN',
      logo: _buildLogoBadge('btn', const Color(0xFF0D47A1), isBTN: true),
    ),
    BankModel(
      id: 'aceh',
      name: 'Bank Aceh',
      shortName: 'Bank Aceh',
      logo: _buildLogoBadge('Bank Aceh', Colors.green),
    ),
    BankModel(
      id: 'sumut',
      name: 'Bank Sumut',
      shortName: 'Bank Sumut',
      logo: _buildLogoBadge('Bank Sumut', Colors.orange),
    ),
    BankModel(
      id: 'mega',
      name: 'Bank Mega',
      shortName: 'Bank Mega',
      logo: _buildLogoBadge('BANK MEGA', Colors.deepOrange, isMega: true),
    ),
  ];

  static Widget _buildLogoBadge(String text, Color primaryColor,
      {bool isBSI = false, bool isMandiri = false, bool isBTN = false, bool isMega = false}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: isMega
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.change_history, size: 16, color: Colors.orange),
                Text('MEGA', style: GoogleFonts.poppins(fontSize: 7.5, fontWeight: FontWeight.w900, color: Colors.black87)),
              ],
            )
          : isMandiri
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('mandırı', style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF003066))),
                    Container(width: 18, height: 2, color: Colors.amber),
                  ],
                )
              : isBTN
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('btn', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w900, color: const Color(0xFF0D47A1))),
                        Container(width: 3, height: 12, color: Colors.red),
                      ],
                    )
                  : isBSI
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Text('BSI', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.teal)),
                            const Positioned(right: 0, top: 8, child: Icon(Icons.star, size: 8, color: Colors.amber)),
                          ],
                        )
                      : Text(
                          text,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: text.length > 4 ? 8.5 : 12,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                          ),
                        ),
    );
  }

  @override
  void initState() {
    super.initState();
    _filteredBanks = _allBanks;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredBanks = _allBanks;
      } else {
        _filteredBanks = _allBanks.where((bank) {
          return bank.name.toLowerCase().contains(query) ||
              bank.shortName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEAFB),
      body: Stack(
        children: [
          // Header Biru Gelap
          Container(
            height: 180,
            decoration: const BoxDecoration(color: Color(0xFF132F65)),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Transfer',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // Konten Putih Melengkung
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F6FD),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(38),
                        topRight: Radius.circular(38),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        // Card Header Bagian "Pilih bank"
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9EEF6),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
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
                                child: const Icon(Icons.account_balance, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Pilih bank',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: const Color(0xFF132F65),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Search Input Bar
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EDF6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: GoogleFonts.poppins(fontSize: 13.5),
                                  decoration: InputDecoration(
                                    hintText: 'Cari bank disini',
                                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade500),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              if (_searchController.text.isNotEmpty)
                                GestureDetector(
                                  onTap: () => _searchController.clear(),
                                  child: const Icon(Icons.close, size: 18, color: Colors.grey),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Daftar Bank
                        Expanded(
                          child: _filteredBanks.isEmpty
                              ? Center(
                                  child: Text(
                                    'Bank tidak ditemukan',
                                    style: GoogleFonts.poppins(color: Colors.grey),
                                  ),
                                )
                              : ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  itemCount: _filteredBanks.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final bank = _filteredBanks[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pop(context, bank);
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        child: Row(
                                          children: [
                                            bank.logo,
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                bank.name,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
