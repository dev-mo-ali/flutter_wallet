import 'package:sun_point/utils/auth.dart';

class AccountInfoState {
  User? user;
  bool avatarLoading;
  bool loading;
  String error;
  DateTime? birth;
  String? idType;
  String countryCode;
  AccountInfoState({
    this.user,
    this.avatarLoading = false,
    this.loading = false,
    this.error = '',
    this.birth,
    this.idType,
    this.countryCode = '60',
  });

  AccountInfoState copyWith({
    User? user,
    bool? avatarLoading,
    bool? loading,
    String? error,
    DateTime? birth,
    String? idType,
    String? countryCode,
  }) {
    return AccountInfoState(
      user: user ?? this.user,
      avatarLoading: avatarLoading ?? this.avatarLoading,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      birth: birth ?? this.birth,
      idType: idType ?? this.idType,
      countryCode: countryCode ?? this.countryCode,
    );
  }
}
