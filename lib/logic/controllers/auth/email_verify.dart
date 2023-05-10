import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/email_verify.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/auth.dart';

class EmailVerifyCubit extends Cubit<EmailVerifyState> {
  EmailVerifyCubit() : super(EmailVerifyState()) {
    countToResend().then((value) => null);
    User.getUser().then((value) => emit(state.copyWith(email: value.email)));
  }

  // timer to resend the verification message
  Future<void> countToResend() async {
    while (state.secondsReaming > 0) {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(secondsReaming: state.secondsReaming - 1));
    }
    emit(state.copyWith());
  }

  // verify the code
  void verify(String code) async {
    emit(state.copyWith(loading: true));
    User user = await User.getUser();
    ServerResponse response = await AuthAPI.emailVerify(user.email!, code);
    if (response.isSuccess) {
      emit(state.copyWith(loading: false, done: true, error: ''));
    } else {
      emit(state.copyWith(loading: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }

// resend the verification message
  void resend() async {
    if (!state.resending) {
      emit(state.copyWith(resending: true));
      // send http request
      ServerResponse response = await AuthAPI.resendEmailVerify(state.email!);

      if (response.isSuccess) {
        emit(state.copyWith(
            resending: false,
            secondsReaming: EmailVerifyState.timeOfResend, //reset timer
            error: ''));

        // restart timer
        countToResend().then((value) => null);
      } else {
        emit(state.copyWith(resending: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
