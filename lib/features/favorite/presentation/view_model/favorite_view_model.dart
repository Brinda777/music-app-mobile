import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/favorite/domain/usecases/favorite_usecase.dart';
import 'package:sangeet/features/favorite/presentation/state/favorite_state.dart';

final favoriteViewmodelProvider =
    StateNotifierProvider<FavoriteViewModel, FavoriteState>(
  (ref) {
    return FavoriteViewModel(ref.read(favoriteUsecaseProvider));
  },
);

class FavoriteViewModel extends StateNotifier<FavoriteState> {
  FavoriteViewModel(this.favoriteUseCase) : super(FavoriteState.initial()) {
    getAllFavorites();
  }

  final FavoriteUseCase favoriteUseCase;

  Future resetState() async {
    state = FavoriteState.initial();
    getAllFavorites();
  }

  getAllFavorites() async {
    // To show the progress bar
    state = state.copyWith(isLoading: true);
    final currentState = state;
    final page = currentState.page + 1;
    final favorites = currentState.lstFavorites;
    final hasReachedMax = currentState.hasReachedMax;

    if (!hasReachedMax) {
      var data = await favoriteUseCase.getAllFavorites(page);
      data.fold(
        (l) {
          state = state.copyWith(
              hasReachedMax: true, isLoading: false, error: l.error);
          showMySnackBar(message: l.error, color: Colors.red);
        },
        (r) {
          if (r.isEmpty) {
            state = state.copyWith(
                hasReachedMax: true, isLoading: false, error: null);
          } else {
            state = state.copyWith(
                isLoading: false,
                lstFavorites: [...favorites, ...r],
                error: null,
                page: page,
                hasReachedMax: false);
          }
        },
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  getFavorite(String songId) async {
    state = state.copyWith(isLoading: true);
    var data = await favoriteUseCase.getFavorite(songId);
    data.fold(
      (l) {
        state = state.copyWith(
            hasReachedMax: true, isLoading: false, error: l.error);
        showMySnackBar(message: l.error, color: Colors.red);
      },
      (r) {
        state = state.copyWith(isLoading: false, error: null, favorite: r);
      },
    );
  }

  addSongToFavorite(String songId) async {
    state = state.copyWith(isLoading: true);
    var data = await favoriteUseCase.addSongToFavorite(songId);
    data.fold(
      (l) {
        state = state.copyWith(
            hasReachedMax: true, isLoading: false, error: l.error);
        showMySnackBar(message: l.error, color: Colors.red);
      },
      (r) {
        state = state.copyWith(isLoading: false, error: null);
        showMySnackBar(message: 'Song has been added to the favorite.');
      },
    );
    resetState();
  }

  removeSongFromFavorite(String songId) async {
    state = state.copyWith(isLoading: true);
    var data = await favoriteUseCase.removeSongFromFavorite(songId);
    data.fold(
      (l) {
        state = state.copyWith(
            hasReachedMax: true, isLoading: false, error: l.error);
        showMySnackBar(message: l.error, color: Colors.red);
      },
      (r) {
        state = state.copyWith(isLoading: false, error: null);
        showMySnackBar(message: 'Song has been removed to the favorite.');
      },
    );
    resetState();
  }
}
