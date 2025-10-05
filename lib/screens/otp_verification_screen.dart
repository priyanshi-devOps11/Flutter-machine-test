import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../services/api_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final ApiService _apiService = ApiService();

  int _remainingSeconds = 60;
  Timer? _timer;
  bool _isLoading = false;

  String? _email;
  String? _name;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _email = args['email'];
          _name = args['name'];
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _getOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _verifyOtp() async {
    final otp = _getOtp();

    if (otp.length != 6) {
      _showMessage('Please enter complete 6-digit OTP', isError: true);
      return;
    }

    if (_email == null) {
      _showMessage('Email not found. Please try again.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.verifyOtp(
        email: _email!,
        otp: otp,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        _showMessage(response['message'] ?? 'OTP verified successfully');

        // Navigate to success screen
        Navigator.pushReplacementNamed(
          context,
          '/success',
          arguments: {
            'name': _name ?? 'User',
            'email': _email,
          },
        );
      } else {
        _showMessage(response['message'] ?? 'Invalid OTP', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('An error occurred. Please try again.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_email == null) {
      _showMessage('Email not found. Please try again.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.sendOtp(email: _email!);

      if (!mounted) return;

      if (response['success'] == true) {
        _startTimer();
        _showMessage('OTP resent successfully');
      } else {
        _showMessage(response['message'] ?? 'Failed to resend OTP',
            isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Failed to resend OTP', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildLogo(),
              const SizedBox(height: 40),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'We have sent a verification code to\n${_email ?? "your email"}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 48,
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _otpControllers[index].text.isNotEmpty
                            ? const Color(0xFF007AFF)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        setState(() {});
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (index == 5 && value.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              _remainingSeconds > 0
                  ? Text(
                      'Resend OTP in $_remainingSeconds seconds',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    )
                  : TextButton(
                      onPressed: _isLoading ? null : _resendOtp,
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF007AFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00C6FF).withOpacity(0.2),
            const Color(0xFF007AFF).withOpacity(0.2),
          ],
        ),
      ),
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00C6FF),
              Color(0xFF007AFF),
            ],
          ),
        ),
        child: const Icon(
          Icons.lock_outline,
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }
}
