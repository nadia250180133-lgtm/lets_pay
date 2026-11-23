import 'dart:math' as math;
import 'package:flutter/material.dart';

class QiblaCompassPage extends StatefulWidget {
  const QiblaCompassPage({super.key});

  @override
  State<QiblaCompassPage> createState() => _QiblaCompassPageState();
}

class _QiblaCompassPageState extends State<QiblaCompassPage> {
  // Koordinat Muara Satu, Lhokseumawe (Lat: 5.18° N, Long: 97.14° E)
  // Sudut Kiblat dari Utara Sejati: ~292.5°
  final double _qiblaAngle = 292.5;
  double _deviceHeading = 0.0; // Heading kompas

  @override
  Widget build(BuildContext context) {
    // Sudut jarum penunjuk kiblat relatif terhadap orientasi perangkat
    double needleAngle = (_qiblaAngle - _deviceHeading) * (math.pi / 180);

    return Scaffold(
      backgroundColor: const Color(0xFF0C203F),
      body: SafeArea(
        child: Column(
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
                    'Kompas Kiblat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Lokasi & Sudut Kiblat
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1B3B68),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lokasi Terdeteksi',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Muara Satu, Lhokseumawe',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Arah Kiblat',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_qiblaAngle.toStringAsFixed(1)}° BL',
                        style: const TextStyle(
                          color: Color(0xFFF9B815),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Kompas Berbentuk Lingkaran
            Center(
              child: GestureDetector(
                onPanUpdate: (details) {
                  // Memungkinkan putar manual jika emulator tidak memiliki sensor magnetometer
                  setState(() {
                    _deviceHeading = (_deviceHeading + details.delta.dx * 0.5) % 360;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dial Kompas Luar
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF142B59),
                        border: Border.all(color: const Color(0xFF335882), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),

                    // Penanda Mata Angin (U, T, S, B)
                    const Positioned(
                      top: 14,
                      child: Text('U', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    const Positioned(
                      bottom: 14,
                      child: Text('S', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    const Positioned(
                      right: 18,
                      child: Text('T', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    const Positioned(
                      left: 18,
                      child: Text('B', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),

                    // Jarum Penunjuk Kiblat (Ka'bah)
                    Transform.rotate(
                      angle: needleAngle,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Ikon Ka'bah
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF9B815),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.mosque, color: Colors.black87, size: 24),
                          ),
                          Container(
                            width: 4,
                            height: 70,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9B815),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),

                    // Titik Poros Tengah
                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Informasi Kalibrasi & Keamanan Magnet
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, color: Colors.white.withOpacity(0.7), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Jauhkan HP dari benda magnetis saat menggunakan kompas',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Putar perangkat perlahan membentuk angka 8 jika kompas belum stabil',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}