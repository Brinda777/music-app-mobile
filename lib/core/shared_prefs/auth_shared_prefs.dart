import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authSharedPrefsProvider = Provider<AuthSharedPrefs>((ref) {
  return AuthSharedPrefs();
});

class AuthSharedPrefs {
  late SharedPreferences _sharedPreferences;
  // Set auth token
  Future<Either<Failure, bool>> setAuthToken(String token) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString('token', token);
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  // Get auth token
  Future<Either<Failure, String?>> getAuthToken() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final token = _sharedPreferences.getString('token');
      return right(token);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  // Delete token
  Future<Either<Failure, bool>> deleteAuthToken() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.remove('token');
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  // Set User
  Future<Either<Failure, bool>> setUser(AuthEntity user) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString ('user', user.toString());
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  // Get User
  Future<Either<Failure, String?>> getUser() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final token = _sharedPreferences.getString('user');
      return right(token);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  // Delete User
  Future<Either<Failure, bool>> deleteUser() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.remove('user');
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }
}
