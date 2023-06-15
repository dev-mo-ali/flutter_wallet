class TopUpState {
  bool done;
  bool submitting;
  bool loading;
  bool loadingAmount;
  String error;
  double amount;
  bool isVoucher;
  Map? config;
  TopUpState({
    this.done = false,
    this.submitting = false,
    this.loading = true,
    this.loadingAmount = false,
    this.error = '',
    this.amount = 0,
    this.isVoucher = false,
    this.config,
  });

  TopUpState copyWith({
    bool? done,
    bool? submitting,
    bool? loading,
    bool? loadingAmount,
    String? error,
    double? amount,
    bool? isVoucher,
    Map? config,
  }) {
    return TopUpState(
      done: done ?? this.done,
      submitting: submitting ?? this.submitting,
      loading: loading ?? this.loading,
      loadingAmount: loadingAmount ?? this.loadingAmount,
      error: error ?? this.error,
      amount: amount ?? this.amount,
      isVoucher: isVoucher ?? this.isVoucher,
      config: config ?? this.config,
    );
  }
}
