import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/authentication/data/data_source/local/auth_local_datasource.dart';
import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';
import 'package:sangeet/features/authentication/domain/repository/auth_repository.dart';

final authLocalRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthLocalRepository(
    ref.read(authLocalDataSourceProvider),
  );
});

class AuthLocalRepository implements IAuthRepository {
  final AuthLocalDataSource _authLocalDataSource;

  AuthLocalRepository(this._authLocalDataSource);

  @override
  Future<Either<Failure, bool>> login(String email, String password) {
    return _authLocalDataSource.login(email, password);
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) {
    return _authLocalDataSource.register(user);
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File image) async {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> logout() {
    throw UnimplementedError();
  }
}
