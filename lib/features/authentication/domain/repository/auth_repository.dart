import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
// import 'package:sangeet/features/authentication/data/repository/auth_local_repository.dart';
import 'package:sangeet/features/authentication/data/repository/auth_remote_repository.dart';
import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return ref.read(authRemoteRepositoryProvider);
});

abstract class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity user);
  Future<Either<Failure, bool>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, String>> uploadProfilePicture(File image);
  Future<Either<Failure, bool>> logout();
}
