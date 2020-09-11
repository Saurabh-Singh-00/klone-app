import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static String _authToken = "";

  static String get authToken => _authToken;

  static Future<String> loadAuthToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _authToken = sharedPreferences.getString('token');
    return _authToken;
  }

  static Future<bool> saveAuthToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _authToken = token;
    return await sharedPreferences.setString('token', token);
  }

  static Future<bool> deleteAuthToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _authToken = "";
    return await sharedPreferences.remove('token');
  }
}
