import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';
import 'package:sangeet/features/authentication/domain/repository/auth_repository.dart';
import 'package:sangeet/features/profile/domain/entity/user_entity.dart';
import 'package:sangeet/features/profile/domain/repository/user_repository.dart';

final userUseCaseProvider = Provider((ref) {
  return UserUseCase(ref.read(userRepositoryProvider));
});

class UserUseCase {
  final IUserRepository _userRepository;

  UserUseCase(this._userRepository);

  Future<Either<Failure, bool>> editUser(UserEntity user) async {
    return await _userRepository.editUser(user);
  }

  Future<Either<Failure, bool>> changePassword(
      String? oldPassword, String? newPassword) async {
    return await _userRepository.changePassword(oldPassword!, newPassword!);
  }
}
