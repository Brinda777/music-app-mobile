import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/song/domain/usecases/song_usecase.dart';
import 'package:sangeet/features/song/presentation/state/song_state.dart';

final searchViewmodelProvider = StateNotifierProvider.family<SearchViewmodel, SongState, String>(
      (ref, keyword) {
    final songUseCase = ref.read(songUsecaseProvider);
    return SearchViewmodel(songUseCase, keyword);
  },
);

class SearchViewmodel extends StateNotifier<SongState> {
  SearchViewmodel(this.songUseCase, this.keyword) : super(SongState.initial()) {
    searchAllSongs(keyword);
  }

  final SongUseCase songUseCase;
  final String keyword;

  Future<void> resetState() async {
    state = SongState.initial();
    searchAllSongs(keyword);
  }

  Future<void> searchAllSongs(String keyword) async {
    state = state.copyWith(isLoading: true);
    final currentState = state;
    final page = currentState.page + 1;
    final songs = currentState.lstSongs;
    final hasReachedMax = currentState.hasReachedMax;

    if (!hasReachedMax) {
      var data = await songUseCase.searchAllSongs(page, keyword);
      data.fold(
            (l) {
          state = state.copyWith(
            hasReachedMax: true,
            isLoading: false,
            error: l.error,
          );
          showMySnackBar(message: l.error);
        },
            (r) {
          if (r.isEmpty) {
            state = state.copyWith(
              hasReachedMax: true,
              isLoading: false,
              error: null,
            );
          } else {
            state = state.copyWith(
              isLoading: false,
              lstSongs: [...songs, ...r],
              error: null,
              page: page,
              hasReachedMax: false,
            );
          }
        },
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}
