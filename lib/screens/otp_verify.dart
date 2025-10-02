import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OtpVerifyScreen extends StatefulWidget {
  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpCtl = TextEditingController();
  final api = ApiService();
  final storage = FlutterSecureStorage();

  bool _loading = false;

  _verify(String email) async {
    setState(() => _loading = true);
    try {
      final res = await api.verifyOtp({
        'email': email,
        'otp': _otpCtl.text.trim(),
      });
      // store token if returned
      if (res.data['token'] != null) {
        await storage.write(key: 'token', value: res.data['token']);
      }
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('OTP failed')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map? ?? {};
    final email = args['email'] ?? '';
    return Scaffold(
      appBar: AppBar(title: Text('OTP Verify')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('OTP sent to $email'),
            TextField(
              controller: _otpCtl,
              decoration: InputDecoration(labelText: 'Enter OTP'),
            ),
            ElevatedButton(
              onPressed: _loading ? null : () => _verify(email),
              child: _loading ? CircularProgressIndicator() : Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
