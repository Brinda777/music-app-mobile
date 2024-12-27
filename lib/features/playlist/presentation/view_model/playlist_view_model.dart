import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/playlist/domain/usecases/playlist_usecase.dart';
import 'package:sangeet/features/playlist/presentation/state/playlist_state.dart';

final playlistViewmodelProvider =
    StateNotifierProvider<PlaylistViewModel, PlaylistState>(
  (ref) {
    return PlaylistViewModel(ref.read(playlistUsecaseProvider));
  },
);

class PlaylistViewModel extends StateNotifier<PlaylistState> {
  PlaylistViewModel(this.playlistUseCase) : super(PlaylistState.initial()) {
    getAllPlaylists();
  }

  final PlaylistUseCase playlistUseCase;

  Future resetState() async {
    state = PlaylistState.initial();
    getAllPlaylists();
  }

  getAllPlaylists() async {
    // To show the progress bar
    state = state.copyWith(isLoading: true);
    final currentState = state;
    final page = currentState.page + 1;
    final playlists = currentState.lstPlaylists;
    final hasReachedMax = currentState.hasReachedMax;

    if (!hasReachedMax) {
      var data = await playlistUseCase.getAllPlaylists(page);
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
                lstPlaylists: [...playlists, ...r],
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

  getPlaylist(String playlistId) async {
    state = state.copyWith(isLoading: true);
    var data = await playlistUseCase.getPlaylist(playlistId);
    data.fold(
      (l) {
        state = state.copyWith(
            hasReachedMax: true, isLoading: false, error: l.error);
        showMySnackBar(message: l.error, color: Colors.red);
      },
      (r) {
        state = state.copyWith(isLoading: false, error: null, playlist: r);
      },
    );
  }

  addSongToPlaylist(String playlistId, String songId) async {
    state = state.copyWith(isLoading: true);
    var data = await playlistUseCase.addSongToPlaylist(playlistId, songId);
    data.fold(
      (l) {
        state = state.copyWith(
            hasReachedMax: true, isLoading: false, error: l.error);
        showMySnackBar(message: l.error, color: Colors.red);
      },
      (r) {
        state = state.copyWith(isLoading: false, error: null);
        showMySnackBar(message: 'Song has been added to the playlist.');
      },
    );
    resetState();
  }

  deletePlaylist(String playlistId) async {
    state = state.copyWith(isLoading: true);
    var data = await playlistUseCase.deletePlaylist(playlistId);
    data.fold(
      (l) {
        state = state.copyWith(
            hasReachedMax: true, isLoading: false, error: l.error);
        showMySnackBar(message: l.error, color: Colors.red);
      },
      (r) {
        state = state.copyWith(isLoading: false, error: null);
        showMySnackBar(message: 'Playlist has been deleted.');
      },
    );
    resetState();
  }

  addPlaylist(String name) async {
    state = state.copyWith(isLoading: true);
    var data = await playlistUseCase.addPlaylist(name);
    data.fold(
      (l) {
        state = state.copyWith(
            hasReachedMax: true, isLoading: false, error: l.error);
        showMySnackBar(message: l.error, color: Colors.red);
      },
      (r) {
        state = state.copyWith(isLoading: false, error: null);
        showMySnackBar(message: 'Playlist has been created.');
      },
    );
    resetState();
  }

  updatePlaylist(String playlistId, String name) async {
    state = state.copyWith(isLoading: true);
    var data = await playlistUseCase.updatePlaylist(playlistId, name);
    data.fold(
      (l) {
        state = state.copyWith(
            hasReachedMax: true, isLoading: false, error: l.error);
        showMySnackBar(message: l.error, color: Colors.red);
      },
      (r) {
        state = state.copyWith(isLoading: false, error: null);
        showMySnackBar(message: 'Playlist has been updated.');
      },
    );
    resetState();
  }
}
