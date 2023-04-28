import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/start_up.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/logic/providers/utilis.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

class StartUpCubit extends Cubit<StartUpState> {
  late String token;
  Map? user;
  StartUpCubit() : super(StartUpState()) {
    checkUpdate().then((value) => null);
  }

  // send auto login request to the api

  void login() async {
    ServerResponse response = await AuthAPI.autoLogin(token);
    if (response.isSuccess) {
      // set user data
      user = response.data;
      await User.setUser(user!);

      emit(state.copyWith(
          loading: false,
          done: true,
          goSetup: user!['setup'] != 1,
          goEmailVerify: user!['email_verified_at'] == null,
          goUpdate: false));
    } else {
      emit(state.copyWith(loading: false));
      if (response.code == ErrorCodes.AUTH_REQUIRED) {
        emit(state.copyWith(wrongCred: true));
      }
    }
  }

// get if user loged in or not
  void getLoginState() async {
    try {
      User user = await User.getUser();
      token = user.apiToken!; //set the token to use it in the class
      emit(state.copyWith(login: true));
      login();
    } on UserNotSetException catch (e) {
      emit(state.copyWith(login: false));
    }
  }

// check on update by sending build  number
  Future<void> checkUpdate() async {
    emit(state.copyWith(loading: true));
    String version = (await PackageInfo.fromPlatform()).buildNumber;
    ServerResponse response = await GeneralAPI.versionControl(version);

    print(response.code.code);
    if (response.isSuccess) {
      // no update
      emit(state.copyWith(goUpdate: false));
      getLoginState();
    } else {
      // update required
      if (response.code.code == 'VERSION_OUTDATED') {
        emit(state.copyWith(loading: false, goUpdate: true));
      } else {
        // request failed
        emit(state.copyWith(
          loading: false,
        ));
      }
    }
  }
}
