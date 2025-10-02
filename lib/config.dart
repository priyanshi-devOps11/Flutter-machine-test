/// Configuration file for Get Calley App
///
/// IMPORTANT: Set the BASE_URL to your API endpoint
/// For testing with Postman: https://documenter.getpostman.com/view/38199901/2sB34Zpiy9
class AppConfig {
  // TODO: Replace with your actual API base URL
  static const String baseUrl = 'https://your-api-base-url.com/api';

  // API Endpoints
  static const String registerEndpoint = '/register';
  static const String sendOtpEndpoint = '/send-otp';
  static const String verifyOtpEndpoint = '/verify-otp';
  static const String statsEndpoint = '/stats';
  static const String userProfileEndpoint = '/user/profile';

  // WhatsApp Configuration
  static const String hrWhatsAppNumber = '918296435200';
  static const String whatsAppMessage = 'Hello, I would like to start calling';

  // App Configuration
  static const String appName = 'Get Calley';
  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
