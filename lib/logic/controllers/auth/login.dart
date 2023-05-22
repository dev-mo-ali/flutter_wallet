import 'package:bloc/bloc.dart';
import 'package:flutter_udid/flutter_udid.dart';

import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/logic/models/auth/login.dart';
import 'package:sun_point/utils/validators.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  void setCode(String code) => emit(state.copyWith(countryCode: code));

  bool validatePhoneNumber(String number) {
    String? numberErr = phoneNumberValidator(number);
    if (numberErr != null) {
      emit(state.copyWith(phoneError: numberErr));
      return false;
    }
    emit(state.copyWith(phoneError: ''));

    return true;
  }

  // send login request to the api
  void login(String number, String password) async {
    if (!state.loading && validatePhoneNumber(number)) {
      // send the request
      emit(state.copyWith(loading: true));
      String imei = await FlutterUdid.udid;
      // await Future.delayed(Duration(seconds: 2));
      // emit(state.copyWith(loading: false, error: '', uploadIDimage: true));

      ServerResponse response =
          await AuthAPI.login(state.countryCode + number, password, imei);
      if (response.isSuccess) {
        // set user data
        await User.setUser(response.data as Map);
        // TODO:
        // final token = (await FirebaseMessaging.instance.getToken());
        // if (token != null) {
        //   await AccountAPI.updateFCMToken(token);
        // }
        emit(state.copyWith(
          loading: false,
          done: true,
          error: '',
          goSetup: response.data['setup'] != 1,
          goEmailVerify: response.data['email_verified_at'] == null,
        ));
      } else {
        if (response.code.code == 'REGISTRATION_IDENTIFICATION_REQUIRED') {
          emit(state.copyWith(loading: false, error: '', uploadIDimage: true));
        } else {
          emit(state.copyWith(loading: false, error: response.code.code));
          emit(state.copyWith(error: ''));
        }
      }
    }
  }
}
