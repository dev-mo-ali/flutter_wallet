class WithdrawState {
  bool done;
  bool loading;
  bool loaded;
  List? banks;
  Map? config;
  bool submitting;
  String error;
  int? bankId;
  WithdrawState({
    this.done = false,
    this.loading = true,
    this.loaded = false,
    this.banks,
    this.config,
    this.submitting = false,
    this.error = '',
    this.bankId,
  });

  WithdrawState copyWith({
    bool? done,
    bool? loading,
    bool? loaded,
    List? banks,
    Map? config,
    bool? submitting,
    String? error,
    int? bankId,
  }) {
    return WithdrawState(
      done: done ?? this.done,
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      banks: banks ?? this.banks,
      config: config ?? this.config,
      submitting: submitting ?? this.submitting,
      error: error ?? this.error,
      bankId: bankId ?? this.bankId,
    );
  }
}
