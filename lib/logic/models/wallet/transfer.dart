class TransferState {
  bool loading;
  bool submitting;
  bool done;
  String error;
  Map? config;
  String? fullName;
  bool qrUsed;
  TransferState({
    this.loading = true,
    this.submitting = false,
    this.done = false,
    this.error = '',
    this.config,
    this.fullName,
    this.qrUsed = false,
  });

  TransferState copyWith({
    bool? loading,
    bool? submitting,
    bool? done,
    String? error,
    Map? config,
    String? fullName,
    bool? qrUsed,
  }) {
    return TransferState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      done: done ?? this.done,
      error: error ?? this.error,
      config: config ?? this.config,
      fullName: fullName ?? this.fullName,
      qrUsed: qrUsed ?? this.qrUsed,
    );
  }
}
