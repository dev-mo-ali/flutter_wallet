class UpdatePhone3State {
  static const timeOfResend = 300;

  int secondsReaming;
  bool loading;
  bool done;
  String error;
  bool resending;
  UpdatePhone3State({
    this.secondsReaming = UpdatePhone3State.timeOfResend,
    this.loading = false,
    this.done = false,
    this.error = '',
    this.resending = false,
  });

  UpdatePhone3State copyWith({
    int? secondsReaming,
    bool? loading,
    bool? done,
    String? error,
    bool? resending,
  }) {
    return UpdatePhone3State(
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
