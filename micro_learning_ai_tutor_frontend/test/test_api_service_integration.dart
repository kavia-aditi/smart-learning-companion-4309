import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:micro_learning_ai_tutor_frontend/services/api_service.dart';

void main() {
  group('ApiService (Node backend) integration via mocked HTTP', () {
    test('registerUser posts correct payload and parses success response', () async {
      // Arrange: mock server verifying method, path, headers, and body
      final mock = MockClient((http.Request req) async {
        expect(req.method, equals('POST'));
        expect(req.url.toString(), equals('http://mock.local/api/v1/register'));

        // Content-Type header should be application/json
        expect(req.headers['content-type'], contains('application/json'));

        // Body should include required fields
        final body = jsonDecode(req.body) as Map<String, dynamic>;
        expect(body['email'], equals('user@example.com'));
        expect(body['name'], equals('User'));
        expect(body['password'], equals('secret123'));

        // Return a typical success envelope
        final payload = {
          'success': true,
          'data': {
            'id': 'u-123',
            'email': 'user@example.com',
            'name': 'User',
          },
          'meta': {'request_id': 'r-1', 'duration_ms': 12}
        };
        return http.Response(jsonEncode(payload), 201, headers: {'content-type': 'application/json'});
      });

      final api = ApiService(client: mock, baseUrl: 'http://mock.local');

      // Act
      final resp = await api.registerUser(email: 'user@example.com', name: 'User', password: 'secret123');

      // Assert
      expect(resp['success'], isTrue);
      expect(resp['data'], isA<Map<String, dynamic>>());
      expect(resp['data']['email'], 'user@example.com');
      expect(resp['data']['name'], 'User');
    });

    test('registerUser throws ApiException when backend responds with error', () async {
      // Arrange a failing backend response
      final mock = MockClient((http.Request req) async {
        final err = {
          'success': false,
          'error': {'code': 'CONFLICT', 'message': 'User exists'}
        };
        return http.Response(jsonEncode(err), 409, headers: {'content-type': 'application/json'});
      });

      final api = ApiService(client: mock, baseUrl: 'http://mock.local');

      // Act & Assert
      expect(
        () => api.registerUser(email: 'exists@example.com', name: 'Taken', password: 'secret123'),
        throwsA(isA<ApiException>()),
      );
    });

    test('fetchLessons GETs lessons and returns list from data field', () async {
      // Arrange lessons response
      final lessons = [
        {'id': 'l1', 'title': 'Intro to AI', 'summary': 'Basics of AI'},
        {'id': 'l2', 'title': 'Supervised Learning', 'summary': 'Core concepts'}
      ];
      final mock = MockClient((http.Request req) async {
        expect(req.method, equals('GET'));
        expect(req.url.toString(), equals('http://mock.local/api/v1/lessons'));

        // Authorization header may or may not be present; we do not require it here in test
        final payload = {
          'success': true,
          'data': lessons,
          'meta': {'request_id': 'r-2', 'duration_ms': 7}
        };
        return http.Response(jsonEncode(payload), 200, headers: {'content-type': 'application/json'});
      });

      final api = ApiService(client: mock, baseUrl: 'http://mock.local');

      // Act
      final result = await api.fetchLessons();

      // Assert
      expect(result, isA<List<dynamic>>());
      expect(result.length, 2);
      expect((result[0] as Map)['title'], 'Intro to AI');
      expect((result[1] as Map)['summary'], 'Core concepts');
    });

    test('fetchLessons throws ApiException on non-2xx', () async {
      final mock = MockClient((http.Request req) async {
        return http.Response('Internal error', 500);
      });

      final api = ApiService(client: mock, baseUrl: 'http://mock.local');

      expect(() => api.fetchLessons(), throwsA(isA<ApiException>()));
    });
  });
}
