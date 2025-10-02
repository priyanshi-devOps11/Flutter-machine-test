import 'package:dio/dio.dart';
import '../config.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: Config.baseUrl, connectTimeout: 10000),
  );

  Future<Response> register(Map<String, dynamic> body) async {
    return _dio.post('/register', data: body); // adjust path to API doc
  }

  Future<Response> sendOtp(Map<String, dynamic> body) async {
    return _dio.post('/send-otp', data: body); // adjust
  }

  Future<Response> verifyOtp(Map<String, dynamic> body) async {
    return _dio.post('/verify-otp', data: body);
  }

  Future<Response> getStats(String token) async {
    return _dio.get(
      '/dashboard/stats',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
