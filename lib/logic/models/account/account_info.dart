import 'package:sun_point/utils/auth.dart';

class AccountInfoState {
  User? user;
  bool avatarLoading;
  bool loading;
  String error;
  AccountInfoState({
    this.user,
    this.avatarLoading = false,
    this.loading = false,
    this.error = '',
  });

  AccountInfoState copyWith({
    User? user,
    bool? avatarLoading,
    bool? loading,
    String? error,
  }) {
    return AccountInfoState(
      user: user ?? this.user,
      avatarLoading: avatarLoading ?? this.avatarLoading,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
