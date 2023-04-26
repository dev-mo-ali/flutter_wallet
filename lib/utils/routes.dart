import 'package:flutter/material.dart';
import 'package:sun_point/ui/screen/home_page.dart';
import 'package:sun_point/ui/screen/sign_in.dart';

class Routes {
  static const mainAuth = '/';
  static const home = '/home';

  static Route? generate(RouteSettings settings) {
    switch (settings.name) {
      case mainAuth:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
