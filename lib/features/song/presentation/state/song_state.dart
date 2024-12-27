import 'package:sangeet/features/song/domain/entity/song_entity.dart';

class SongState {
  final List<SongEntity> lstSongs;
  final bool isLoading;
  final String? error;
  final bool hasReachedMax;
  final int page;

  SongState({
    required this.lstSongs,
    required this.isLoading,
    this.error,
    required this.hasReachedMax,
    required this.page,
  });

  factory SongState.initial() {
    return SongState(
      lstSongs: [],
      isLoading: false,
      error: null,
      hasReachedMax: false,
      page: 0,
    );
  }

  SongState copyWith({
    List<SongEntity>? lstSongs,
    bool? isLoading,
    String? error,
    bool? hasReachedMax,
    int? page,
  }) {
    return SongState(
      lstSongs: lstSongs ?? this.lstSongs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }
}
