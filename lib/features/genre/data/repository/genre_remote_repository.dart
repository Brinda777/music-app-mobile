import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/genre/data/data_source/remote/genre_remote_data_source.dart';
import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';
import 'package:sangeet/features/genre/domain/repository/genre_repository.dart';

final genreRemoteRepositoryProvider = Provider<IGenreRepository>(
      (ref) => GenreRemoteRepository(
    genreRemoteDataSource: ref.read(genreRemoteDataSourceProvider),
  ),
);

class GenreRemoteRepository implements IGenreRepository {
  final GenreRemoteDataSource genreRemoteDataSource;

  GenreRemoteRepository({required this.genreRemoteDataSource});

  @override
  Future<Either<Failure, List<GenreEntity>>> getAllGenres(int page) {
    return genreRemoteDataSource.getAllGenres(page);
  }
}
