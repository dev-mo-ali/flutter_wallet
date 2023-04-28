class ForgetPassword2State {
  bool showPass;
  bool showConfPass;
  bool loading;
  bool done;
  String error;
  ForgetPassword2State({
    this.showPass = false,
    this.showConfPass = false,
    this.loading = false,
    this.done = false,
    this.error = '',
  });

  ForgetPassword2State copyWith({
    bool? showPass,
    bool? showConfPass,
    bool? loading,
    bool? done,
    String? error,
  }) {
    return ForgetPassword2State(
      showPass: showPass ?? this.showPass,
      showConfPass: showConfPass ?? this.showConfPass,
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
    );
  }
}
