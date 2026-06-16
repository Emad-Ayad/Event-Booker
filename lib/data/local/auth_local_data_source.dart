import 'package:sqflite/sqflite.dart';
import '../model/UserModel.dart';


class AuthLocalDataSource {
  final Database _db;

  AuthLocalDataSource(this._db);

  Future<int> signUp(UserModel user) async {
    return await _db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final result = await _db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> signIn(String email, String password) async {
    final result = await _db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }
}