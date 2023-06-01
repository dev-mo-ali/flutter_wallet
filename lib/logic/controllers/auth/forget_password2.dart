import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/forget_password2.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/validators.dart';

class ForgetPassword2Cubit extends Cubit<ForgetPassword2State> {
  ForgetPassword2Cubit() : super(ForgetPassword2State());
  void setCode(String code) => emit(state.copyWith(countryCode: code));

  bool validatePhoneNumber(String number) {
    String? numberErr = phoneNumberValidator(number);
    if (numberErr != null) {
      emit(state.copyWith(error: numberErr));
      emit(state.copyWith(error: ''));
      return false;
    }

    return true;
  }

  void submit(String number, String password, String otp) async {
    if (!state.loading && validatePhoneNumber(number)) {
      emit(state.copyWith(loading: true));

      ServerResponse response = await AuthAPI.setForgottenPassword(
          state.countryCode + number, password, otp);

      if (response.isSuccess) {
        emit(state.copyWith(done: true, loading: false, error: ''));
      } else {
        emit(state.copyWith(loading: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
