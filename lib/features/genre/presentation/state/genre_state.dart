import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';

class GenreState {
  final List<GenreEntity> lstGenres;
  final bool isLoading;
  final String? error;
  final bool hasReachedMax;
  final int page;

  GenreState({
    required this.lstGenres,
    required this.isLoading,
    this.error,
    required this.hasReachedMax,
    required this.page,
  });

  factory GenreState.initial() {
    return GenreState(
      lstGenres: [],
      isLoading: false,
      error: null,
      hasReachedMax: false,
      page: 0,
    );
  }

  GenreState copyWith({
    List<GenreEntity>? lstGenres,
    bool? isLoading,
    String? error,
    bool? hasReachedMax,
    int? page,
  }) {
    return GenreState(
      lstGenres: lstGenres ?? this.lstGenres,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }
}
