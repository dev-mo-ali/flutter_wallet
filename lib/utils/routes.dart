import 'package:flutter/material.dart';
import 'package:sun_point/ui/screen/account/account.dart';
import 'package:sun_point/ui/screen/account/account_info.dart';
import 'package:sun_point/ui/screen/account/reset_tpin1.dart';
import 'package:sun_point/ui/screen/account/reset_tpin2.dart';
import 'package:sun_point/ui/screen/account/reset_password.dart';
import 'package:sun_point/ui/screen/account/reset_security_question.dart';
import 'package:sun_point/ui/screen/account/show_qr.dart';
import 'package:sun_point/ui/screen/auth/email_verify.dart';
import 'package:sun_point/ui/screen/auth/forget_password.dart';
import 'package:sun_point/ui/screen/auth/login.dart';
import 'package:sun_point/ui/screen/auth/otp.dart';
import 'package:sun_point/ui/screen/auth/register.dart';
import 'package:sun_point/ui/screen/auth/register2.dart';
import 'package:sun_point/ui/screen/auth/register_succ.dart';
import 'package:sun_point/ui/screen/auth/security_question.dart';
import 'package:sun_point/ui/screen/auth/setup_succ.dart';
import 'package:sun_point/ui/screen/auth/setup_tpin.dart';
import 'package:sun_point/ui/screen/auth/start_up.dart';
import 'package:sun_point/ui/screen/auth/update_email.dart';
import 'package:sun_point/ui/screen/auth/update_id_image.dart';
import 'package:sun_point/ui/screen/home.dart';
import 'package:sun_point/ui/screen/auth/main.dart';

class Routes {
  static const startUp = '/';
  static const mainAuth = '/mainAuth';
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const register2 = '/register2';
  static const otp = '/otp';
  static const account = '/account';
  static const resetPassword = '/resetPassword';
  static const resetTPIN1 = '/resetTPIN1';
  static const resetTPIN2 = '/resetTPIN2';
  static const setupTPIN = '/setupTPIN';
  static const emailVerify = '/emailVerify';
  static const updateEmail = '/updateEmail';
  static const registerSucc = '/registerSucc';
  static const setupQuestion = '/setupQuestion';
  static const resetQuestion = '/resetQuestion';
  static const setupSucc = '/setupSucc';
  static const accountInfo = '/accountInfo';
  static const showQR = '/showQR';
  static const updateIdImage = '/updateIdImage';
  static const forgetPassword = '/forgetPassword';

  static Route? generate(RouteSettings settings) {
    switch (settings.name) {
      case mainAuth:
        return MaterialPageRoute(builder: (_) => const MainAuthPage());
      case startUp:
        return MaterialPageRoute(builder: (_) => const StartUpPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case otp:
        var args = settings.arguments as OTPArgs;
        return MaterialPageRoute(builder: (_) => OTPPage(args: args));
      case register2:
        var args = settings.arguments as Register2Args;

        return MaterialPageRoute(
            builder: (_) => Register2Page(
                  args: args,
                ));
      case account:
        return MaterialPageRoute(builder: (_) => const AccountPage());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => ResetPasswordPage());
      case resetTPIN1:
        return MaterialPageRoute(builder: (_) => ResetTPIN1Page());
      case resetTPIN2:
        var args = settings.arguments as ResetTPIN2Args;
        return MaterialPageRoute(builder: (_) => ResetTPIN2Page(args: args));
      case setupTPIN:
        var args = settings.arguments as SetupTPINArgs;
        return MaterialPageRoute(builder: (_) => SetupTPINPage(args: args));
      case emailVerify:
        return MaterialPageRoute(builder: (_) => EmailVerifyPage());
      case updateEmail:
        return MaterialPageRoute(builder: (_) => UpdateEmailPage());
      case registerSucc:
        return MaterialPageRoute(builder: (_) => const RegisterSuccPage());
      case setupSucc:
        return MaterialPageRoute(builder: (_) => const SetupSuccPage());
      case setupQuestion:
        var args = settings.arguments as SecurityQueArgs;
        return MaterialPageRoute(builder: (_) => SecurityQuePage(args: args));
      case resetQuestion:
        return MaterialPageRoute(builder: (_) => ResetSecurityQuePage());
      case accountInfo:
        return MaterialPageRoute(builder: (_) => AccountInfoPage());
      case showQR:
        return MaterialPageRoute(builder: (_) => const ShowQRPage());
      case updateIdImage:
        var args = settings.arguments as UpdateIDImageArgs;
        return MaterialPageRoute(builder: (_) => UpdateIDImagePage(args: args));
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordPage());
    }
  }
}
