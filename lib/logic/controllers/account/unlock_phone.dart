import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/account/unlock_phone.dart';
import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/auth.dart';

class UnlockPhoneCubit extends Cubit<UnlockPhoneState> {
  UnlockPhoneCubit() : super(UnlockPhoneState()) {
    load().then((value) => null);
  }
  Future<void> load() async {
    emit(state.copyWith(loading: true));
    ServerResponse response = await AccountAPI.unlockPhone();
    if (response.isSuccess) {
      await User.logout();
      emit(state.copyWith(loading: false, done: true));
    } else {
      emit(state.copyWith(loading: false));
    }
  }
}
