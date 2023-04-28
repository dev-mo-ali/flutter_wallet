import 'package:sun_point/server/response.dart';
import 'package:sun_point/server/server.dart';
import 'package:http/http.dart' as http;

class MCAPI {
  static Future<ServerResponse> checkRequest() async {
    ServerResponse response = await Server.send(
        http.post, 'user/master_card/check_master_card_request');
    return response;
  }

  static Future<ServerResponse> createRequest() async {
    ServerResponse response = await Server.send(
        http.post, 'user/master_card/create_request_master_card');
    return response;
  }

  static Future<ServerResponse> checkUser() async {
    ServerResponse response =
        await Server.send(http.post, 'user/master_card/check_master_card_user');
    return response;
  }

  static Future<ServerResponse> getUserMasterCardBalance() async {
    ServerResponse response = await Server.send(
        http.post, 'user/master_card/get_user_master_card_balance');
    return response;
  }

  static Future<ServerResponse> topUp(double amount) async {
    ServerResponse response = await Server.send(
        http.post, 'user/master_card/topup_master_card',
        body: {'amount': amount});
    return response;
  }
}
