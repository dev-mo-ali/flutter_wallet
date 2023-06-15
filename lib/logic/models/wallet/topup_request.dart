class TopupRequestState {
  bool loading;
  bool submitting;
  String? status;
  String error;
  Map? data;
  TopupRequestState({
    this.loading = true,
    this.submitting = false,
    this.status,
    this.error = '',
    this.data,
  });

  TopupRequestState copyWith({
    bool? loading,
    bool? submitting,
    String? status,
    String? error,
    Map? data,
  }) {
    return TopupRequestState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      status: status ?? this.status,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }
}
