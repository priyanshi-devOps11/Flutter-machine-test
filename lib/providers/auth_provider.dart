import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage;
  final ApiService _apiService;

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._secureStorage, this._apiService) {
    _loadUserData();
  }

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null && _user != null;

  Future<void> _loadUserData() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      final userJson = await _secureStorage.read(key: 'user_data');

      if (token != null && userJson != null) {
        _token = token;
        _user = User.fromJson(json.decode(userJson));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  /// Send OTP to email (used during registration)
  Future<bool> sendOtp({required String email}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('Sending OTP to: $email');
      final response = await _apiService.sendOtp(email: email);

      _isLoading = false;

      if (response['success'] == true) {
        debugPrint('OTP sent successfully');
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to send OTP';
        debugPrint('Send OTP failed: $_error');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      debugPrint('Send OTP error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('Verifying OTP for: $email');
      final response = await _apiService.verifyOtp(
        email: email,
        otp: otp,
      );

      _isLoading = false;

      // Check if verification was successful
      // API returns: {"message":"OTP Verfied"} (note the typo in their API)
      final message = response['message']?.toString().toLowerCase() ?? '';
      if (response['success'] == true ||
          message.contains('verif') ||
          message.contains('success')) {
        debugPrint('OTP verified successfully');

        // Create user after successful verification
        _user = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'User',
          email: email,
          phone: '',
        );

        _token = 'verified_${DateTime.now().millisecondsSinceEpoch}';

        // Save to secure storage
        await _secureStorage.write(key: 'auth_token', value: _token);
        await _secureStorage.write(
          key: 'user_data',
          value: json.encode(_user!.toJson()),
        );

        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Invalid OTP';
        debugPrint('Verify OTP failed: $_error');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      debugPrint('Verify OTP error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Mock login (not connected to real API)
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful login
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'User',
        email: email,
        phone: '',
      );

      _token = 'login_${DateTime.now().millisecondsSinceEpoch}';

      // Save to secure storage
      await _secureStorage.write(key: 'auth_token', value: _token);
      await _secureStorage.write(
        key: 'user_data',
        value: json.encode(_user!.toJson()),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_data');
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Parse error messages to user-friendly format
  String _parseError(dynamic error) {
    String errorStr = error.toString();

    if (errorStr.contains('SocketException') ||
        errorStr.contains('Failed host lookup')) {
      return 'No internet connection. Please check your network.';
    } else if (errorStr.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    } else if (errorStr.contains('FormatException')) {
      return 'Invalid response from server.';
    } else if (errorStr.contains('Exception:')) {
      return errorStr.split('Exception:').last.trim();
    }

    return 'An unexpected error occurred. Please try again.';
  }
}
