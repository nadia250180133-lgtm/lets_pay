import 'package:flutter/material.dart';

class NearbyMosquePage extends StatefulWidget {
  const NearbyMosquePage({super.key});

  @override
  State<NearbyMosquePage> createState() => _NearbyMosquePageState();
}

class _NearbyMosquePageState extends State<NearbyMosquePage> {
  final TextEditingController _searchController = TextEditingController();

  // 5 Data Masjid di sekitar Muara Satu, Lhokseumawe (sesuai spesifikasi)
  final List<Map<String, String>> _allMosques = [
    {
      'name': 'Masjid Al-Munawarah',
      'address': 'Gp, Blang Pulo',
      'distance': '350 m',
    },
    {
      'name': 'Mushalla Kampus Bukit Indah-Universitas Malikussaleh',
      'address': 'Gp, Blang Pulo',
      'distance': '600 m',
    },
    {
      'name': 'Meunasah cot meuturab',
      'address': '6387+92X, Blang Pulo',
      'distance': '850 m',
    },
    {
      'name': 'Musala Dusun C',
      'address': '6395+4CB, Bathupat Timur',
      'distance': '1.2 km',
    },
    {
      'name': 'Masjid Al-Hikmah Komplek Arun',
      'address': 'Batuphat Barat, Muara Satu, Lhokseumawe',
      'distance': '1.5 km',
    },
  ];

  List<Map<String, String>> _filteredMosques = [];

  @override
  void initState() {
    super.initState();
    _filteredMosques = _allMosques;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMosques = _allMosques.where((mosque) {
        final name = mosque['name']!.toLowerCase();
        final address = mosque['address']!.toLowerCase();
        return name.contains(query) || address.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMosqueDetail(Map<String, String> mosque) {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC48EEA).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mosque, color: Color(0xFF6B4BB8), size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mosque['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jarak: ${mosque['distance']}',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Alamat Lengkap:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '${mosque['address']}, Kec. Muara Satu, Kota Lhokseumawe, Aceh',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF143F9B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup', style: TextStyle(color: Colors.white)),
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B8CC7),
              Color(0xFFA197D6),
              Color(0xFFBCA1D8),
              Color(0xFFBE9CC7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Back Button & Judul
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Lokasi Masjid Terdekat',
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

              // Kolom Pencarian
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Cari Masjid di Sekitarmu',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 15,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Teks Jumlah Masjid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Terdapat ${_filteredMosques.length} Masjid di Sekitarmu',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Daftar Masjid
              Expanded(
                child: _filteredMosques.isEmpty
                    ? Center(
                        child: Text(
                          'Masjid tidak ditemukan',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: _filteredMosques.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final mosque = _filteredMosques[index];
                          return InkWell(
                            onTap: () => _showMosqueDetail(mosque),
                            borderRadius: BorderRadius.circular(16),
                            child: Row(
                              children: [
                                // Ikon Masjid Ungu Muda
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFC78EEA),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.mosque_outlined,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mosque['name']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        mosque['address']!,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.85),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}