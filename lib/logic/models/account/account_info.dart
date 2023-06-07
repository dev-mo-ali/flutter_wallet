class AccountInfoState {
  bool avatarLoading;
  bool loading;
  bool submitting;
  String error;
  DateTime? birth;
  String? idType;
  Map? data;
  bool done;
  AccountInfoState({
    this.avatarLoading = false,
    this.loading = true,
    this.submitting = false,
    this.error = '',
    this.birth,
    this.idType,
    this.data,
    this.done = false,
  });

  AccountInfoState copyWith({
    bool? avatarLoading,
    bool? loading,
    bool? submitting,
    String? error,
    DateTime? birth,
    String? idType,
    Map? data,
    bool? done,
  }) {
    return AccountInfoState(
      avatarLoading: avatarLoading ?? this.avatarLoading,
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      error: error ?? this.error,
      birth: birth ?? this.birth,
      idType: idType ?? this.idType,
      data: data ?? this.data,
      done: done ?? this.done,
    );
  }
}
