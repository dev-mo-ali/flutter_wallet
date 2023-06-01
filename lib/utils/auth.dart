import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_point/server/server.dart';

class UserNotSetException implements Exception {}

class User {
  final int id;
  final String username;
  String? _avatar;
  final String? email;
  final String? name;
  final String? apiToken;
  final String? qr;
  final String? countryCode;
  final String? phoneNumber;
  final String? idType;
  final int? _isDeleted;
  final int? _setup;
  final String? email_verified_at;
  final DateTime? birthday;

  User(
      this.id,
      this.username,
      String? avatar,
      this.email,
      this.name,
      this.apiToken,
      this.qr,
      this.countryCode,
      this.phoneNumber,
      this._isDeleted,
      this._setup,
      this.email_verified_at,
      this.birthday,
      this.idType) {
    _avatar = avatar;
  }

  static Future<User> getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? usrJ = sp.getString('user');
    if (usrJ == null) {
      throw UserNotSetException();
    } else {
      return User.fromJson(usrJ);
    }
  }

  static Future<void> setUser(Map usrJ) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('user', jsonEncode(usrJ));
  }

  static Future<void> logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('user');
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'username': username});
    if (_avatar != null) {
      result.addAll({'avatar': _avatar});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (apiToken != null) {
      result.addAll({'api_token': apiToken});
    }
    if (qr != null) {
      result.addAll({'qr': qr});
    }
    if (countryCode != null) {
      result.addAll({'country_code': countryCode});
    }
    if (phoneNumber != null) {
      result.addAll({'phone_number': phoneNumber});
    }
    if (_isDeleted != null) {
      result.addAll({'is_deleted': _isDeleted});
    }
    if (_setup != null) {
      result.addAll({'setup': _setup});
    }
    if (email_verified_at != null) {
      result.addAll({'email_verified_at': email_verified_at});
    }

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        map['id']?.toInt() ?? 0,
        map['username'] ?? '',
        map['avatar'],
        map['email'],
        map['name'],
        map['api_token'],
        map['qr'],
        map['country_code'],
        map['phone_number'],
        map['is_deleted']?.toInt(),
        map['setup']?.toInt(),
        map['email_verified_at'],
        DateTime.parse(map['birthday']),
        map['identification_type']);
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  bool get setup => _setup == 1;
  bool get isDeleted => _isDeleted == 1;
  bool get isEmailVerified => email_verified_at != null;

  String? get avatar => _avatar != null ? Server.getAbsluteUrl(_avatar!) : null;
}
