import 'package:sangeet/features/playlist/domain/entity/playlist_entity.dart';

class PlaylistState {
  final List<PlaylistEntity> lstPlaylists;
  final bool isLoading;
  final String? error;
  final bool hasReachedMax;
  final int page;
  final PlaylistEntity? playlist;

  PlaylistState({
    required this.lstPlaylists,
    required this.isLoading,
    this.error,
    required this.hasReachedMax,
    required this.page,
    this.playlist,
  });

  factory PlaylistState.initial() {
    return PlaylistState(
        lstPlaylists: [],
        isLoading: false,
        error: null,
        hasReachedMax: false,
        page: 0,
        playlist: null);
  }

  PlaylistState copyWith(
      {List<PlaylistEntity>? lstPlaylists,
      bool? isLoading,
      String? error,
      bool? hasReachedMax,
      int? page,
      PlaylistEntity? playlist}) {
    return PlaylistState(
        lstPlaylists: lstPlaylists ?? this.lstPlaylists,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
        playlist: playlist ?? this.playlist);
  }
}
