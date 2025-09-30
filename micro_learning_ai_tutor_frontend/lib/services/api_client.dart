import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// PUBLIC_INTERFACE
class ApiClient {
  /// Simple API client for the Micro-Learning backend.
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080/api/v1');

  final http.Client _client;
  final String _baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // PUBLIC_INTERFACE
  Future<Map<String, dynamic>> register({required String email, required String name, required String password}) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'name': name, 'password': password}),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // PUBLIC_INTERFACE
  Future<bool> login({required String email, required String password}) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 && body['success'] == true) {
      final token = body['data']['access_token'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      return true;
    }
    if (kDebugMode) {
      debugPrint('Login failed: ${res.statusCode} $body');
    }
    return false;
  }

  // PUBLIC_INTERFACE
  Future<List<dynamic>> listProjects() async {
    final res = await _client.get(Uri.parse('$_baseUrl/projects'), headers: await _headers());
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 && body['success'] == true) {
      return body['data'] as List<dynamic>;
    }
    return [];
  }
}
