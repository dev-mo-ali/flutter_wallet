import 'package:sun_point/server/response.dart';
import 'package:sun_point/server/server.dart';
import 'package:http/http.dart' as http;

class AuthAPI {
  static const OTP_TYPE_CODE_REGISTER = "REGISTER";
  static const OTP_TYPE_CODE_FORGOT_PASSWORD = "FORGOT_PASSWORD";

  static Future<ServerResponse> checkRegistrationCode(String number) async {
    ServerResponse response = await Server.send(
        http.post, 'user/check_registration_code',
        body: {"username": number}, useToken: false);
    return response;
  }

  static Future<ServerResponse> checkOTP(
      String number, String otp, String type) async {
    ServerResponse response = await Server.send(http.post, 'user/check_otp',
        body: {"username": number, "otp": otp, "otp_type_code": type},
        useToken: false);
    return response;
  }

  static Future<ServerResponse> submitRegisterRequest(
    String name,
    String password,
    String number,
    String otp,
    String confPassword,
    String email,
  ) async {
    ServerResponse response = await Server.send(http.post, 'user/register_user',
        body: {
          "otp": otp,
          "username": number,
          "name": name,
          "password": password,
          "email": email,
          "password_confirmation": confPassword,
          "device_type": "APP",
        },
        useToken: false);
    return response;
  }

  static Future<ServerResponse> login(
    String number,
    String password,
  ) async {
    ServerResponse response = await Server.send(http.post, 'user/user_login',
        body: {
          "username": number,
          "password": password,
          "device_type": "APP",
        },
        useToken: false);
    return response;
  }

  static Future<ServerResponse> autoLogin(
    String token,
  ) async {
    ServerResponse response = await Server.send(http.post, 'user/auto_login',
        body: {'api_token': token}, useToken: false);
    return response;
  }

  static Future<ServerResponse> getSecurityQuestions() async {
    ServerResponse response =
        await Server.send(http.post, 'user/get_security_questions');
    return response;
  }

  static Future<ServerResponse> firstSetup(
      Map question, String answer, String tpin) async {
    ServerResponse response =
        await Server.send(http.post, 'user/set_first_setup', body: {
      "question": question,
      "question_id": question['id'],
      'answer': answer,
      'tpin': tpin
    });
    return response;
  }

  static Future<ServerResponse> sendForgetOtp(
      String number, String local) async {
    ServerResponse response =
        await Server.send(http.post, 'user/check_username',
            body: {
              'username': number,
              'locale': local,
            },
            useToken: false);
    return response;
  }

  static Future<ServerResponse> setForgottenPassword(
      String number, String password, String confPassword, String otp) async {
    ServerResponse response =
        await Server.send(http.post, 'user/forgot_password',
            body: {
              'username': number,
              'password': password,
              'password_confirmation': confPassword,
              'otp': otp
            },
            useToken: false);
    return response;
  }

  static Future<ServerResponse> emailVerify(
    String email,
    String code,
  ) async {
    ServerResponse response = await Server.send(
        http.post, 'user/verify_user_email',
        body: {'email': email, 'code': code});
    return response;
  }

  static Future<ServerResponse> resendEmailVerify(
    String email,
  ) async {
    ServerResponse response = await Server.send(
        http.post, 'user/resend_email_verification_code',
        body: {
          'email': email,
        });
    return response;
  }

  static Future<ServerResponse> updateEmail(
    String email,
  ) async {
    ServerResponse response =
        await Server.send(http.post, 'user/update_email', body: {
      'email': email,
    });
    return response;
  }
}
