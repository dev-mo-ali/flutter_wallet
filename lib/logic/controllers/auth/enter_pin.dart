import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/enter_pin.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';

class EnterPINCubit extends Cubit<EnterPINState> {
  EnterPINCubit() : super(EnterPINState());

  void check(String code) async {
    if (!state.loading) {
      emit(state.copyWith(loading: true));

      ServerResponse response = await AuthAPI.checkPIN(code);
      if (response.isSuccess) {
        emit(state.copyWith(done: true, loading: false, error: ''));
      } else {
        emit(state.copyWith(loading: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
