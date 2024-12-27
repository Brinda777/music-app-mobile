import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/artist/domain/usecases/artist_usecase.dart';
import 'package:sangeet/features/artist/presentation/state/artist_state.dart';

final artistViewmodelProvider = StateNotifierProvider<ArtistViewModel, ArtistState>(
      (ref) {
    return ArtistViewModel(ref.read(artistUsecaseProvider));
  },
);

class ArtistViewModel extends StateNotifier<ArtistState> {
  ArtistViewModel(this.artistUseCase) : super(ArtistState.initial()) {
    getAllArtists();
  }

  final ArtistUseCase artistUseCase;

  Future resetState() async {
    state = ArtistState.initial();
    getAllArtists();
  }

  // For getting all artists
  getAllArtists() async {
    // To show the progress bar
    state = state.copyWith(isLoading: true);
    final currentState = state;
    final page = currentState.page + 1;
    final artists = currentState.lstArtists;
    final hasReachedMax = currentState.hasReachedMax;

    if (!hasReachedMax) {
      var data = await artistUseCase.getAllArtists(page);
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
                lstArtists: [...artists, ...r],
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


  getArtist(String id) async {
    state = state.copyWith(isLoading: true);
    var data = await artistUseCase.getArtist(id);
    data.fold(
          (l) {
        state = state.copyWith(
            hasReachedMax: true, isLoading: false, error: l.error);
        showMySnackBar(message: l.error, color: Colors.red);
      },
          (r) {
          state = state.copyWith(
              isLoading: false,
              error: null,
              artist: r
          );
      },
    );
  }
}
