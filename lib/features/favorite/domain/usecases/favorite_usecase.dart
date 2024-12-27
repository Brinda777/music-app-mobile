import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/favorite/domain/entity/favorite_entity.dart';
import 'package:sangeet/features/favorite/domain/repository/favorite_repository.dart';

final favoriteUsecaseProvider = Provider<FavoriteUseCase>(
  (ref) => FavoriteUseCase(
    favoriteRepository: ref.read(favoriteRepositoryProvider),
  ),
);

class FavoriteUseCase {
  final IFavoriteRepository favoriteRepository;

  FavoriteUseCase({required this.favoriteRepository});

  Future<Either<Failure, List<FavoriteEntity>>> getAllFavorites(int page) {
    return favoriteRepository.getAllFavorites(page);
  }

  Future<Either<Failure, FavoriteEntity>> getFavorite(String id) {
    return favoriteRepository.getFavorite(id);
  }

  Future<Either<Failure, bool>> addSongToFavorite(String id) {
    return favoriteRepository.addSongToFavorite(id);
  }

  Future<Either<Failure, bool>> removeSongFromFavorite(String id) {
    return favoriteRepository.removeSongFromFavorite(id);
  }
}
