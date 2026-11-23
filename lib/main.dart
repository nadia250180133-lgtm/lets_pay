import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/welcome_page.dart';
import 'services/notification_service.dart';
import 'pages/notification_page.dart';
import 'pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LET'S PAY",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/notification': (context) => const NotificationPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}