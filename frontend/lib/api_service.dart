import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://disband-pacific-juror.ngrok-free.dev';

  static Future<Map<String, dynamic>> createUser(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> checkUrl(String url, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/check-url'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url, 'user_id': userId}),
    );

    if (response.statusCode == 403) {
      return {'error': 'limit_reached'};
    }

    return jsonDecode(response.body);
  }
}