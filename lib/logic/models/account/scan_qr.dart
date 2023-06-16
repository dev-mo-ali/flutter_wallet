class ScanQrState {
  bool loading;
  String error;
  Map? data;
  ScanQrState({
    this.loading = false,
    this.error = '',
    this.data,
  });

  ScanQrState copyWith({
    bool? loading,
    String? error,
    Map? data,
  }) {
    return ScanQrState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }
}
