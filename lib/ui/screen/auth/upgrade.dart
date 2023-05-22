import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradePage extends StatelessWidget {
  const UpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 42,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(
                        color: Theme.of(context).iconTheme.color!, width: 2)),
                child: SvgPicture.asset(
                  'assets/svg/upgrade.svg',
                  height: 70,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            Center(
              child: Text(
                'NEW UPDATE',
                style: Theme.of(context).textTheme.displayMedium,
              ).tr(),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                'upgradeSum',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ).tr(),
            ),
            const SizedBox(
              height: 64,
            ),
            ElevatedButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    //TODO: add the app link
                    launchUrl(Uri.parse('https://play.google.com/'),
                        mode: LaunchMode.externalNonBrowserApplication);
                  }
                },
                child: const Text('Upgrade').tr()),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
