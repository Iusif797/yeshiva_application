class AppConfig {
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');
  static const String env = String.fromEnvironment('ENV', defaultValue: '');
  static bool get isMock => env.toLowerCase() == 'dev' || env.toLowerCase() == 'mock';
}


