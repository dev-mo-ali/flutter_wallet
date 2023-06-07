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
    load().then((value) => null);
  }

// get user and emit it
  Future<void> load() async {
    emit(state.copyWith(loading: true));

    ServerResponse response = await AccountAPI.getProfile();
    if (response.isSuccess) {
      Map data = {};
      data['user'] = response.data['user'][0];
      data['emergency_contacts'] = response.data['emergency_contacts'][0];
      emit(state.copyWith(
          loading: false,
          data: data,
          birth: DateTime.parse(data['user']['birthday']),
          idType: data['user']['identification_type']));
    } else {
      emit(state.copyWith(loading: false));
    }
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
          ));
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
  // void setCode(String code) => emit(state.copyWith(countryCode: code));

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
    if (!state.submitting && validatePhoneNumber(emergencyPhone)) {
      emit(state.copyWith(submitting: true));
      DateFormat format = DateFormat('yyyy-MM-dd', 'en');

      ServerResponse response = await AccountAPI.updateProfile(
          name,
          state.idType!,
          idNumber,
          format.format(state.birth!),
          emergencyName,
          emergencyPhone,
          emergencyRelationship);
      if (response.isSuccess) {
        // save new user data
        await User.setUser(response.data['user']);
        emit(state.copyWith(submitting: false, done: true, error: ''));
      } else {
        emit(state.copyWith(submitting: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
