import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';

class ArtistState {
  final List<ArtistEntity> lstArtists;
  final bool isLoading;
  final String? error;
  final bool hasReachedMax;
  final int page;
  final ArtistEntity? artist;

  ArtistState({
    required this.lstArtists,
    required this.isLoading,
    this.error,
    required this.hasReachedMax,
    required this.page,
    this.artist,
  });

  factory ArtistState.initial() {
    return ArtistState(
      lstArtists: [],
      isLoading: false,
      error: null,
      hasReachedMax: false,
      page: 0,
      artist: null
    );
  }

  ArtistState copyWith({
    List<ArtistEntity>? lstArtists,
    bool? isLoading,
    String? error,
    bool? hasReachedMax,
    int? page,
    ArtistEntity? artist
  }) {
    return ArtistState(
      lstArtists: lstArtists ?? this.lstArtists,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      artist: artist ?? this.artist
    );
  }
}
