class WithdrawRequestsState {
  static const STATUS_PENDING = "PENDING";
  static const STATUS_COMPLETED = "COMPLETED";
  static const STATUS_CANCELLED = "CANCELLED";
  static const STATUS_REJECTED = "REJECTED";
  bool loaded;
  bool loading;
  List requests;
  int page;
  int pageCount;
  WithdrawRequestsState({
    this.loaded = false,
    this.loading = true,
    this.requests = const [],
    this.page = 1,
    this.pageCount = 0,
  });

  WithdrawRequestsState copyWith({
    bool? loaded,
    bool? loading,
    List? requests,
    int? page,
    int? pageCount,
  }) {
    return WithdrawRequestsState(
      loaded: loaded ?? this.loaded,
      loading: loading ?? this.loading,
      requests: requests ?? this.requests,
      page: page ?? this.page,
      pageCount: pageCount ?? this.pageCount,
    );
  }
}
