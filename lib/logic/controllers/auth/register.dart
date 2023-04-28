import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/register.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/validators.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());

  void setCountyCode(String code) => emit(state.copyWith(countryCode: code));

  bool validatePhoneNumber(String number) {
    String? numberErr = phoneNumberValidator(number);
    if (numberErr != null) {
      emit(state.copyWith(phoneError: numberErr));
      return false;
    }
    emit(state.copyWith(phoneError: ''));

    return true;
  }

  // send request to send otp registeration to the api
  void register(String number) async {
    emit(state.copyWith(loading: true));

    ServerResponse response =
        await AuthAPI.checkRegistrationCode(state.countryCode + number);
    print(response.response.body);
    if (response.isSuccess) {
      emit(state.copyWith(error: '', done: true, loading: false));
    } else {
      emit(state.copyWith(error: response.code.code, loading: false));
      emit(state.copyWith(error: ''));
    }
  }

  void doneToFalse() => emit(state.copyWith(done: false));
}
