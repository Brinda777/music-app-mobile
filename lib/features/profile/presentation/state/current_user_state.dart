import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';

class CurrentUserState {
  final bool isLoading;
  final AuthEntity? authEntity;
  final String? error;
  final String? imageName;

  CurrentUserState({
    required this.isLoading,
    required this.authEntity,
    this.error,
    this.imageName
  });

  factory CurrentUserState.initial() {
    return CurrentUserState(isLoading: false, authEntity: null, error: null, imageName: null);
  }

  CurrentUserState copyWith({
    bool? isLoading,
    AuthEntity? authEntity,
    String? error,
    String? imageName
  }) {
    return CurrentUserState(
      isLoading: isLoading ?? this.isLoading,
      authEntity: authEntity ?? this.authEntity,
      error: error ?? this.error,
      imageName: imageName ?? this.imageName
    );
  }

  @override
  String toString() => 'CurrentUserState(isLoading: $isLoading, error: $error)';
}
