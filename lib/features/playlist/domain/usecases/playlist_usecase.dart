import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/playlist/domain/entity/playlist_entity.dart';
import 'package:sangeet/features/playlist/domain/repository/playlist_repository.dart';

final playlistUsecaseProvider = Provider<PlaylistUseCase>(
  (ref) => PlaylistUseCase(
    playlistRepository: ref.read(playlistRepositoryProvider),
  ),
);

class PlaylistUseCase {
  final IPlaylistRepository playlistRepository;

  PlaylistUseCase({required this.playlistRepository});

  Future<Either<Failure, List<PlaylistEntity>>> getAllPlaylists(int page) {
    return playlistRepository.getAllPlaylists(page);
  }

  Future<Either<Failure, PlaylistEntity>> getPlaylist(String playlistId) {
    return playlistRepository.getPlaylist(playlistId);
  }

  Future<Either<Failure, bool>> addSongToPlaylist(
      String playlistId, String songId) {
    return playlistRepository.addSongToPlaylist(playlistId, songId);
  }

  Future<Either<Failure, bool>> addPlaylist(String name) {
    return playlistRepository.addPlaylist(name);
  }

  Future<Either<Failure, bool>> updatePlaylist(String playlistId, String name) {
    return playlistRepository.updatePlaylist(playlistId, name);
  }

  Future<Either<Failure, bool>> deletePlaylist(String playlistId) {
    return playlistRepository.deletePlaylist(playlistId);
  }
}
