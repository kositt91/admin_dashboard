import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> getUserDetails(String token) async {
    final url = '$baseUrl/user/me/';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer $token', // Add your authentication token here
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successful request
        return json.decode(response.body);
      } else {
        // Handle error cases
        print('API Error - Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load user details');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = '$baseUrl'; // Adjust this endpoint according to your API

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Successful login
        return json.decode(response.body);
      } else {
        // Handle error cases
        print('Login failed - Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to login');
    }
  }
}
