class UnlockPhoneState {
  bool loading;
  bool done;
  UnlockPhoneState({
    this.loading = true,
    this.done = false,
  });

  UnlockPhoneState copyWith({
    bool? loading,
    bool? done,
  }) {
    return UnlockPhoneState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
    );
  }
}
