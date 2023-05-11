import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sun_point/server/server.dart';
import 'package:sun_point/ui/screen/drawer_page.dart';
import 'package:sun_point/ui/widgets/bottom_bar.dart';
import 'package:sun_point/ui/widgets/lang_dialog.dart';
import 'package:sun_point/ui/widgets/side_bar_header.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerPage(
      child: SizedBox(
        child: Column(
          children: [
            const SideBarHeader(),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 100,
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.accountInfo),
                      child: Stack(
                        children: [
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: Image.asset(
                          //     'assets/account/background.png',
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 24,
                                ),
                                FutureBuilder<User>(
                                  future: User.getUser(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }
                                    return Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(),
                                            child: Image(
                                              image: snapshot.data!.avatar ==
                                                      null
                                                  ? const AssetImage(
                                                          'assets/profile.png')
                                                      as ImageProvider
                                                  : NetworkImage(
                                                      Server.getAbsluteUrl(
                                                        snapshot.data!.avatar!,
                                                      ),
                                                      headers: {
                                                          'Connection':
                                                              'Keep-Alive'
                                                        }),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'hiUser',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ).tr(args: [snapshot.data!.name!]),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(snapshot.data!.username,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(fontSize: 14)),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const Expanded(
                                    child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(end: 16),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Account Security',
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 16),
                          ).tr(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(Routes.resetPassword),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lock_outline,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Reset Password',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ).tr()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(Routes.resetTPIN1),
                          child: Container(
                            padding: const EdgeInsets.all(8),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ).tr()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(Routes.resetQuestion),
                          child: Container(
                            padding: const EdgeInsets.all(8),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ).tr()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => showDialog(
                              context: context,
                              builder: (_) => const SetLangDialog()),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(border: Border()),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(10000),
                                      child: Image.asset(
                                        'assets/${context.locale.languageCode.toLowerCase()}.png',
                                        fit: BoxFit.cover,
                                        width: 28,
                                        height: 28,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Change Language',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ).tr()
                                  ],
                                ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Account and Help',
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 16),
                          ).tr(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () async {
                            Uri url =
                                Uri.parse('https://worldpoint2u.com/about/#');
                            launchUrl(url, mode: LaunchMode.inAppWebView);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.phone),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Contact Us',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ).tr()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Uri url =
                                Uri.parse('https://worldpoint2u.com/about/');
                            launchUrl(url, mode: LaunchMode.inAppWebView);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'About Us',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ).tr()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomBar: const BottomBar(currentIndex: 2),
    );
  }
}
