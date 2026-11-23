import 'package:flutter/material.dart';
import 'bpjs_payment_page.dart';

class BpjsProgramPage extends StatefulWidget {
  final String? senderName;
  final String? senderAccount;
  final String? currentBalance;

  const BpjsProgramPage({
    super.key,
    this.senderName,
    this.senderAccount,
    this.currentBalance,
  });

  @override
  State<BpjsProgramPage> createState() => _BpjsProgramPageState();
}

class _BpjsProgramPageState extends State<BpjsProgramPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _programs = [
    {
      'title': 'BPJS Kesehatan',
      'logo': 'assets/images/bpjs_kesehatan.png', // Sesuaikan path aset logo Anda
    },
  ];

  List<Map<String, String>> _filteredPrograms = [];

  @override
  void initState() {
    super.initState();
    _filteredPrograms = _programs;
    _searchController.addListener(_filterPrograms);
  }

  void _filterPrograms() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPrograms = _programs
          .where((item) => item['title']!.toLowerCase().contains(query))
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
      backgroundColor: const Color(0xFF133678), // Warna biru header
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Biru
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  const Text(
                    'BPJS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Kontainer Utama Berwarna Soft Lilac/Lavender Gradient
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF7F8FD),
                      Color(0xFFEDEBF9),
                      Color(0xFFDFDCF7),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Banner Pill: Pilih Program BPJS
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9ECF8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F2B5C),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.monitor_heart_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Pilih Program BPJS',
                              style: TextStyle(
                                color: Color(0xFF0F2B5C),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Kolom Pencarian: Cari Program
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Cari Program',
                            hintStyle: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF4A5568),
                              size: 22,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Daftar Pilihan Program (BPJS Kesehatan)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredPrograms.length,
                        itemBuilder: (context, index) {
                          final program = _filteredPrograms[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BpjsPaymentPage(
                                    programName: program['title']!,
                                    logoAsset: program['logo']!,
                                    senderName: widget.senderName,
                                    senderAccount: widget.senderAccount,
                                    currentBalance: widget.currentBalance,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  // Logo BPJS Kesehatan
                                  _buildBpjsLogo(program['logo']!),
                                  const SizedBox(width: 16),
                                  Text(
                                    program['title']!,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
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
            // Fallback jika path aset belum cocok
            return const Icon(Icons.health_and_safety, color: Colors.teal, size: 28);
          },
        ),
      ),
    );
  }
}