import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config.dart';
import '../models/user.dart';
import '../models/stats.dart';

class ApiService {
  late final Dio _dio;

  // Set this to true to use mock data (no backend needed)
  // Set to false when you have a real backend
  static const bool useMockData = true;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors for logging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (useMockData) {
      debugPrint('🎭 Mock Register: $name, $email, $phone');
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': true,
        'message': 'Registration successful',
        'data': {'userId': '123'}
      };
    }

    try {
      final response = await _dio.post(
        AppConfig.registerEndpoint,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> sendOtp({
    required String phone,
  }) async {
    if (useMockData) {
      debugPrint('🎭 Mock Send OTP to: $phone');
      await Future.delayed(const Duration(seconds: 1));
      return {
        'success': true,
        'message': 'OTP sent successfully',
        'data': {'otpSent': true}
      };
    }

    try {
      final response = await _dio.post(
        AppConfig.sendOtpEndpoint,
        data: {
          'phone': phone,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    if (useMockData) {
      debugPrint('🎭 Mock Verify OTP: $phone, $otp');
      await Future.delayed(const Duration(seconds: 1));

      // Accept any 6-digit OTP
      if (otp.length == 6) {
        return {
          'success': true,
          'message': 'OTP verified successfully',
          'data': {
            'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
            'user': {
              'id': '123',
              'name': 'Test User',
              'email': 'test@example.com',
              'phone': phone,
            }
          }
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid OTP',
        };
      }
    }

    try {
      final response = await _dio.post(
        AppConfig.verifyOtpEndpoint,
        data: {
          'phone': phone,
          'otp': otp,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Stats> getStats() async {
    if (useMockData) {
      debugPrint('🎭 Mock Get Stats');
      await Future.delayed(const Duration(seconds: 1));
      return Stats.fromJson({
        'totalCalls': 150,
        'pendingCalls': 25,
        'completedCalls': 100,
        'scheduledCalls': 25,
        'callsByDay': [
          {'day': 'Mon', 'calls': 20},
          {'day': 'Tue', 'calls': 35},
          {'day': 'Wed', 'calls': 28},
          {'day': 'Thu', 'calls': 22},
          {'day': 'Fri', 'calls': 30},
          {'day': 'Sat', 'calls': 10},
          {'day': 'Sun', 'calls': 5},
        ]
      });
    }

    try {
      final response = await _dio.get(AppConfig.statsEndpoint);
      return Stats.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> getUserProfile() async {
    if (useMockData) {
      debugPrint('🎭 Mock Get User Profile');
      await Future.delayed(const Duration(seconds: 1));
      return User.fromJson({
        'id': '123',
        'name': 'Test User',
        'email': 'test@example.com',
        'phone': '9876543210',
      });
    }

    try {
      final response = await _dio.get(AppConfig.userProfileEndpoint);
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
      return 'Server error: ${error.response?.statusCode}';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
