import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/ui/file_path.dart';
import 'package:intl/intl.dart';

class MainAuthPage extends StatefulWidget {
  const MainAuthPage({Key? key}) : super(key: key);

  @override
  _MainAuthPageState createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  static DateTime now = DateTime.now();
  String formattedTime = DateFormat.jm().format(now);
  String formattedDate = DateFormat('MMM d, yyyy | EEEEEE').format(now);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(mainBanner),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _topContent(),
                    _centerContent(),
                    _bottomContent()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 18,
        ),
        Row(
          children: <Widget>[
            Text(
              formattedTime,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          formattedDate,
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ],
    );
  }

  Widget _centerContent() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            width: 50,
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            'World Point',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            'Open An Account For Digital  E-Wallet Solutions.\nInstant Payouts.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          TextButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 0))),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.register);
            },
            child: const Text(
              'Create an Account',
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomContent() {
    return Column(
      children: <Widget>[
        ElevatedButton(
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.login);
          },
          child: const Text(
            'Sign in',
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.forgetPassword);
          },
          child: const Text(
            'Forget Password',
          ),
        ),
      ],
    );
  }
}
