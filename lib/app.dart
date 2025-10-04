import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'screens/language_select.dart';
import 'screens/register.dart';
import 'screens/otp_verify.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/dashboard.dart';
import 'screens/dashboard_home.dart';
import 'screens/call_history.dart';

class GetCalleyApp extends StatelessWidget {
  const GetCalleyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Calley',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF007AFF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          primary: const Color(0xFF007AFF),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/language': (context) => const LanguageSelectScreen(),
        '/register': (context) => const RegisterScreen(),
        '/otp': (context) => const OtpVerifyScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/dashboard-home': (context) => const DashboardHomeScreen(),
        '/call-history': (context) => const CallHistoryScreen(),
      },
    );
  }
}
