import 'package:http/http.dart' as http;
import 'package:sun_point/server/response.dart';
import 'package:sun_point/server/server.dart';

class ContactsAPI {
  static Future<ServerResponse> addContacts(String name, String number) async {
    ServerResponse response =
        await Server.send(http.post, 'user/add_contact', body: {
      'nickname': name,
      "mobile_number": number,
    });
    return response;
  }

  static Future<ServerResponse> getContacts() async {
    ServerResponse response = await Server.send(
      http.post,
      'user/get_contacts',
    );
    return response;
  }

  static Future<ServerResponse> deleteContact(int id) async {
    ServerResponse response =
        await Server.send(http.post, 'user/delete_contact', body: {'id': id});
    return response;
  }

  static Future<ServerResponse> editContact(int id, String name) async {
    ServerResponse response =
        await Server.send(http.post, 'user/edit_contact', body: {
      'id': id,
      "nickname": name,
    });
    return response;
  }

  static Future<ServerResponse> getUserByQr(String qr) async {
    ServerResponse response =
        await Server.send(http.post, 'user/check_contact_qr', body: {
      'qr': qr,
    });
    return response;
  }

  static Future<ServerResponse> getUserByNumber(String number) async {
    ServerResponse response =
        await Server.send(http.post, 'user/check_user', body: {
      'mobile_number': number,
    });
    return response;
  }
}
