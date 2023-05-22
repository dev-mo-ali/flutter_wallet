import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/start_up.dart';
import 'package:sun_point/logic/providers/utilis.dart';
import 'package:sun_point/server/response.dart';
import 'package:package_info_plus/package_info_plus.dart';

class StartUpCubit extends Cubit<StartUpState> {
  late String token;
  Map? user;
  StartUpCubit() : super(StartUpState()) {
    checkUpdate().then((value) => null);
  }

  // send auto login request to the api

// check on update by sending build  number
  Future<void> checkUpdate() async {
    emit(state.copyWith(loading: true));
    String version = (await PackageInfo.fromPlatform()).buildNumber;
    ServerResponse response = await GeneralAPI.versionControl(version);

    if (response.isSuccess) {
      // no update
      emit(state.copyWith(goUpdate: false, done: true));
    } else {
      // update required
      if (response.code.code == 'VERSION_OUTDATED') {
        emit(state.copyWith(loading: false, goUpdate: true, done: true));
      } else {
        // request failed
        emit(state.copyWith(
          loading: false,
        ));
      }
    }
  }
}
