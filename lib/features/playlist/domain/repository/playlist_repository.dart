import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/playlist/data/repository/playlist_remote_repository.dart';
import 'package:sangeet/features/playlist/domain/entity/playlist_entity.dart';

final playlistRepositoryProvider = Provider<IPlaylistRepository>((ref) {
  return ref.read(playlistRemoteRepositoryProvider);
});

abstract class IPlaylistRepository {
  Future<Either<Failure, List<PlaylistEntity>>> getAllPlaylists(int page);
  Future<Either<Failure, PlaylistEntity>> getPlaylist(String playlistId);
  Future<Either<Failure, bool>> addSongToPlaylist(
      String playlistId, String songId);
  Future<Either<Failure, bool>> addPlaylist(String name);
  Future<Either<Failure, bool>> updatePlaylist(String playlistId, String name);
  Future<Either<Failure, bool>> deletePlaylist(String playlistId);
}
