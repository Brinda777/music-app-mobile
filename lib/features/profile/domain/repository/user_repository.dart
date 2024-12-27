import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/profile/data/repository/user_remote_repository.dart';
import 'package:sangeet/features/profile/domain/entity/user_entity.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return ref.read(userRemoteRepositoryProvider);
});

abstract class IUserRepository {
  Future<Either<Failure, bool>> editUser(UserEntity user);
  Future<Either<Failure, bool>> changePassword(
      String oldPassword, String newPassword);
}
