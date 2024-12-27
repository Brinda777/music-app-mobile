import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/profile/domain/entity/user_entity.dart';
import 'package:sangeet/features/profile/domain/usecases/user_usecase.dart';
import 'package:sangeet/features/profile/presentation/state/user_state.dart';

final userViewModelProvider =
    StateNotifierProvider<UserViewModel, UserState>((ref) {
  return UserViewModel(userUseCase: ref.read(userUseCaseProvider));
});

class UserViewModel extends StateNotifier<UserState> {
  UserViewModel({required this.userUseCase}) : super(UserState.initial()) {}

  final UserUseCase userUseCase;

  Future resetState() async {
    state = UserState.initial();
  }

  editUser(UserEntity user) {
    state = state.copyWith(isLoading: true);
    userUseCase.editUser(user).then((data) {
      data.fold(
        (failure) {
          state = state.copyWith(isLoading: false);
          showMySnackBar(message: failure.error, color: Colors.red);
        },
        (user) {
          state = state.copyWith(isLoading: false);
          showMySnackBar(message: 'User has been updated.');
        },
      );
    });
  }

  changePassword(String oldPassword, String newPassword) {
    state = state.copyWith(isLoading: true);
    userUseCase.changePassword(oldPassword, newPassword).then((data) {
      data.fold(
        (failure) {
          state = state.copyWith(isLoading: false);
          showMySnackBar(message: failure.error, color: Colors.red);
        },
        (user) {
          state = state.copyWith(isLoading: false);
          showMySnackBar(message: 'Password has been changed.');
        },
      );
    });
  }
}
