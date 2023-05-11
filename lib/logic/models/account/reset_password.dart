class ResetPasswordState {
  bool loading;
  bool done;
  String error;
  ResetPasswordState({
    this.loading = false,
    this.done = false,
    this.error = '',
  });

  ResetPasswordState copyWith({
    bool? loading,
    bool? done,
    String? error,
  }) {
    return ResetPasswordState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
    );
  }
}
