import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sun_point/logic/models/account/account_info.dart';
import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/auth.dart';

class AccountInfoCubit extends Cubit<AccountInfoState> {
  AccountInfoCubit() : super(AccountInfoState()) {
    getUser().then((value) => null);
  }

// get user and emit it
  Future<void> getUser() async {
    User user = await User.getUser();
    emit(state.copyWith(user: user));
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

  void submit(String name) async {
    emit(state.copyWith(loading: true));
    ServerResponse response = await AccountAPI.updateProfile(name);
    if (response.isSuccess) {
      // save new user data
      await User.setUser(response.data);
      emit(state.copyWith(loading: false, error: ''));
    } else {
      emit(state.copyWith(loading: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }
}
