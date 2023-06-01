class ForgetPassword2State {
  bool loading;
  bool done;
  String error;
  String countryCode;
  ForgetPassword2State({
    this.loading = false,
    this.done = false,
    this.error = '',
    this.countryCode = '60',
  });

  ForgetPassword2State copyWith({
    bool? loading,
    bool? done,
    String? error,
    String? countryCode,
  }) {
    return ForgetPassword2State(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
      countryCode: countryCode ?? this.countryCode,
    );
  }
}
