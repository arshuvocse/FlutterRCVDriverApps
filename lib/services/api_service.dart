import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://38.247.64.237:82/api/';
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Uri _buildUri(String endpoint) => Uri.parse('$_baseUrl$endpoint');

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final response = await _client.post(
      _buildUri(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('POST $endpoint failed: ${response.statusCode}');
    }
    return response;
  }

  Future<Map<String, dynamic>> postJson(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await post(endpoint, body);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<String> get(String endpoint) async {
    final response = await _client.get(_buildUri(endpoint));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('GET $endpoint failed: ${response.statusCode}');
    }
    return response.body;
  }
}
