class TopupRequestsState {
  static const STATUS_PENDING = "PENDING";
  static const STATUS_APPROVED = "APPROVED";
  static const STATUS_COMPLETED = "COMPLETED";
  static const STATUS_CANCELLED = "CANCELLED";
  static const STATUS_REJECTED = "REJECTED";
  bool loaded;
  bool loading;
  List requests;
  int page;
  int pageCount;
  TopupRequestsState({
    this.loaded = false,
    this.loading = true,
    this.requests = const [],
    this.page = 1,
    this.pageCount = 0,
  });

  TopupRequestsState copyWith({
    bool? loaded,
    bool? loading,
    List? requests,
    int? page,
    int? pageCount,
  }) {
    return TopupRequestsState(
      loaded: loaded ?? this.loaded,
      loading: loading ?? this.loading,
      requests: requests ?? this.requests,
      page: page ?? this.page,
      pageCount: pageCount ?? this.pageCount,
    );
  }
}
