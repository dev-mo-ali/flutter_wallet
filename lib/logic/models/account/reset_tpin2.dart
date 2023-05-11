class ResetTPIN2State {
  bool loading;
  bool done;
  String error;
  ResetTPIN2State({
    this.loading = true,
    this.done = false,
    this.error = '',
  });

  ResetTPIN2State copyWith({
    bool? loading,
    bool? done,
    String? error,
  }) {
    return ResetTPIN2State(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
    );
  }
}
