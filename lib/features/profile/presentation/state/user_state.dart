class UserState {
  final bool isLoading;
  final String? error;

  UserState({
    required this.isLoading,
    this.error,
  });

  factory UserState.initial() {
    return UserState(isLoading: false, error: null);
  }

  UserState copyWith({bool? isLoading, String? error}) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => 'UserState(isLoading: $isLoading, error: $error)';
}
