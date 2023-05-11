import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/account/reset_password.dart';
import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/server/response.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordState());

  // send reset password request to the api
  void submit(String password, String newPassword, String confPassword) async {
    emit(state.copyWith(loading: true));
    ServerResponse response =
        await AccountAPI.resetPassword(password, newPassword, confPassword);
    if (response.isSuccess) {
      emit(state.copyWith(loading: false, done: true, error: ''));
    } else {
      emit(state.copyWith(loading: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }
}
