import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/forget_password.dart';

import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordState());

  void setCountryCode(String code) => emit(state.copyWith(countryCode: code));
// check if the username(mobile number) exists and send the otp code
  void checkUsername(String number, String local) async {
// check if number field is not empty
    if (number.isEmpty) {
      emit(state.copyWith(phoneError: 'fieldReq'));
      return;
    }
    emit(state.copyWith(phoneError: ''));

    // send the request
    emit(state.copyWith(loading: true));
    ServerResponse response =
        await AuthAPI.sendForgetOtp(state.countryCode + number, local);

    if (response.isSuccess) {
      emit(state.copyWith(loading: false, done: true, error: ''));

      // if done false again because user can back to this page
      emit(state.copyWith(done: false));
    } else {
      emit(state.copyWith(loading: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }
}
