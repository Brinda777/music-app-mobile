import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';
import 'package:sangeet/features/genre/domain/repository/genre_repository.dart';

final genreUsecaseProvider = Provider<GenreUsecase>(
      (ref) => GenreUsecase(
    genreRepository: ref.read(genreRepositoryProvider),
  ),
);

class GenreUsecase {
  final IGenreRepository genreRepository;

  GenreUsecase({required this.genreRepository});

  // For getting all songs
  Future<Either<Failure, List<GenreEntity>>> getAllGenres(int page) {
    return genreRepository.getAllGenres(page);
  }
}
