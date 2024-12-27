import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/song/data/data_source/remote/song_remote_datasource.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';
import 'package:sangeet/features/song/domain/repository/song_repository.dart';

final songRemoteRepositoryProvider = Provider<ISongRepository>(
      (ref) => SongRemoteRepository(
    songRemoteDataSource: ref.read(songRemoteDataSourceProvider),
  ),
);

class SongRemoteRepository implements ISongRepository {
  final SongRemoteDataSource songRemoteDataSource;

  SongRemoteRepository({required this.songRemoteDataSource});

  @override
  Future<Either<Failure, List<SongEntity>>> getAllSongs(int page) {
    return songRemoteDataSource.getAllSongs(page);
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getTrendingSongs(int page) {
    return songRemoteDataSource.getTrendingSongs(page);
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getPopularSongs(int page) {
    return songRemoteDataSource.getPopularSongs(page);
  }

  @override
  Future<Either<Failure, List<SongEntity>>> searchAllSongs(int page, String keyword) {
    return songRemoteDataSource.searchAllSongs(page, keyword);
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getSongsByArtist(int page, String keyword) {
    return songRemoteDataSource.getSongsByArtist(page, keyword);
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getSongsByGenre(int page, String keyword) {
    return songRemoteDataSource.getSongsByGenre(page, keyword);
  }
}
