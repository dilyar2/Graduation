class ApiConfig {






  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://goodbye.runasp.net',
  );
}
