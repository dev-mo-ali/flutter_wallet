import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:sun_point/logic/models/auth/otp.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';

class OTPCubit extends Cubit<OTPState> {
  OTPCubit() : super(OTPState()) {
    countToResend().then((value) => null);
  }

  // timer to resend the sms otp
  Future<void> countToResend() async {
    while (state.secondsReaming > 0) {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(secondsReaming: state.secondsReaming - 1));
    }
    emit(state.copyWith());
  }

// resend the sms
  void resend(String type, String number, Locale local, Map? extra) async {
    emit(state.copyWith(resending: true));
    // resend code depending on the type
    ServerResponse response = await AuthAPI.checkRegistrationCode(
        number,
        extra!['agent'],
        extra['userID'],
        local.languageCode == 'en' ? 'en' : 'cn');

    if (response.isSuccess) {
      emit(state.copyWith(
          resending: false, secondsReaming: OTPState.timeOfResend, error: ''));
      // start timer to resend again
      countToResend().then((value) => null);
    } else {
      emit(state.copyWith(resending: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }

// check if otp code is valid
  void checkOTP(String number, String otp, String type) async {
    emit(state.copyWith(loading: true));
    ServerResponse response = await AuthAPI.checkOTP(number, otp, type);
    if (response.isSuccess) {
      emit(state.copyWith(loading: false, done: true, error: ''));
    } else {
      emit(state.copyWith(loading: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }
}
