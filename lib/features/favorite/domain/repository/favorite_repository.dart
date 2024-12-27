import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/favorite/data/repository/favorite_remote_repository.dart';
import 'package:sangeet/features/favorite/domain/entity/favorite_entity.dart';

final favoriteRepositoryProvider = Provider<IFavoriteRepository>((ref) {
  return ref.read(favoriteRemoteRepositoryProvider);
});

abstract class IFavoriteRepository {
  Future<Either<Failure, List<FavoriteEntity>>> getAllFavorites(int page);
  Future<Either<Failure, FavoriteEntity>> getFavorite(String songId);
  Future<Either<Failure, bool>> addSongToFavorite(String songId);
  Future<Either<Failure, bool>> removeSongFromFavorite(String songId);
}
