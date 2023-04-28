class StartUpState {
  bool loading;
  bool? login;
  bool done;
  bool? goUpdate;
  bool? goSetup;
  bool? goEmailVerify;
  bool? wrongCred;
  StartUpState({
    this.loading = false,
    this.login,
    this.done = false,
    this.goUpdate,
    this.goSetup,
    this.goEmailVerify,
    this.wrongCred,
  });

  StartUpState copyWith({
    bool? loading,
    bool? login,
    bool? done,
    bool? goUpdate,
    bool? goSetup,
    bool? goEmailVerify,
    bool? wrongCred,
  }) {
    return StartUpState(
      loading: loading ?? this.loading,
      login: login ?? this.login,
      done: done ?? this.done,
      goUpdate: goUpdate ?? this.goUpdate,
      goSetup: goSetup ?? this.goSetup,
      goEmailVerify: goEmailVerify ?? this.goEmailVerify,
      wrongCred: wrongCred ?? this.wrongCred,
    );
  }
}
