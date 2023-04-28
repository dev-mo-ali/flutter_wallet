class ForgetPasswordState {
  bool loading;
  bool done;
  String error;
  String countryCode;
  String phoneError;
  ForgetPasswordState({
    this.loading = false,
    this.done = false,
    this.error = '',
    this.countryCode = '60',
    this.phoneError = '',
  });

  ForgetPasswordState copyWith({
    bool? loading,
    bool? done,
    String? error,
    String? countryCode,
    String? phoneError,
  }) {
    return ForgetPasswordState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
      countryCode: countryCode ?? this.countryCode,
      phoneError: phoneError ?? this.phoneError,
    );
  }
}
