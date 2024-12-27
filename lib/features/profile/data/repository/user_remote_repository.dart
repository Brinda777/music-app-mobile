import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/profile/data/data_source/user_remote_data_source.dart';
import 'package:sangeet/features/profile/domain/entity/user_entity.dart';
import 'package:sangeet/features/profile/domain/repository/user_repository.dart';

final userRemoteRepositoryProvider = Provider<IUserRepository>((ref) {
  return UserRemoteRepository(
    ref.read(userRemoteDataSourceProvider),
  );
});

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRemoteRepository(this._userRemoteDataSource);

  @override
  Future<Either<Failure, bool>> editUser(UserEntity user) {
    return _userRemoteDataSource.editUser(user);
  }

  @override
  Future<Either<Failure, bool>> changePassword(
      String oldPassword, String newPassword) {
    return _userRemoteDataSource.changePassword(oldPassword, newPassword);
  }
}
