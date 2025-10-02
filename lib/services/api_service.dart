import 'package:dio/dio.dart';
import '../config.dart';
import '../models/user.dart';
import '../models/stats.dart';

class ApiService {
  late final Dio _dio;

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

  /// Register a new user
  ///
  /// Sample Request:
  /// {
  ///   "name": "John Doe",
  ///   "email": "john@example.com",
  ///   "phone": "9876543210"
  /// }
  ///
  /// Sample Response:
  /// {
  ///   "success": true,
  ///   "message": "Registration successful",
  ///   "data": {
  ///     "userId": "12345"
  ///   }
  /// }
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
  }) async {
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

  /// Send OTP to phone number
  ///
  /// Sample Request:
  /// {
  ///   "phone": "9876543210"
  /// }
  ///
  /// Sample Response:
  /// {
  ///   "success": true,
  ///   "message": "OTP sent successfully",
  ///   "data": {
  ///     "otpSent": true
  ///   }
  /// }
  Future<Map<String, dynamic>> sendOtp({
    required String phone,
  }) async {
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

  /// Verify OTP
  ///
  /// Sample Request:
  /// {
  ///   "phone": "9876543210",
  ///   "otp": "123456"
  /// }
  ///
  /// Sample Response:
  /// {
  ///   "success": true,
  ///   "message": "OTP verified successfully",
  ///   "data": {
  ///     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  ///     "user": {
  ///       "id": "12345",
  ///       "name": "John Doe",
  ///       "email": "john@example.com",
  ///       "phone": "9876543210"
  ///     }
  ///   }
  /// }
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
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

  /// Get user statistics
  ///
  /// Sample Response:
  /// {
  ///   "success": true,
  ///   "data": {
  ///     "totalCalls": 150,
  ///     "pendingCalls": 25,
  ///     "completedCalls": 100,
  ///     "scheduledCalls": 25,
  ///     "callsByDay": [
  ///       {"day": "Mon", "calls": 20},
  ///       {"day": "Tue", "calls": 35},
  ///       {"day": "Wed", "calls": 28}
  ///     ]
  ///   }
  /// }
  Future<Stats> getStats() async {
    try {
      final response = await _dio.get(AppConfig.statsEndpoint);
      return Stats.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get user profile
  Future<User> getUserProfile() async {
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
