import 'package:flutter/material.dart';
import 'package:sun_point/ui/screen/auth/login.dart';
import 'package:sun_point/ui/screen/auth/register.dart';
import 'package:sun_point/ui/screen/auth/start_up.dart';
import 'package:sun_point/ui/screen/home.dart';
import 'package:sun_point/ui/screen/auth/main.dart';

class Routes {
  static const startUp = '/';
  static const mainAuth = '/';
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';

  static Route? generate(RouteSettings settings) {
    switch (settings.name) {
      case mainAuth:
        return MaterialPageRoute(builder: (_) => const MainAuthPage());
      case startUp:
        return MaterialPageRoute(builder: (_) => const StartUpPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
    }
  }
}
