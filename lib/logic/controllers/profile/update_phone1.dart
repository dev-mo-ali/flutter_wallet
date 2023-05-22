import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/profile/update_phone1.dart';
import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/server/response.dart';

class UpdatePhone1Cubit extends Cubit<UpdatePhone1State> {
  UpdatePhone1Cubit() : super(UpdatePhone1State());

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
