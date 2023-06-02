import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/forget_password1.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';

class ForgetPassword1Cubit extends Cubit<ForgetPassword1State> {
  ForgetPassword1Cubit() : super(ForgetPassword1State());

  void submit(String otp) async {
    if (!state.loading) {
      emit(state.copyWith(loading: true));

      ServerResponse response = await AuthAPI.checkForgetPassOTP(otp);

      if (response.isSuccess) {
        emit(state.copyWith(done: true, loading: false, error: ''));
      } else {
        emit(state.copyWith(loading: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
