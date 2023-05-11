class ResetTPIN1State {
  bool loading;
  bool done;
  String error;
  String? password;
  ResetTPIN1State({
    this.loading = false,
    this.done = false,
    this.error = '',
    this.password,
  });

  ResetTPIN1State copyWith({
    bool? loading,
    bool? done,
    String? error,
    String? password,
  }) {
    return ResetTPIN1State(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
      password: password ?? this.password,
    );
  }
}
