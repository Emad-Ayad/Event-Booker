import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SessionManager {
  SessionManager._();

  static const _isLoggedInKey = 'is_logged_in';
  static const _loggedInUserEmailKey = 'logged_in_user_email';

  static const _rememberMeKey = 'remember_me';
  static const _rememberedEmailKey = 'remembered_email';
  static const _rememberedPasswordKey = 'remembered_password';

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> setLoggedIn({
    required bool isLoggedIn,
    String? email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);

    if (email != null) {
      await prefs.setString(_loggedInUserEmailKey, email);
    } else {
      await prefs.remove(_loggedInUserEmailKey);
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getLoggedInUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loggedInUserEmailKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_loggedInUserEmailKey);
  }

  static Future<void> saveRememberMe({
    required bool rememberMe,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);

    if (rememberMe) {
      await _secureStorage.write(key: _rememberedEmailKey, value: email);
      await _secureStorage.write(key: _rememberedPasswordKey, value: password);
    } else {
      await _secureStorage.delete(key: _rememberedEmailKey);
      await _secureStorage.delete(key: _rememberedPasswordKey);
    }
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  static Future<Map<String, String?>> getRememberedCredentials() async {
    final email = await _secureStorage.read(key: _rememberedEmailKey);
    final password = await _secureStorage.read(key: _rememberedPasswordKey);

    return {
      'email': email,
      'password': password,
    };
  }
}