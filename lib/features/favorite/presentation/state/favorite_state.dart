import 'package:sangeet/features/favorite/domain/entity/favorite_entity.dart';

class FavoriteState {
  final List<FavoriteEntity> lstFavorites;
  final bool isLoading;
  final String? error;
  final bool hasReachedMax;
  final int page;
  final FavoriteEntity? favorite;

  FavoriteState({
    required this.lstFavorites,
    required this.isLoading,
    this.error,
    required this.hasReachedMax,
    required this.page,
    this.favorite,
  });

  factory FavoriteState.initial() {
    return FavoriteState(
        lstFavorites: [],
        isLoading: false,
        error: null,
        hasReachedMax: false,
        page: 0,
        favorite: null);
  }

  FavoriteState copyWith(
      {List<FavoriteEntity>? lstFavorites,
      bool? isLoading,
      String? error,
      bool? hasReachedMax,
      int? page,
      FavoriteEntity? favorite}) {
    return FavoriteState(
        lstFavorites: lstFavorites ?? this.lstFavorites,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
        favorite: favorite ?? this.favorite);
  }
}
