
import '../local/auth_local_data_source.dart';
import '../model/UserModel.dart';



class AuthRepository {
  final AuthLocalDataSource authLocalDataSource;

  AuthRepository(this.authLocalDataSource);

  Future<UserModel?> getUserByEmail(String email) {
    return authLocalDataSource.getUserByEmail(email);
  }

  Future<void> signUp(UserModel user) async {
    await authLocalDataSource.signUp(user);
  }

  Future<UserModel?> signIn(String email, String password) {
    return authLocalDataSource.signIn(email, password);
  }
}