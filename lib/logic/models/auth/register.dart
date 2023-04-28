class RegisterState {
  bool loading;
  String error;
  String phoneError;
  bool done;
  String countryCode;
  RegisterState({
    this.loading = false,
    this.error = '',
    this.phoneError = '',
    this.done = false,
    this.countryCode = '60',
  });

  RegisterState copyWith({
    bool? loading,
    String? error,
    String? phoneError,
    bool? done,
    String? countryCode,
  }) {
    return RegisterState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      phoneError: phoneError ?? this.phoneError,
      done: done ?? this.done,
      countryCode: countryCode ?? this.countryCode,
    );
  }
}
