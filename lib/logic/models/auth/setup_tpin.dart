class SetupTPINState {
  String error;
  SetupTPINState({
    this.error = '',
  });

  SetupTPINState copyWith({
    String? error,
  }) {
    return SetupTPINState(
      error: error ?? this.error,
    );
  }
}
