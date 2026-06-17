
import '../local/SessionManager.dart';

class SessionRepository {
  Future<bool> isLoggedIn() => SessionManager.isLoggedIn();

  Future<void> setLoggedIn({
    required bool isLoggedIn,
    String? email,
  }) {
    return SessionManager.setLoggedIn(isLoggedIn: isLoggedIn, email: email);
  }

  Future<void> logout() => SessionManager.logout();

  Future<bool> getRememberMe() => SessionManager.getRememberMe();

  Future<Map<String, String?>> getRememberedCredentials() {
    return SessionManager.getRememberedCredentials();
  }

  Future<void> saveRememberMe({
    required bool rememberMe,
    required String email,
    required String password,
  }) {
    return SessionManager.saveRememberMe(
      rememberMe: rememberMe,
      email: email,
      password: password,
    );
  }
  Future<String?> getLoggedInUserEmail() {
    return SessionManager.getLoggedInUserEmail();
  }
}