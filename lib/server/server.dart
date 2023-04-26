import 'package:dio/dio.dart' as dio;
import 'package:sun_point/server/response.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sun_point/utils/auth.dart';

enum _Env {
  production,
  staging,
  local;
}

class Server {
  static const _Env _env = _Env.production; // set the server env

  static Future<ServerResponse> send(Function method, String path,
      {Object? body,
      Map<String, String>? headers,
      bool jsonBody = true,
      bool useToken = true}) async {
    String url = '$baseUrl/api/$path';
// if the sended request require authentication
    if (useToken) {
      User user = await User.getUser();
      String token = user.apiToken ?? '';
      headers ??= {};
      headers['access-token'] = token;
    }
    if (method == http.get) {
      // build the query param from body mao
      String qp = '?';
      if (body is Map) {
        for (var e in body.entries) {
          qp = qp + '${e.key}=${e.value}&';
        }
      }
      return ServerResponse(await http.get(
        Uri.parse(url + qp),
        headers: headers,
      ));
    } else {
      if (jsonBody) {
        // convert to json
        headers ??= {};
        headers['Content-Type'] = 'application/json';
        body = jsonEncode(body);
      }
      return ServerResponse(
          await method(Uri.parse(url), body: body, headers: headers));
    }
  }

  static Future<ServerResponse> sendDio(String path,
      {Object? body,
      Map<String, String>? headers,
      bool jsonBody = true,
      bool useToken = true}) async {
    String url = '$baseUrl/api/$path';
// if the sended request require authentication

    if (useToken) {
      User user = await User.getUser();
      String token = user.apiToken ?? '';
      headers ??= {};
      headers['access-token'] = token;
    }

    if (jsonBody) {
      // convert to json
      headers ??= {};
      headers['Content-Type'] = 'application/json';
      body = jsonEncode(body);
    }
    dio.Dio dioO = dio.Dio();
    dio.Response response = await dioO.post(url,
        data: body, options: dio.Options(headers: headers));

    return ServerResponse.fromDio(response);
  }

//upload file
  static Future<ServerResponse> sendFile(String path,
      {required String fileName,
      required String filePath,
      Map<String, dynamic> body = const {},
      Map<String, String>? headers,
      bool useToken = true}) async {
    String url = '$baseUrl/api/$path';

    if (useToken) {
      User user = await User.getUser();
      String token = user.apiToken ?? '';
      headers ??= {};
      headers['access-token'] = token;
    }
    dio.Dio dioO = dio.Dio();
    dio.Response response = await dioO.post(url,
        data: dio.FormData.fromMap(
          {
            fileName: (await dio.MultipartFile.fromFile(filePath)),
          }..addAll(body),
        ),
        options: dio.Options(headers: headers));

    return ServerResponse.fromDio(response);
  }

  static String getAbsluteUrl(String path) => '$baseUrl/$path';
// get base url depending on server env
  static String get baseUrl {
    switch (Server._env) {
      case _Env.production:
        return 'https://api-v1.wisepremium.com';

      case _Env.staging:
        return 'https://staging-api.wisepremium.com';

      case _Env.local:
        return 'http://10.0.2.2:8000';
    }
  }
}
