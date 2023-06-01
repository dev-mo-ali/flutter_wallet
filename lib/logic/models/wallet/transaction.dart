class TransactionState {
  bool loading;
  Map? data;
  bool submitting;
  bool done;
  String error;
  TransactionState({
    this.loading = true,
    this.data,
    this.submitting = false,
    this.done = false,
    this.error = '',
  });

  TransactionState copyWith({
    bool? loading,
    Map? data,
    bool? submitting,
    bool? done,
    String? error,
  }) {
    return TransactionState(
      loading: loading ?? this.loading,
      data: data ?? this.data,
      submitting: submitting ?? this.submitting,
      done: done ?? this.done,
      error: error ?? this.error,
    );
  }
}
