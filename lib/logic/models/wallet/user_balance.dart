class UserBalanceState {
  bool loading;
  String? balance;
  UserBalanceState({
    this.loading = true,
    this.balance,
  });

  UserBalanceState copyWith({
    bool? loading,
    String? balance,
  }) {
    return UserBalanceState(
      loading: loading ?? this.loading,
      balance: balance ?? this.balance,
    );
  }
}
