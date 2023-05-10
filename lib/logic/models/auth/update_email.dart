class UpdateEmailState {
  bool loading;
  bool done;
  String error;
  UpdateEmailState({
    this.loading = false,
    this.done = false,
    this.error = '',
  });

  UpdateEmailState copyWith({
    bool? loading,
    bool? done,
    String? error,
  }) {
    return UpdateEmailState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
    );
  }
}
