import 'package:http/http.dart' as http;
import 'package:sun_point/server/response.dart';
import 'package:sun_point/server/server.dart';

class GeneralAPI {
  static Future<ServerResponse> getPromotions() async {
    ServerResponse response =
        await Server.send(http.post, 'user/get_promotions');
    return response;
  }

  static Future<ServerResponse> getNotifications([int page = 0]) async {
    ServerResponse response = await Server.sendDio('user/get_notifications',
        body: {'page_number': page});
    return response;
  }

  static Future<ServerResponse> versionControl(String version) async {
    ServerResponse response = await Server.sendDio('user/version_control',
        body: {'version': version}, useToken: false);
    return response;
  }
}
