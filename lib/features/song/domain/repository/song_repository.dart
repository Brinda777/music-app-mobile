import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/song/data/repository/song_remote_repository.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';

final songRepositoryProvider = Provider<ISongRepository>((ref) {
  return ref.read(songRemoteRepositoryProvider);
});

abstract class ISongRepository {
  Future<Either<Failure, List<SongEntity>>> getAllSongs(int page);
  Future<Either<Failure, List<SongEntity>>> getTrendingSongs(int page);
  Future<Either<Failure, List<SongEntity>>> getPopularSongs(int page);
  Future<Either<Failure, List<SongEntity>>> searchAllSongs(int page, String keyword);
  Future<Either<Failure, List<SongEntity>>> getSongsByArtist(int page, String keyword);
  Future<Either<Failure, List<SongEntity>>> getSongsByGenre(int page, String keyword);
}
