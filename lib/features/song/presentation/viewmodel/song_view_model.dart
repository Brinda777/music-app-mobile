import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/song/domain/usecases/song_usecase.dart';
import 'package:sangeet/features/song/presentation/state/song_state.dart';

final songViewmodelProvider = StateNotifierProvider<SongViewmodel, SongState>(
  (ref) {
    return SongViewmodel(ref.read(songUsecaseProvider));
  },
);

class SongViewmodel extends StateNotifier<SongState> {
  SongViewmodel(this.songUseCase) : super(SongState.initial()) {
    getAllSongs();
  }

  final SongUseCase songUseCase;

  Future resetState() async {
    state = SongState.initial();
    getAllSongs();
  }

  // For getting all songs
  getAllSongs() async {
    // To show the progress bar
    state = state.copyWith(isLoading: true);
    final currentState = state;
    final page = currentState.page + 1;
    final songs = currentState.lstSongs;
    final hasReachedMax = currentState.hasReachedMax;

    if (!hasReachedMax) {
      var data = await songUseCase.getAllSongs(page);
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
                lstSongs: [...songs, ...r],
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
