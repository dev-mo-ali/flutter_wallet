import 'package:easy_localization/easy_localization.dart';

String? isNotEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return 'fieldReq'.tr();
  }
  return null;
}

String? phoneNumberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'numReq'.tr();
  }
  RegExp regExp = RegExp(r'^\d{8,}$');
  if (!regExp.hasMatch(value)) {
    return 'invalidNum'.tr();
  }
  return null;
}

String? amountValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'fieldReq'.tr();
  }
  RegExp regEx = RegExp(r'^\d+(\.\d{1,2})?$');
  if (!regEx.hasMatch(value)) {
    return 'amountError'.tr();
  }
  return null;
}
