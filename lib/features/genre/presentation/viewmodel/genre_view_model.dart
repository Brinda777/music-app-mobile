import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/genre/domain/usecases/genre_usecase.dart';
import 'package:sangeet/features/genre/presentation/state/genre_state.dart';

final genreViewmodelProvider = StateNotifierProvider<GenreViewModel, GenreState>(
      (ref) {
    return GenreViewModel(ref.read(genreUsecaseProvider));
  },
);

class GenreViewModel extends StateNotifier<GenreState> {
  GenreViewModel(this.genreUsecase) : super(GenreState.initial()) {
    getAllGenres();
  }

  final GenreUsecase genreUsecase;

  Future resetState() async {
    state = GenreState.initial();
    getAllGenres();
  }

  // For getting all artists
  getAllGenres() async {
    // To show the progress bar
    state = state.copyWith(isLoading: true);
    final currentState = state;
    final page = currentState.page + 1;
    final genres = currentState.lstGenres;
    final hasReachedMax = currentState.hasReachedMax;

    if (!hasReachedMax) {
      var data = await genreUsecase.getAllGenres(page);
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
                lstGenres: [...genres, ...r],
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
}
