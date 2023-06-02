import 'package:http/http.dart' as http;
import 'package:sun_point/server/server.dart';
import 'package:sun_point/server/response.dart';

class AccountAPI {
  static Future<ServerResponse> resetPassword(
      String password, String newPassword, String confPassword) async {
    ServerResponse response =
        await Server.send(http.post, 'user/reset_password', body: {
      'current_password': password,
      'password': newPassword,
      'password_confirmation': confPassword,
    });
    return response;
  }

  static Future<ServerResponse> updateProfile(
    String name,
    String identificationType,
    String identificationNumber,
    String birthday,
    String emergencyName,
    String emergencyPhone,
    String emergencyRelationship,
  ) async {
    ServerResponse response =
        await Server.send(http.post, 'user/update_profile', body: {
      'name': name,
      'identification_type': identificationType,
      'identification_number': identificationNumber,
      "birthday": birthday,
      "emergency_contact_full_name": emergencyName,
      "emergency_contact_phone_number": emergencyPhone,
      "emergency_contact_relationship": emergencyRelationship,
    });
    return response;
  }

  static Future<ServerResponse> updateFCMToken(String token) async {
    ServerResponse response = await Server.send(
        http.post, 'user/update_fcm_token',
        body: {'token': token});
    return response;
  }

  static Future<ServerResponse> checkPassword(
    String password,
  ) async {
    ServerResponse response =
        await Server.send(http.post, 'user/check_password', body: {
      'password': password,
    });
    return response;
  }

  static Future<ServerResponse> resetTPIN(
    String password,
    String tpin,
  ) async {
    ServerResponse response =
        await Server.send(http.post, 'user/reset_tpin', body: {
      'password': password,
      'tpin': tpin,
    });
    return response;
  }

  static Future<ServerResponse> updateAvatar(String img) async {
    ServerResponse response = await Server.sendFile('user/update_avatar',
        fileName: 'image', filePath: img);
    return response;
  }

  static Future<ServerResponse> changeSecurityQuestion(
      int questionId, String answer) async {
    ServerResponse response =
        await Server.send(http.post, 'user/change_security_question', body: {
      "question_id": questionId,
      'answer': answer,
    });
    return response;
  }

  static Future<ServerResponse> unlockPhone() async {
    ServerResponse response =
        await Server.send(http.post, 'user/change_phone_device_request');
    return response;
  }

  static Future<ServerResponse> sendResetNumberOTP(
      String phone, String password, String locale) async {
    ServerResponse response = await Server.send(
        http.post, 'user/reset_mobile_number_otp_request',
        body: {"new_username": phone, 'password': password, "locale": locale});
    return response;
  }

  static Future<ServerResponse> resetNumber(String otp) async {
    ServerResponse response =
        await Server.send(http.post, 'user/reset_mobile_number', body: {
      "otp": otp,
    });
    return response;
  }
}
