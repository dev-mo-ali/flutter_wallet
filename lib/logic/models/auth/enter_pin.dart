class EnterPINState {
  bool loading;
  bool done;
  String error;
  EnterPINState({
    this.loading = false,
    this.done = false,
    this.error = '',
  });

  EnterPINState copyWith({
    bool? loading,
    bool? done,
    String? error,
  }) {
    return EnterPINState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
    );
  }
}
