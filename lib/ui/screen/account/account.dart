import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sun_point/ui/screen/drawer_page.dart';
import 'package:sun_point/ui/widgets/bottom_bar.dart';
import 'package:sun_point/ui/widgets/side_bar_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sun_point/ui/widgets/yes_no_dialog.dart';
import 'package:sun_point/utils/routes.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerPage(
      current: Routes.account,
      child: SizedBox(
        child: Column(
          children: [
            const SideBarHeader(),
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Account Security',
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 16),
                        ).tr(),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(Routes.resetPassword),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.lock_outline,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Reset Password',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ).tr()
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(Routes.resetTPIN1),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.password_outlined),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'changeTpin',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ).tr()
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(Routes.resetQuestion),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(FontAwesomeIcons.key),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Change Security Question',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ).tr()
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        InkWell(
                          onTap: () async {
                            bool? res = await showDialog(
                                context: context,
                                builder: (_) => const YesNoDialog(
                                    title: 'Unlock Phone', text: 'askUnlock'));
                            if (res == true) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  Routes.unlockPhone, (route) => false);
                            }
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_android),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Unlock Phone',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ).tr()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomBar: const BottomBar(currentIndex: 1),
    );
  }
}
