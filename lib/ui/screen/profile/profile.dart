import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sun_point/ui/screen/drawer_page.dart';
import 'package:sun_point/ui/widgets/bottom_bar.dart';
import 'package:sun_point/ui/widgets/lang_dialog.dart';
import 'package:sun_point/ui/widgets/side_bar_header.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerPage(
      current: Routes.profile,
      child: SizedBox(
        child: Column(
          children: [
            const SideBarHeader(),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 80,
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.accountInfo),
                      child: Center(
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
                                      borderRadius: BorderRadius.circular(1000),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: const BoxDecoration(),
                                        child: snapshot.data!.avatar == null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color!),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000),
                                                ),
                                                child: const Icon(
                                                  Icons.person_outlined,
                                                  size: 45,
                                                ),
                                              )
                                            : Image.network(
                                                snapshot.data!.avatar!,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }

                                                  if (loadingProgress
                                                          .cumulativeBytesLoaded >=
                                                      (loadingProgress
                                                              .expectedTotalBytes ??
                                                          0)) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                  return child;
                                                },
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
                                padding: EdgeInsetsDirectional.only(end: 16),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Information',
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
                              .pushNamed(Routes.updatePhone1),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_outlined),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Change Phone Number',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'General',
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
                          onTap: () => showDialog(
                              context: context,
                              builder: (_) => const SetLangDialog()),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10000),
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
                  Column(
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ).tr()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      InkWell(
                        onTap: () async {
                          Uri url =
                              Uri.parse('https://worldpoint2u.com/about/');
                          launchUrl(url, mode: LaunchMode.inAppWebView);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'About Us',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ).tr()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
