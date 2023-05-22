import 'dart:convert' show jsonDecode, utf8;


class ServerResponse {
  late final ResponseCode code;
  late final bool isSuccess;
  late final int status;
  late final String message;
  dynamic data;
  final response;

  ServerResponse(this.response) {
    // print(response.body);
    Map data = jsonDecode(utf8.decode(response.bodyBytes));
    isSuccess = data['isSuccess'];
    status = data['status'];
    message = data['message'];
    code = status == 200 ? ResponseCode(data['code']) : codeFromMsg(message);
    this.data = data['data'];
  }
  ServerResponse.fromDio(this.response) {
    Map data = response.data;
    isSuccess = data['isSuccess'];
    status = data['status'];
    message = data['message'];
    code = status == 200 ? ResponseCode(data['code']) : codeFromMsg(message);
    this.data = data['data'];
  }

  ResponseCode codeFromMsg(String msg) {
    switch (msg) {
      case 'Server Error. Please Contact Administrator':
        return ErrorCodes.SERVER_ERROR;
      case 'Wrong Credentials':
        return ErrorCodes.WRONG_CREDENTIALS;
      case 'Please Login':
        return ErrorCodes.AUTH_REQUIRED;
      case 'The username has already been taken.':
        return ErrorCodes.USERNAME_EXISTS;
    }

    return const ResponseCode('');
  }
}

class ResponseCode {
  final String code;
  const ResponseCode(this.code);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResponseCode && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}

class ErrorCodes {
  static const ResponseCode USERNAME_EXISTS = ResponseCode("USERNAME_EXISTS");
  static const ResponseCode INVALID_OTP = ResponseCode("INVALID_OTP");
  static const ResponseCode REGISTRATION_EXISTS =
      ResponseCode("REGISTRATION_EXISTS");
  static const ResponseCode SERVER_ERROR = ResponseCode("SERVER_ERROR");
  static const ResponseCode WRONG_CREDENTIALS =
      ResponseCode('WRONG_CREDENTIALS');
  static const ResponseCode AUTH_REQUIRED = ResponseCode('AUTH_REQUIRED');
  static const ResponseCode INVALID_USER = ResponseCode('INVALID_USER');
  static const ResponseCode INVALID_QR = ResponseCode('INVALID_QR');
  static const ResponseCode INVALID_CREDENTIAL =
      ResponseCode('INVALID_CREDENTIAL');
  static const ResponseCode DUPLICATED_RECEIVER =
      ResponseCode('DUPLICATED_RECEIVER');
  static const ResponseCode INVALID_RECEIVER = ResponseCode('INVALID_RECEIVER');
  static const ResponseCode WALLET_LIMIT = ResponseCode('WALLET_LIMIT');
  static const ResponseCode INSUFFICIENT_BALANCE =
      ResponseCode('INSUFFICIENT_BALANCE');
  static const ResponseCode ATTEMPTED_TRANSACTION_PIN =
      ResponseCode('ATTEMPTED_TRANSACTION_PIN');
  static const ResponseCode INVALID_TRANSACTION_PIN =
      ResponseCode('INVALID_TRANSACTION_PIN');
  static const ResponseCode TRANSFER_TO_SELF = ResponseCode('TRANSFER_TO_SELF');
  static const ResponseCode INVALID_VOUCHER_CODE =
      ResponseCode('INVALID_VOUCHER_CODE');
  static const ResponseCode TRANSACTION_ERROR =
      ResponseCode('TRANSACTION_ERROR');
}
