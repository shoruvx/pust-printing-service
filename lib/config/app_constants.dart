// lib/config/app_constants.dart

class AppConstants {
  // API Endpoints
  static const String BASE_URL = 'https://api.example.com';
  static const String LOGIN_ENDPOINT = '/auth/login';
  static const String PRINT_ENDPOINT = '/print';

  // Token System Settings
  static const String AUTH_TOKEN_KEY = 'auth_token';
  static const String REFRESH_TOKEN_KEY = 'refresh_token';

  // Print Settings
  static const int DEFAULT_PRINT_COPIES = 1;
  static const String DEFAULT_PRINT_FORMAT = 'PDF';

  // App Configuration
  static const String APP_NAME = 'Print Service';
  static const String APP_VERSION = '1.0.0';
}