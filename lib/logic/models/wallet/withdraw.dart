class WithdrawState {
  bool done;
  bool loading;
  bool submitting;
  String error;
  WithdrawState({
    this.done = false,
    this.loading = true,
    this.submitting = false,
    this.error = '',
  });

  WithdrawState copyWith({
    bool? done,
    bool? loading,
    String? error,
  }) {
    return WithdrawState(
      done: done ?? this.done,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
