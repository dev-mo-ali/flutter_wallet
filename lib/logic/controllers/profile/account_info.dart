import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:sun_point/logic/models/account/account_info.dart';
import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/validators.dart';

class AccountInfoCubit extends Cubit<AccountInfoState> {
  AccountInfoCubit() : super(AccountInfoState()) {
    getUser().then((value) => null);
  }

// get user and emit it
  Future<void> getUser() async {
    User user = await User.getUser();
    emit(state.copyWith(user: user, birth: user.birthday, idType: user.idType));
  }

  void pickImage() async {
// select the image'
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null && result.count > 0) {
      // if file less then 1 mb
      if (result.files.first.size < 1024000) {
        emit(state.copyWith(avatarLoading: true));
        ServerResponse response =
            await AccountAPI.updateAvatar(result.files.first.path!);
        if (response.isSuccess) {
          await User.setUser(response.data);

          emit(state.copyWith(
              avatarLoading: false,
              error: '',
              user: User.fromMap(response.data)));
        } else {
          emit(state.copyWith(avatarLoading: false, error: response.code.code));
          emit(state.copyWith(error: ''));
        }
      } else {
        // show user file to big error
        emit(state.copyWith(error: 'avatarSizeErr'));
        emit(state.copyWith(error: ''));
      }
    }
  }

  void setBirth(DateTime birth) => emit(state.copyWith(birth: birth));
  void setIdType(String type) => emit(state.copyWith(idType: type));
  void setCode(String code) => emit(state.copyWith(countryCode: code));

  bool validatePhoneNumber(String number) {
    String? numberErr = phoneNumberValidator(number);
    if (numberErr != null) {
      emit(state.copyWith(error: numberErr));
      emit(state.copyWith(error: ''));
      return false;
    }

    return true;
  }

  void submit(
    String name,
    String idNumber,
    String emergencyName,
    String emergencyPhone,
    String emergencyRelationship,
  ) async {
    if (!state.loading && validatePhoneNumber(emergencyPhone)) {
      emit(state.copyWith(loading: true));
      DateFormat format = DateFormat('yyyy-MM-dd', 'en');

      ServerResponse response = await AccountAPI.updateProfile(
          name,
          state.idType!,
          idNumber,
          format.format(state.birth!),
          emergencyName,
          state.countryCode + emergencyPhone,
          emergencyRelationship);
      if (response.isSuccess) {
        // save new user data
        await User.setUser(response.data['user']);
        emit(state.copyWith(loading: false, done: true, error: ''));
      } else {
        emit(state.copyWith(loading: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
