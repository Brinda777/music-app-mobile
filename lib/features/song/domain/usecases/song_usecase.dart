import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';
import 'package:sangeet/features/song/domain/repository/song_repository.dart';

final songUsecaseProvider = Provider<SongUseCase>(
      (ref) => SongUseCase(
    songRepository: ref.read(songRepositoryProvider),
  ),
);

class SongUseCase {
  final ISongRepository songRepository;

  SongUseCase({required this.songRepository});

  // For getting all songs
  Future<Either<Failure, List<SongEntity>>> getAllSongs(int page) {
    return songRepository.getAllSongs(page);
  }

  // For getting trending songs
  Future<Either<Failure, List<SongEntity>>> getTrendingSongs(int page) {
    return songRepository.getTrendingSongs(page);
  }

  // For getting popular songs
  Future<Either<Failure, List<SongEntity>>> getPopularSongs(int page) {
    return songRepository.getPopularSongs(page);
  }

  Future<Either<Failure, List<SongEntity>>> searchAllSongs(int page, String keyword) {
    return songRepository.searchAllSongs(page, keyword);
  }

  Future<Either<Failure, List<SongEntity>>> getSongsByArtist(int page, String keyword) {
    return songRepository.getSongsByArtist(page, keyword);
  }

  Future<Either<Failure, List<SongEntity>>> getSongsByGenre(int page, String keyword) {
    return songRepository.getSongsByGenre(page, keyword);
  }
}
