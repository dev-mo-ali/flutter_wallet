class UpdateIDImageState {
  String? idImg;
  String error;
  bool loading;
  bool done;
  String idType;
  UpdateIDImageState({
    this.idImg,
    this.error = '',
    this.loading = false,
    this.done = false,
    this.idType = 'ic',
  });

  UpdateIDImageState copyWith({
    String? idImg,
    String? error,
    bool? loading,
    bool? done,
    String? idType,
  }) {
    return UpdateIDImageState(
      idImg: idImg ?? this.idImg,
      error: error ?? this.error,
      loading: loading ?? this.loading,
      done: done ?? this.done,
      idType: idType ?? this.idType,
    );
  }
}
