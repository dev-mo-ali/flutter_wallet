import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/server/server.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/logic/models/auth/login.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  void setCode(String code) => emit(state.copyWith(countryCode: code));

  // send login request to the api
  void login(String number, String password) async {
    // check if number field is not empty
    if (number.isEmpty) {
      emit(state.copyWith(phoneError: 'fieldReq'));
      return;
    }
    emit(state.copyWith(phoneError: ''));

    // send the request
    emit(state.copyWith(loading: true));
    ServerResponse response =
        await AuthAPI.login(state.countryCode + number, password);
    if (response.isSuccess) {
      // set user data
      await User.setUser(response.data as Map);
      final token = (await FirebaseMessaging.instance.getToken());
      if (token != null) {
        await AccountAPI.updateFCMToken(token);
      }
      emit(state.copyWith(
        loading: false,
        done: true,
        error: '',
        goSetup: response.data['setup'] != 1,
        goEmailVerify: response.data['email_verified_at'] == null,
      ));
    } else {
      emit(state.copyWith(loading: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }
}
