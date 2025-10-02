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
        _apiService.setAuthToken(token);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.register(
        name: name,
        email: email,
        phone: phone,
      );

      _isLoading = false;
      notifyListeners();

      return response['success'] == true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendOtp({required String phone}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.sendOtp(phone: phone);

      _isLoading = false;
      notifyListeners();

      return response['success'] == true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.verifyOtp(
        phone: phone,
        otp: otp,
      );

      if (response['success'] == true && response['data'] != null) {
        _token = response['data']['token'];
        _user = User.fromJson(response['data']['user']);

        // Save to secure storage
        await _secureStorage.write(key: 'auth_token', value: _token);
        await _secureStorage.write(
          key: 'user_data',
          value: json.encode(_user!.toJson()),
        );

        _apiService.setAuthToken(_token!);

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
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
    _apiService.clearAuthToken();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
