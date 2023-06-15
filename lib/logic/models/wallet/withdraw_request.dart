class WithdrawRequestState {
  bool loading;
  bool submitting;
  String? status;
  String error;
  Map? data;
  WithdrawRequestState({
    this.loading = true,
    this.submitting = false,
    this.status,
    this.error = '',
    this.data,
  });

  WithdrawRequestState copyWith({
    bool? loading,
    bool? submitting,
    String? status,
    String? error,
    Map? data,
  }) {
    return WithdrawRequestState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      status: status ?? this.status,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }
}
