import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:micro_learning_ai_tutor_frontend/config/env.dart';

/// Lightweight HTTP client to interact with the backend using a configurable base URL.
class ApiClient {
  ApiClient({http.Client? httpClient})
      : _http = httpClient ?? http.Client(),
        _baseUri = _normalizeBaseUrl(AppEnv.backendBaseUrl);

  final http.Client _http;
  final Uri _baseUri;

  static Uri _normalizeBaseUrl(String base) {
    // Ensure the base URL has no trailing slash to avoid double slashes on join.
    final sanitized = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    return Uri.parse(sanitized);
  }

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final cleanedPath = path.startsWith('/') ? path : '/$path';
    return _baseUri.replace(
      path: '${_baseUri.path}$cleanedPath',
      queryParameters: query?.map((k, v) => MapEntry(k, '$v')),
    );
  }

  Map<String, String> get _jsonHeaders => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // PUBLIC_INTERFACE
  /// Performs a GET request and returns decoded JSON.
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final uri = _buildUri(path, query);
    if (kDebugMode) {
      // ignore: avoid_print
      print('[ApiClient][GET] $uri');
    }
    final res = await _http.get(uri, headers: _jsonHeaders);
    return _handleResponse(res);
  }

  // PUBLIC_INTERFACE
  /// Performs a POST request with a JSON body and returns decoded JSON.
  Future<dynamic> post(String path, Map<String, dynamic> body, {Map<String, dynamic>? query}) async {
    final uri = _buildUri(path, query);
    if (kDebugMode) {
      // ignore: avoid_print
      print('[ApiClient][POST] $uri body=${jsonEncode(body)}');
    }
    final res = await _http.post(uri, headers: _jsonHeaders, body: jsonEncode(body));
    return _handleResponse(res);
  }

  dynamic _handleResponse(http.Response res) {
    final status = res.statusCode;
    final text = res.body;
    if (status >= 200 && status < 300) {
      if (text.isEmpty) return null;
      try {
        return jsonDecode(text);
      } catch (_) {
        return text;
      }
    } else {
      throw ApiException(
        statusCode: status,
        message: _extractErrorMessage(text) ?? 'Request failed with status $status',
        rawBody: text,
      );
    }
  }

  String? _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['message'] is String) {
        return decoded['message'] as String;
      }
      if (decoded is Map && decoded['error'] is String) {
        return decoded['error'] as String;
      }
    } catch (_) {
      // not JSON
    }
    return null;
  }
}

/// Exception thrown by ApiClient for non-2xx responses.
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.rawBody,
  });

  final int statusCode;
  final String message;
  final String? rawBody;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
