class SecurityQueState {
  bool loading;
  bool submitting;
  bool done;
  List? questions;
  Map? currentQuestion;
  String error;
  SecurityQueState({
    this.loading = true,
    this.submitting = false,
    this.done = false,
    this.questions,
    this.currentQuestion,
    this.error = '',
  });

  SecurityQueState copyWith({
    bool? loading,
    bool? submitting,
    bool? done,
    List? questions,
    Map? currentQuestion,
    String? error,
  }) {
    return SecurityQueState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      done: done ?? this.done,
      questions: questions ?? this.questions,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      error: error ?? this.error,
    );
  }
}
