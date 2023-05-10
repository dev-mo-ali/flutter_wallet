import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/update_email.dart';

import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';

class UpdateEmailCubit extends Cubit<UpdateEmailState> {
  UpdateEmailCubit() : super(UpdateEmailState());

  void update(String email) async {
    if (!state.loading) {
      emit(state.copyWith(loading: true));
      // send http request
      ServerResponse response = await AuthAPI.updateEmail(email);
      print(response.response.body);
      if (response.isSuccess) {
        emit(state.copyWith(loading: false, done: true, error: ''));
      } else {
        emit(state.copyWith(loading: false, error: response.code.code));
      }
    }
  }
}
