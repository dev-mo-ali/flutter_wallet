class UpdatePhone1State {
  bool loading;
  bool done;
  String error;
  String? password;
  UpdatePhone1State({
    this.loading = false,
    this.done = false,
    this.error = '',
    this.password,
  });

  UpdatePhone1State copyWith({
    bool? loading,
    bool? done,
    String? error,
    String? password,
  }) {
    return UpdatePhone1State(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
      password: password ?? this.password,
    );
  }
}
