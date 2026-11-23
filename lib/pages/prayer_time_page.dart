import 'dart:async';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class PrayerTimePage extends StatefulWidget {
  const PrayerTimePage({super.key});

  @override
  State<PrayerTimePage> createState() => _PrayerTimePageState();
}

class _PrayerTimePageState extends State<PrayerTimePage> {
  // Daftar jadwal waktu sholat harian
  final Map<String, String> _prayerTimes = const {
    'Subuh': '04:45',
    'Zuhur': '12:05',
    'Asar': '15:20',
    'Maghrib': '18:10',
    'Isya': '19:22',
  };

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkPrayerNotification();
    // Cek setiap 1 menit apakah sudah masuk waktu sholat
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkPrayerNotification();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkPrayerNotification() {
    final now = DateTime.now();
    final currentHHmm =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    _prayerTimes.forEach((prayerName, timeStr) {
      if (currentHHmm == timeStr) {
        NotificationService.instance.addPrayerNotification(
          prayerName: prayerName,
          prayerTime: now,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF132F65),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Waktu Sholat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF6F8FD),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: _prayerTimes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final entry = _prayerTimes.entries.elementAt(index);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled_rounded,
                        color: Color(0xFF132F65),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B4AB8),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}