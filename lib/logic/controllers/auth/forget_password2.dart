import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/forget_password2.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';

class ForgetPassword2Cubit extends Cubit<ForgetPassword2State> {
  ForgetPassword2Cubit() : super(ForgetPassword2State());

  void togglePassVisibility() =>
      emit(state.copyWith(showPass: !state.showPass));
  void toggleConfPassVisibility() =>
      emit(state.copyWith(showConfPass: !state.showConfPass));

  // send set password request to the api
  void submit(
      String number, String password, String confPassword, String otp) async {
    emit(state.copyWith(loading: true));
    ServerResponse response =
        await AuthAPI.setForgottenPassword(number, password, confPassword, otp);
    if (response.isSuccess) {
      emit(state.copyWith(loading: false, done: true, error: ''));
    } else {
      emit(state.copyWith(loading: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }
}
