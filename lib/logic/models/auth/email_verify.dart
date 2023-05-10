class EmailVerifyState {
  static const timeOfResend = 300;
  bool sending;
  bool sent;
  bool loading;
  bool done;
  String error;
  String? email;

  int secondsReaming;
  bool resending;
  EmailVerifyState({
    this.sending = true,
    this.sent = false,
    this.loading = false,
    this.done = false,
    this.error = '',
    this.email,
    this.secondsReaming = timeOfResend,
    this.resending = false,
  });

  EmailVerifyState copyWith({
    bool? sending,
    bool? sent,
    bool? loading,
    bool? done,
    String? error,
    String? email,
    int? secondsReaming,
    bool? resending,
  }) {
    return EmailVerifyState(
      sending: sending ?? this.sending,
      sent: sent ?? this.sent,
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
      email: email ?? this.email,
      secondsReaming: secondsReaming ?? this.secondsReaming,
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
