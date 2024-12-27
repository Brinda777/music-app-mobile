import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/song/domain/usecases/song_usecase.dart';
import 'package:sangeet/features/song/presentation/state/song_state.dart';

final genreSongViewmodelProvider = StateNotifierProvider.family<GenreSongViewmodel, SongState, String>(
      (ref, keyword) {
    final songUseCase = ref.read(songUsecaseProvider);
    return GenreSongViewmodel(songUseCase, keyword);
  },
);

class GenreSongViewmodel extends StateNotifier<SongState> {
  GenreSongViewmodel(this.songUseCase, this.keyword) : super(SongState.initial()) {
    getGenreSongs(keyword);
  }

  final SongUseCase songUseCase;
  final String keyword;

  Future<void> resetState() async {
    state = SongState.initial();
    await getGenreSongs(keyword);
  }

  Future<void> getGenreSongs(String keyword) async {
    if (state.isLoading || state.hasReachedMax) return;

    state = state.copyWith(isLoading: true);

    final currentState = state;
    final page = currentState.page + 1;
    final songs = currentState.lstSongs;

    try {
      final data = await songUseCase.getSongsByGenre(page, keyword);
      data.fold(
            (failure) {
          state = state.copyWith(
            hasReachedMax: true,
            isLoading: false,
            error: failure.error,
          );
          showMySnackBar(message: failure.error);
        },
            (newSongs) {
          if (newSongs.isEmpty) {
            state = state.copyWith(
              hasReachedMax: true,
              isLoading: false,
              error: null,
            );
          } else {
            state = state.copyWith(
              isLoading: false,
              lstSongs: [...songs, ...newSongs],
              error: null,
              page: page,
              hasReachedMax: newSongs.length < ApiEndpoints.limitPage,
            );
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      showMySnackBar(message: 'An unexpected error occurred.');
    }
  }
}
