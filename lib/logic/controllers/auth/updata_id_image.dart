import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sun_point/logic/models/auth/update_id_image.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';

class UpdateIDImageCubit extends Cubit<UpdateIDImageState> {
  UpdateIDImageCubit() : super(UpdateIDImageState());

  void selectIdType(String idType) => emit(state.copyWith(idType: idType));

  bool validateIcImg() {
    if (state.idImg == null) {
      emit(state.copyWith(error: 'plzSelImg'));
      emit(state.copyWith(error: ''));

      return false;
    }

    return true;
  }

  void selectICImg() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null && result.count > 0) {
      if (result.files.first.size < 5120000) {
        emit(state.copyWith(idImg: result.files.first.path, error: ''));
      } else {
        emit(state.copyWith(error: "Selected image is too large"));
      }
    }
  }

  void submit(String username, String idNumber) async {
    if (validateIcImg() && !state.loading) {
      emit(state.copyWith(
        loading: true,
      ));

      ServerResponse response = await AuthAPI.updateIdImage(
          username, state.idImg!, idNumber, state.idType);
      if (response.isSuccess) {
        emit(state.copyWith(error: '', done: true, loading: false));
      } else {
        emit(state.copyWith(error: response.code.code, loading: false));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
