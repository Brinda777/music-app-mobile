import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/favorite/data/data_source/favorite_remote_data_source.dart';
import 'package:sangeet/features/favorite/domain/entity/favorite_entity.dart';
import 'package:sangeet/features/favorite/domain/repository/favorite_repository.dart';

final favoriteRemoteRepositoryProvider = Provider<IFavoriteRepository>(
  (ref) => FavoriteRemoteRepository(
    favoriteRemoteDataSource: ref.read(favoriteRemoteDataSourceProvider),
  ),
);

class FavoriteRemoteRepository implements IFavoriteRepository {
  final FavoriteRemoteDataSource favoriteRemoteDataSource;

  FavoriteRemoteRepository({required this.favoriteRemoteDataSource});

  @override
  Future<Either<Failure, List<FavoriteEntity>>> getAllFavorites(int page) {
    return favoriteRemoteDataSource.getAllFavorites(page);
  }

  @override
  Future<Either<Failure, FavoriteEntity>> getFavorite(String songId) {
    return favoriteRemoteDataSource.getFavorite(songId);
  }

  @override
  Future<Either<Failure, bool>> addSongToFavorite(String songId) {
    return favoriteRemoteDataSource.addSongToFavorite(songId);
  }

  @override
  Future<Either<Failure, bool>> removeSongFromFavorite(String songId) {
    return favoriteRemoteDataSource.removeSongFromFavorite(songId);
  }
}
