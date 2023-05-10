class Register2State {
  String? icImg;
  bool loading;
  String error;
  String birthError;
  String icImgError;
  String phoneError;
  bool done;
  String idType;
  String countryCode;
  DateTime? birth;
  Register2State({
    this.icImg,
    this.loading = false,
    this.error = '',
    this.birthError = '',
    this.icImgError = '',
    this.phoneError = '',
    this.done = false,
    this.idType = 'ic',
    this.countryCode = '60',
    this.birth,
  });

  Register2State copyWith({
    String? icImg,
    bool? loading,
    String? error,
    String? birthError,
    String? icImgError,
    String? phoneError,
    bool? done,
    String? idType,
    String? countryCode,
    DateTime? birth,
  }) {
    return Register2State(
      icImg: icImg ?? this.icImg,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      birthError: birthError ?? this.birthError,
      icImgError: icImgError ?? this.icImgError,
      phoneError: phoneError ?? this.phoneError,
      done: done ?? this.done,
      idType: idType ?? this.idType,
      countryCode: countryCode ?? this.countryCode,
      birth: birth ?? this.birth,
    );
  }
}
