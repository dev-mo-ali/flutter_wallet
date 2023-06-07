class TopUpState {
  bool done;
  bool loading;
  bool loadingAmount;
  String error;
  double amount;
  bool isVoucher;
  TopUpState({
    this.done = false,
    this.loading = false,
    this.loadingAmount = false,
    this.error = '',
    this.amount = 0,
    this.isVoucher = false,
  });

  TopUpState copyWith({
    bool? done,
    bool? loading,
    bool? loadingAmount,
    String? error,
    double? amount,
    bool? isVoucher,
  }) {
    return TopUpState(
      done: done ?? this.done,
      loading: loading ?? this.loading,
      loadingAmount: loadingAmount ?? this.loadingAmount,
      error: error ?? this.error,
      amount: amount ?? this.amount,
      isVoucher: isVoucher ?? this.isVoucher,
    );
  }
}
