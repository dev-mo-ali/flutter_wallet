import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:sun_point/logic/models/auth/register2.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/validators.dart';

class Register2Cubit extends Cubit<Register2State> {
  Register2Cubit() : super(Register2State());
  void setCountyCode(String code) => emit(state.copyWith(countryCode: code));

  void setIDType(String idType) => emit(state.copyWith(idType: idType));

  void selectICImg() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null && result.count > 0) {
      if (result.files.first.size < 5120000) {
        emit(state.copyWith(icImg: result.files.first.path, icImgError: ''));
      } else {
        emit(state.copyWith(icImgError: "Selected image is too large"));
      }
    }
  }

  bool validatePhoneNumber(String number) {
    String? numberErr = phoneNumberValidator(number);
    if (numberErr != null) {
      emit(state.copyWith(phoneError: numberErr));
      return false;
    }
    emit(state.copyWith(phoneError: ''));

    return true;
  }

  bool validateBirthday() {
    if (state.birth == null) {
      emit(state.copyWith(birthError: 'fieldReq'));
      return false;
    }
    emit(state.copyWith(birthError: ''));

    return true;
  }

  bool validateIcImg() {
    if (state.icImg == null) {
      emit(state.copyWith(icImgError: 'fieldReq'));
      return false;
    }
    emit(state.copyWith(icImgError: ''));

    return true;
  }

  void setBirth(DateTime birth) {
    emit(state.copyWith(birth: birth));
    emit(state.copyWith(birthError: ''));
  }

  void submitRequest({
    required String name,
    required String password,
    required String number,
    required String otp,
    required String email,
    required String agentCode,
    required String userID,
    required String identificationNumber,
    required String emergencyName,
    required String emergencyPhone,
    required String emergencyRelationship,
  }) async {
    if (validateBirthday() &&
        validateIcImg() &&
        validatePhoneNumber(emergencyPhone) &&
        !state.loading) {
      emit(state.copyWith(loading: true));

      String imei = await FlutterUdid.udid;

      DateFormat format = DateFormat('yyyy-MM-dd', 'en');
      String deviceModel = await _getModel();
      String deviceType = Platform.isAndroid ? 'android' : 'ios';

      ServerResponse response = await AuthAPI.submitRegisterRequest(
          name,
          password,
          number,
          otp,
          email,
          agentCode,
          userID,
          state.idType,
          identificationNumber,
          state.icImg!,
          format.format(state.birth!),
          emergencyName,
          emergencyPhone,
          emergencyRelationship,
          deviceType,
          deviceModel,
          imei);

      if (response.isSuccess) {
        emit(state.copyWith(error: '', done: true, loading: false));
        emit(state.copyWith(done: false));
      } else {
        emit(state.copyWith(error: response.code.code, loading: false));
        emit(state.copyWith(error: ''));
      }
    }
  }

  Future<String> _getModel() async {
    DeviceInfoPlugin info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return (await info.androidInfo).model;
    } else {
      return (await info.iosInfo).model;
    }
  }
}
