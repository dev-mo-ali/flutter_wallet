import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/utils/ui/file_path.dart';

class SideBarHeader extends StatelessWidget {
  const SideBarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset(
                logo,
                width: 34,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                'Sun Point',
                style: Theme.of(context).textTheme.displaySmall,
              )
            ],
          ),
          SvgPicture.asset(
            menu,
            width: 16,
            color: Theme.of(context).iconTheme.color,
          ),
        ],
      ),
    );
  }
}
