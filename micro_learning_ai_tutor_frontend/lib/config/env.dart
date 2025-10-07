/// Environment configuration for API base URL and other runtime settings.
/// Uses --dart-define to allow overriding at build/run time without code changes.
class AppEnv {
  // PUBLIC_INTERFACE
  /// Base URL for the backend API.
  /// Defaults to the docker-compose service hostname so the mobile app can reach
  /// the backend when running in the same compose network.
  ///
  /// Override at build/run-time:
  /// flutter run --dart-define=BACKEND_BASE_URL=http://localhost:8080
  static const String backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://backend-api:8080',
  );
}
