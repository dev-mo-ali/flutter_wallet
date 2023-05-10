import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sun_point/utils/routes.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  const BottomBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  final List<Map> _items = const [
    {'label': "Home", 'icon': Icons.home, 'route': Routes.home},
    {'label': "Account", 'icon': FontAwesomeIcons.wallet, 'route': ''},
    {'label': "Profile", 'icon': Icons.person, 'route': Routes.account},
    // {'label': "", 'icon': null, 'route':''},
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        if (index != currentIndex) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              _items[index]['route'], (route) => false);
        }
      },
      currentIndex: currentIndex,
      items: _items
          .map(
            (e) => BottomNavigationBarItem(
              icon: Icon(
                e['icon'],
              ),
              label: e['label'].toString().tr(),
            ),
          )
          .toList(),
    );
  }
}
