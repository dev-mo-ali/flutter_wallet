import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/account/reset_tpin2.dart';

import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/server/response.dart';

class ResetTPIN2Cubit extends Cubit<ResetTPIN2State> {
  ResetTPIN2Cubit() : super(ResetTPIN2State());
  void setError(String error) {
    emit(state.copyWith(error: error));
    emit(state.copyWith(error: ''));
  }

  // send reset tpin request to the api
  void submit(String password, String tpin) async {
    emit(state.copyWith(loading: true));
    ServerResponse response = await AccountAPI.resetTPIN(password, tpin);
    if (response.isSuccess) {
      emit(state.copyWith(loading: false, done: true, error: ''));
    } else {
      emit(state.copyWith(loading: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }
}
