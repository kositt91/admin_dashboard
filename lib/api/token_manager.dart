import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    if (accessToken.split(".").length != 3 ||
        refreshToken.split(".").length != 3) {
      throw const FormatException("Invalid tokens");
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_accessTokenKey, accessToken);
    prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  static Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_accessTokenKey, accessToken);
  }

  static Future<bool> verifyAccessToken(String accessToken) async {
    final url = Uri.parse(
        'https://rfqos.internal.engineerforce.io/api/v1/token/verify/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'token': accessToken});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Token verification response: $jsonResponse');

        // Assuming the response has a field 'valid' or similar to indicate token validity
        if (jsonResponse.containsKey('valid')) {
          return jsonResponse['valid'];
        } else if (jsonResponse.containsKey('token_valid')) {
          return jsonResponse['token_valid'];
        } else if (jsonResponse.containsKey('is_valid')) {
          return jsonResponse['is_valid'];
        } else {
          // Adjust this to the actual structure of your API response
          return true; // or false depending on your API
        }
      } else {
        print('Failed to verify token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error verifying token: $e');
      return false;
    }
  }
}
