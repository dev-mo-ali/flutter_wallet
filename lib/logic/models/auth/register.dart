class RegisterState {
  bool loading;
  String error;
  String phoneError;
  String userIdError;
  bool done;
  String countryCode;
  RegisterState({
    this.loading = false,
    this.error = '',
    this.phoneError = '',
    this.userIdError = '',
    this.done = false,
    this.countryCode = '60',
  });

  RegisterState copyWith({
    bool? loading,
    String? error,
    String? phoneError,
    String? userIdError,
    bool? done,
    String? countryCode,
  }) {
    return RegisterState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      phoneError: phoneError ?? this.phoneError,
      userIdError: userIdError ?? this.userIdError,
      done: done ?? this.done,
      countryCode: countryCode ?? this.countryCode,
    );
  }
}
