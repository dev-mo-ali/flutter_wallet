import 'package:sun_point/server/response.dart';
import 'package:sun_point/server/server.dart';
import 'package:http/http.dart' as http;

class AuthAPI {
  static const OTP_TYPE_CODE_REGISTER = "REGISTER";
  static const OTP_TYPE_CODE_FORGOT_PASSWORD = "FORGOT_PASSWORD";

  static Future<ServerResponse> checkRegistrationCode(
      String number, String agent, String userID, String locale) async {
    ServerResponse response =
        await Server.send(http.post, 'user/check_registration_code',
            body: {
              "username": number,
              'reference_number': userID,
              'referral_code': agent,
              'locale': locale
            },
            useToken: false);
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
    String email,
    String agentCode,
    String userID,
    String identificationType,
    String identificationNumber,
    String identificationImage,
    String birthday,
    String emergencyName,
    String emergencyPhone,
    String emergencyRelationship,
    String deviceType,
    String deviceModel,
    String imei,
  ) async {
    ServerResponse response = await Server.sendFile('user/register_user',
        fileName: 'identification_image',
        filePath: identificationImage,
        body: {
          "otp": otp,
          "username": number,
          "name": name,
          "password": password,
          "email": email,
          "password_confirmation": password,
          "referral_code": agentCode,
          "reference_number": userID,
          'identification_type': identificationType,
          'identification_number': identificationNumber,
          "birthday": birthday,
          "emergency_contact_full_name": emergencyName,
          "emergency_contact_phone_number": emergencyPhone,
          "emergency_contact_relationship": emergencyRelationship,
          "device_type": deviceType,
          "device_model": deviceModel,
          "imei": imei,
        },
        useToken: false);
    return response;
  }

  static Future<ServerResponse> login(
    String number,
    String password,
    String imei,
  ) async {
    ServerResponse response = await Server.send(http.post, 'user/user_login',
        body: {
          "username": number,
          "password": password,
          "imei": imei,
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

  static Future<ServerResponse> updateIdImage(
      String username, String idImg, String idNumber, String idType) async {
    ServerResponse response =
        await Server.sendFile('user/update_identification_image',
            fileName: 'identification_image',
            filePath: idImg,
            body: {
              'identification_type': idType,
              'identification_number': idNumber,
              'username': username
            },
            useToken: false);
    return response;
  }
}
