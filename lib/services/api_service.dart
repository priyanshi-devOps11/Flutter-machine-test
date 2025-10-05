import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // Base URL for the API
  static const String baseUrl = 'https://mock-api.calleyacd.com/api/auth';

  // Timeout duration
  static const Duration timeout = Duration(seconds: 30);

  /// Send OTP to the provided email
  ///
  /// Request: POST /send-otp
  /// Body: { "email": "testing@yopmail.com" }
  /// Response: { "message": "OTP sent" }
  Future<Map<String, dynamic>> sendOtp({required String email}) async {
    try {
      debugPrint('📤 Sending OTP to: $email');

      final url = Uri.parse('$baseUrl/send-otp');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
            }),
          )
          .timeout(timeout);

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'OTP sent successfully',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to send OTP',
        };
      }
    } catch (e) {
      debugPrint('❌ Send OTP Error: $e');
      return {
        'success': false,
        'message': _handleException(e),
      };
    }
  }

  /// Verify OTP for the provided email
  ///
  /// Request: POST /verify-otp
  /// Body: { "email": "testing@yopmail.com", "otp": "229166" }
  /// Response: { "message": "OTP Verified" }
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      debugPrint('📤 Verifying OTP for: $email with OTP: $otp');

      final url = Uri.parse('$baseUrl/verify-otp');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'otp': otp,
            }),
          )
          .timeout(timeout);

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'OTP verified successfully',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Invalid OTP',
        };
      }
    } catch (e) {
      debugPrint('❌ Verify OTP Error: $e');
      return {
        'success': false,
        'message': _handleException(e),
      };
    }
  }

  /// Handle exceptions and return user-friendly messages
  String _handleException(dynamic error) {
    String errorStr = error.toString();

    if (errorStr.contains('SocketException') ||
        errorStr.contains('Failed host lookup')) {
      return 'No internet connection. Please check your network.';
    } else if (errorStr.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    } else if (errorStr.contains('FormatException')) {
      return 'Invalid response from server.';
    } else if (errorStr.contains('HandshakeException')) {
      return 'Secure connection failed. Please try again.';
    }

    return 'An unexpected error occurred. Please try again.';
  }

  Future getStats() async {}
}
