import 'package:http/http.dart' as http;
import 'package:sun_point/server/server.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/auth.dart';

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

  static Future<ServerResponse> updateProfile(String name) async {
    User user = await User.getUser();
    ServerResponse response =
        await Server.send(http.post, 'user/update_profile', body: {
      'name': name,
      'email': user.email,
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
}