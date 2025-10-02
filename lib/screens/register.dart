import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final api = ApiService();

  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final body = {
        'name': _nameCtl.text.trim(),
        'email': _emailCtl.text.trim(),
      };
      final res = await api.register(body);
      // handle response: likely returns success and message
      // navigate to OTP screen with email or mobile
      Navigator.pushNamed(
        context,
        '/otp',
        arguments: {'email': _emailCtl.text.trim()},
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Register failed')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: Text('Register')),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameCtl,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (v) => v!.isEmpty ? 'Enter name' : null,
            ),
            TextFormField(
              controller: _emailCtl,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (v) => v!.contains('@') ? null : 'Invalid email',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading ? CircularProgressIndicator() : Text('Send OTP'),
            ),
          ],
        ),
      ),
    ),
  );
}
