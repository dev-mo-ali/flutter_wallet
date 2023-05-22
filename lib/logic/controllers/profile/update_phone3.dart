import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:sun_point/logic/models/profile/update_phone3.dart';
import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/server/response.dart';

class UpdatePhone3Cubit extends Cubit<UpdatePhone3State> {
  UpdatePhone3Cubit() : super(UpdatePhone3State()) {
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
  void resend(String phone, String password, Locale local) async {
    emit(state.copyWith(resending: true));
    ServerResponse response = await AccountAPI.sendResetNumberOTP(
        phone, password, local.languageCode == 'en' ? 'en' : 'cn');

    if (response.isSuccess) {
      emit(state.copyWith(
          resending: false,
          secondsReaming: UpdatePhone3State.timeOfResend,
          error: ''));
      // start timer to resend again
      countToResend().then((value) => null);
    } else {
      emit(state.copyWith(resending: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }

// check if otp code is valid
  void submit(String otp) async {
    if (!state.loading) {
      emit(state.copyWith(loading: true));
      ServerResponse response = await AccountAPI.resetNumber(otp);
      if (response.isSuccess) {
        emit(state.copyWith(loading: false, done: true, error: ''));
      } else {
        emit(state.copyWith(loading: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
