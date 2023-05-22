import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/profile/update_phone2.dart';
import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/validators.dart';

class UpdatePhone2Cubit extends Cubit<UpdatePhone2State> {
  UpdatePhone2Cubit() : super(UpdatePhone2State());

  bool validatePhoneNumber(String number) {
    String? numberErr = phoneNumberValidator(number);
    if (numberErr != null) {
      emit(state.copyWith(phoneError: numberErr));
      return false;
    }
    emit(state.copyWith(phoneError: ''));

    return true;
  }

  void secCode(String code) => emit(state.copyWith(countryCode: code));

  void submit(String phone, String password, String local) async {
    if (!state.loading) {
      emit(state.copyWith(loading: true));
      // send http request
      ServerResponse response = await AccountAPI.sendResetNumberOTP(
          state.countryCode + phone, password, local);
      if (response.isSuccess) {
        emit(state.copyWith(loading: false, done: true, error: ''));
      } else {
        emit(state.copyWith(loading: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
