import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/genre/data/repository/genre_remote_repository.dart';
import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';

final genreRepositoryProvider = Provider<IGenreRepository>((ref) {
  return ref.read(genreRemoteRepositoryProvider);
});

abstract class IGenreRepository {
  Future<Either<Failure, List<GenreEntity>>> getAllGenres(int page);
}
