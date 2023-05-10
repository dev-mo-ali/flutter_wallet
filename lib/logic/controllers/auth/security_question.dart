import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/security_question.dart';
import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';

class SecurityQueCubit extends Cubit<SecurityQueState> {
  SecurityQueCubit() : super(SecurityQueState()) {
    getQuestions().then((value) => null);
  }

  // get the question to the api
  Future<void> getQuestions() async {
    emit(state.copyWith(loading: true));
    ServerResponse response = await AuthAPI.getSecurityQuestions();
    List questions = response.data['questions'];
    if (response.isSuccess) {
      // set first item as default choice
      Map? cq;
      if (questions.isNotEmpty) {
        cq = questions.first;
      }
      emit(state.copyWith(
          loading: false, questions: questions, currentQuestion: cq));
    } else {
      emit(state.copyWith(loading: false));
    }
  }

  void selectQuestion(int id) => emit(state.copyWith(
      currentQuestion:
          state.questions!.where((element) => element['id'] == id).first));

  // send setup request to the api
  void setup(String answer, String tpin) async {
    emit(state.copyWith(submitting: true));
    ServerResponse response =
        await AuthAPI.firstSetup(state.currentQuestion!, answer, tpin);
    if (response.isSuccess) {
      emit(state.copyWith(submitting: false, done: true, error: ''));
    } else {
      emit(state.copyWith(submitting: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }

  // send reset security question request to the api
  void reset(String answer) async {
    emit(state.copyWith(submitting: true));
    ServerResponse response = await AccountAPI.changeSecurityQuestion(
        state.currentQuestion!['id'], answer);

    if (response.isSuccess) {
      emit(state.copyWith(submitting: false, done: true, error: ''));
    } else {
      emit(state.copyWith(submitting: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }
}
