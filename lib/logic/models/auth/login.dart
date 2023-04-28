class LoginState {
  bool loading;
  bool done;
  String error;
  String countryCode;
  String phoneError;
  bool? goSetup;
  bool? goEmailVerify;
  LoginState({
    this.loading = false,
    this.done = false,
    this.error = '',
    this.countryCode = '60',
    this.phoneError = '',
    this.goSetup,
    this.goEmailVerify,
  });

  LoginState copyWith({
    bool? loading,
    bool? done,
    String? error,
    String? countryCode,
    String? phoneError,
    bool? goSetup,
    bool? goEmailVerify,
  }) {
    return LoginState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
      countryCode: countryCode ?? this.countryCode,
      phoneError: phoneError ?? this.phoneError,
      goSetup: goSetup ?? this.goSetup,
      goEmailVerify: goEmailVerify ?? this.goEmailVerify,
    );
  }
}
