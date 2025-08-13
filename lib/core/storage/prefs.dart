import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const _kToken = 'auth_token';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs!.setString(_kToken, token);
  }

  static String? get token => _prefs!.getString(_kToken);

  static bool get hasToken => _prefs!.containsKey(_kToken);

  static Future<void> clearToken() async {
    await _prefs!.remove(_kToken);
  }
}
