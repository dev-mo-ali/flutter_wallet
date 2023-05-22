class ForgetPassword1State {
  bool loading;
  bool done;
  String error;
  ForgetPassword1State({
    this.loading = false,
    this.done = false,
    this.error = '',
  });

  ForgetPassword1State copyWith({
    bool? loading,
    bool? done,
    String? error,
  }) {
    return ForgetPassword1State(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
    );
  }
}
