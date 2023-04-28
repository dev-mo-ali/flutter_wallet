import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(currentIndex: 0, items: [
      BottomNavigationBarItem(
        icon: const Icon(
          Icons.home,
        ),
        label: "Home".tr(),
      ),
      BottomNavigationBarItem(
        icon: const Icon(
          FontAwesomeIcons.wallet,
          size: 20,
        ),
        label: "Account".tr(),
      ),
      BottomNavigationBarItem(
        icon: const Icon(
          Icons.person,
        ),
        label: "Profile".tr(),
      ),
    ]);
  }
}
