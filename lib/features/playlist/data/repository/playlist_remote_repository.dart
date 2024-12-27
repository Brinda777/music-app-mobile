import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/playlist/data/data_source/playlist_remote_data_source.dart';
import 'package:sangeet/features/playlist/domain/entity/playlist_entity.dart';
import 'package:sangeet/features/playlist/domain/repository/playlist_repository.dart';

final playlistRemoteRepositoryProvider = Provider<IPlaylistRepository>(
  (ref) => PlaylistRemoteRepository(
    playlistRemoteDataSource: ref.read(playlistRemoteDataSourceProvider),
  ),
);

class PlaylistRemoteRepository implements IPlaylistRepository {
  final PlaylistRemoteDataSource playlistRemoteDataSource;

  PlaylistRemoteRepository({required this.playlistRemoteDataSource});

  @override
  Future<Either<Failure, bool>> addPlaylist(String name) {
    return playlistRemoteDataSource.addPlaylist(name);
  }

  @override
  Future<Either<Failure, bool>> addSongToPlaylist(
      String playlistId, String songId) {
    return playlistRemoteDataSource.addSongToPlaylist(playlistId, songId);
  }

  @override
  Future<Either<Failure, bool>> deletePlaylist(String playlistId) {
    return playlistRemoteDataSource.deletePlaylist(playlistId);
  }

  @override
  Future<Either<Failure, List<PlaylistEntity>>> getAllPlaylists(int page) {
    return playlistRemoteDataSource.getAllPlaylists(page);
  }

  @override
  Future<Either<Failure, PlaylistEntity>> getPlaylist(String playlistId) {
    return playlistRemoteDataSource.getPlaylist(playlistId);
  }

  @override
  Future<Either<Failure, bool>> updatePlaylist(String playlistId, String name) {
    return playlistRemoteDataSource.updatePlaylist(playlistId, name);
  }
}
