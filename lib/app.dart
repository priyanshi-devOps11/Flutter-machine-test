import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'screens/register.dart';
import 'screens/otp_verify.dart';
import 'screens/dashboard.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Calley Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (_) => SplashScreen(),
        '/register': (_) => RegisterScreen(),
        '/otp': (_) => OtpVerifyScreen(),
        '/dashboard': (_) => DashboardScreen(),
      },
    );
  }
}
