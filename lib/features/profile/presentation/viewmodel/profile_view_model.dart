import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/authentication/domain/usecases/auth_usecase.dart';
import 'package:sangeet/features/profile/presentation/state/current_user_state.dart';

final profileViewModelProvider = StateNotifierProvider<ProfileViewModel,CurrentUserState>(
        (ref) {
      return ProfileViewModel(authUseCase: ref.read(authUseCaseProvider));
    }
);

class ProfileViewModel extends StateNotifier<CurrentUserState>{
  ProfileViewModel({required this.authUseCase}) : super(CurrentUserState.initial()){
    getCurrentUser();
  }

  final AuthUseCase authUseCase;

  Future resetState() async {
    state = CurrentUserState.initial();
    getCurrentUser();
  }

  getCurrentUser() {
    state = state.copyWith(isLoading: true);
    authUseCase.getCurrentUser().then((data) {
      data.fold(
            (failure) {
          state = state.copyWith(isLoading: false);
          showMySnackBar(message: failure.error, color: Colors.red);
        },
            (user) {
          state =
              state.copyWith(isLoading: false, authEntity: user);
        },
      );
    });
  }

  Future<void> uploadImage(File? image) async {
    state = state.copyWith(isLoading: true);
    var data = await authUseCase.uploadProfilePicture(image!);
    data.fold(
          (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
          (imageName) {
        state =
            state.copyWith(isLoading: false, error: null, imageName: imageName);
        showMySnackBar(message: 'Profile Picture has been updated.');
        getCurrentUser();
      },
    );
  }
}