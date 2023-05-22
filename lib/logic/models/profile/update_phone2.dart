class UpdatePhone2State {
  bool loading;
  bool done;
  String error;
  String countryCode;
  String phoneError;
  UpdatePhone2State({
    this.loading = false,
    this.done = false,
    this.error = '',
    this.countryCode = '60',
    this.phoneError = '',
  });

  UpdatePhone2State copyWith({
    bool? loading,
    bool? done,
    String? error,
    String? countryCode,
    String? phoneError,
  }) {
    return UpdatePhone2State(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
      countryCode: countryCode ?? this.countryCode,
      phoneError: phoneError ?? this.phoneError,
    );
  }
}
