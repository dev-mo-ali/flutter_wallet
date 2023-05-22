class StartUpState {
  bool loading;
  bool done;
  bool? goUpdate;
  StartUpState({
    this.loading = false,
    this.done = false,
    this.goUpdate,
  });

  StartUpState copyWith({
    bool? loading,
    bool? done,
    bool? goUpdate,
  }) {
    return StartUpState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      goUpdate: goUpdate ?? this.goUpdate,
    );
  }
}
