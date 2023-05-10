import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sun_point/ui/screen/auth/main.dart';
import 'package:sun_point/utils/notifications.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/ui/constant.dart';
import 'package:sun_point/utils/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // TODO: Enable notifications
  // NotificationHelper.setup();
  // NotificationHelper.listenOnToken();
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('zh')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translation',
      child: Builder(builder: (context) {
        return MaterialApp(
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
          title: 'Flutter Wallet App',
          onGenerateRoute: Routes.generate,
          initialRoute: Routes.startUp,
          debugShowCheckedModeBanner: false,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: ThemeMode.dark,
          // home: const MainAuthPage(),
        );
      }),
    );
  }
}
