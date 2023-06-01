class HistoryState {
  static const TRANSACTION_CODE_PLUS = "+";
  static const TRANSACTION_CODE_MINUS = "-";

  static const STATUS_PENDING = "PENDING";
  static const STATUS_COMPLETED = "COMPLETED";
  static const STATUS_CANCELLED = "CANCELLED";
  static const STATUS_REJECTED = "REJECTED";

  static const SERVICE_TYPE_TRANSFER = "TRANSFER";
  static const SERVICE_TYPE_INTEREST = "INTEREST";
  static const SERVICE_TYPE_SHAREHOLDER = "SHAREHOLDER";
  static const SERVICE_TYPE_REQUEST = "REQUEST";
  static const SERVICE_TYPE_TOPUP = "TOPUP";
  static const SERVICE_TYPE_WITHDRAW = "WITHDRAW";

  bool loading;
  bool loaded;
  String? balance;
  List history;
  int page;
  bool isEnd;
  HistoryState({
    this.loading = true,
    this.loaded = false,
    this.isEnd = false,
    this.balance,
    this.history = const [],
    this.page = 0,
  });

  HistoryState copyWith({
    bool? loading,
    bool? loaded,
    String? balance,
    List? history,
    int? page,
    bool? isEnd,
  }) {
    return HistoryState(
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      balance: balance ?? this.balance,
      history: history ?? this.history,
      page: page ?? this.page,
      isEnd: isEnd ?? this.isEnd,
    );
  }
}
