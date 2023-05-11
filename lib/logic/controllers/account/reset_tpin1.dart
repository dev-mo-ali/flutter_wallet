import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/account/reset_tpin1.dart';
import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/server/response.dart';

class ResetTPIN21Cubit extends Cubit<ResetTPIN1State> {
  ResetTPIN21Cubit() : super(ResetTPIN1State());

  // check if the password correct using the api
  void checkPassword(String password) async {
    emit(state.copyWith(loading: true));
    ServerResponse response = await AccountAPI.checkPassword(password);
    if (response.isSuccess) {
      emit(state.copyWith(
          loading: false, done: true, error: '', password: password));
    } else {
      emit(state.copyWith(loading: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }
}
