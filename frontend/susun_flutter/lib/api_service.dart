import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for your backend API. Update this if you deploy to production.
  static const String baseUrl = "http://127.0.0.1:8000";

  /// Login function: Sends a POST request with username and password.
  /// On success, returns the token as a string.
  static Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      // Expecting response in the form { "token": "your_token_value" }
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      // Login failed; you could also return error message or throw an exception.
      return null;
    }
  }

  /// Logout function: Sends a POST request with the Authorization header.
  /// Returns true if successful.
  static Future<bool> logout(String token) async {
    final url = Uri.parse('$baseUrl/api/auth/logout/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    // We assume a 200 status indicates a successful logout.
    return response.statusCode == 200;
  }
}
