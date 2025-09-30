import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// PUBLIC_INTERFACE
class ApiService {
  /// API service for the Node.js backend.
  ///
  /// Configuration:
  /// - Reads API base from dart-define 'NODE_API_BASE_URL' first.
  /// - Falls back to dotenv-like dart-define 'API_BASE_URL' if present.
  /// - Finally defaults to 'http://localhost:3000' (Node typical port).
  ///
  /// To set at build/run:
  /// flutter run --dart-define=NODE_API_BASE_URL=http://localhost:3000
  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment('NODE_API_BASE_URL', defaultValue: '') // preferred for Node
                .ifEmpty(
                  const String.fromEnvironment('API_BASE_URL', defaultValue: ''),
                )
                .ifEmpty('http://localhost:3000');

  final http.Client _client;
  final String _baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final token = withAuth ? await _getToken() : null;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // PUBLIC_INTERFACE
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String name,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/register');
    final res = await _client.post(
      uri,
      headers: await _headers(withAuth: false),
      body: jsonEncode({'email': email, 'name': name, 'password': password}),
    );

    final body = _safeDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body;
    }
    if (kDebugMode) {
      debugPrint('registerUser failed: ${res.statusCode} $body');
    }
    throw ApiException('Registration failed', status: res.statusCode, data: body);
  }

  // PUBLIC_INTERFACE
  Future<List<dynamic>> fetchLessons() async {
    final uri = Uri.parse('$_baseUrl/api/v1/lessons');
    final res = await _client.get(uri, headers: await _headers());
    final body = _safeDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If backend returns a bare array
      if (body['data'] is List) {
        return (body['data'] as List).cast<dynamic>();
      }
      // If _safeDecode produced {'data': <anything>} but not a list, try to coerce
      final raw = body['data'];
      if (raw is List) {
        return raw.cast<dynamic>();
      }
      // If _safeDecode created {'raw': ...} from a non-JSON response
      return <dynamic>[];
    }
    if (kDebugMode) {
      debugPrint('fetchLessons failed: ${res.statusCode} $body');
    }
    throw ApiException('Fetch lessons failed', status: res.statusCode, data: body);
  }

  Map<String, dynamic> _safeDecode(String s) {
    try {
      final decoded = jsonDecode(s);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    } catch (_) {
      return {'raw': s};
    }
  }
}

/// Simple extension to help with empty fallback.
extension _IfEmpty on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}

/// Error wrapper for API calls.
class ApiException implements Exception {
  ApiException(this.message, {this.status, this.data});
  final String message;
  final int? status;
  final Object? data;

  @override
  String toString() => 'ApiException(status=$status, message=$message, data=$data)';
}
