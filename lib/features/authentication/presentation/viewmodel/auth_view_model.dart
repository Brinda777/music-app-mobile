
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';
import 'package:sangeet/features/authentication/domain/usecases/auth_usecase.dart';
import 'package:sangeet/features/authentication/presentation/navigator/login_navigator.dart';
import 'package:sangeet/features/authentication/presentation/state/auth_state.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
      (ref) => AuthViewModel(
    ref.read(loginViewNavigatorProvider),
    ref.read(authUseCaseProvider),
  ),
);

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel(this.navigator, this.authUseCase) : super(AuthState.initial());
  final AuthUseCase authUseCase;
  final LoginViewNavigator navigator;

  Future<void> register(AuthEntity user) async {
    state = state.copyWith(isLoading: true);
    var data = await authUseCase.register(user);
    data.fold(
          (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        showMySnackBar(message: failure.error, color: Colors.red);
      },
          (success) {
        state = state.copyWith(isLoading: false, error: null);
        showMySnackBar(message: "Successfully registered");
        // openDashboardView();
      },
    );
  }

  Future<void> login(
      String email,
      String password,
      ) async {
    state = state.copyWith(isLoading: true);
    var data = await authUseCase.login(email, password);
    data.fold(
          (failure) {
        state = state.copyWith(isLoading: false, error: failure.error);
        showMySnackBar(message: failure.error, color: Colors.red);
      },
          (success) {
        state = state.copyWith(isLoading: false, error: null);
        // showMySnackBar(message: "Successfully Logged In");
        openDashboardView();
      },
    );
  }

  Future<void> logout(
      ) async {
    state = state.copyWith(isLoading: true);
    var data = await authUseCase.logout();
    data.fold(
          (failure) {
        state = state.copyWith(isLoading: false, error: failure.error);
        showMySnackBar(message: failure.error, color: Colors.red);
      },
          (success) {
        state = state.copyWith(isLoading: false, error: null);
        // showMySnackBar(message: "Successfully Logged In");
        openLoginView();
      },
    );
  }

  void openRegisterView() {
    navigator.openRegisterView();
  }

  void openDashboardView() {
    navigator.openDashboardView();
  }

  void openLoginView(){
    navigator.openLoginView();
  }
}
