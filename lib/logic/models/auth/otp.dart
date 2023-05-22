
class OTPState {
  static const timeOfResend = 300;

  int secondsReaming;
  bool loading;
  bool done;
  String error;
  bool resending;
  OTPState({
    this.secondsReaming = OTPState.timeOfResend,
    this.loading = false,
    this.done = false,
    this.error = '',
    this.resending = false,
  });

  OTPState copyWith({
    int? secondsReaming,
    bool? loading,
    bool? done,
    String? error,
    bool? resending,
  }) {
    return OTPState(
      secondsReaming: secondsReaming ?? this.secondsReaming,
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
      resending: resending ?? this.resending,
    );
  }

  String get timeReaming {
    if (secondsReaming <= 60) {
      return secondsReaming.toString();
    }
    int min = secondsReaming ~/ 60;
    int sec = secondsReaming % 60;
    String secAsStr = '${sec >= 10 ? sec : "0$sec"}';
    return '$min:$secAsStr';
  }
}
