import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_calley/screens/otp_verification_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/splash.dart';
import 'screens/language_select.dart'; // Add this import
import 'screens/register.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/login.dart';
import 'screens/success.dart';
import 'screens/dashboard.dart';
import 'screens/dashboard_home.dart';
import 'providers/auth_provider.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  final apiService = ApiService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(secureStorage, apiService),
        ),
      ],
      child: const GetCalleyApp(),
    ),
  );
}

class GetCalleyApp extends StatelessWidget {
  const GetCalleyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calley - Smart Call Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1976D2),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          primary: const Color(0xFF1976D2),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/language': (context) => const LanguageSelectScreen(), // Add this
        '/register': (context) => const RegisterScreen(),
        '/otp-verification': (context) => const OtpVerificationScreen(),
        '/login': (context) => const LoginScreen(),
        '/success': (context) => const SuccessScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
