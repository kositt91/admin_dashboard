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
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_accessTokenKey);
  }

  // New method to save only the access token
  static Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_accessTokenKey, accessToken);
  }
}
