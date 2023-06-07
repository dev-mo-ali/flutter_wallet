import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SoonDialog extends StatelessWidget {
  const SoonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 250,
        child: Center(
          child: Text(
            "Coming Soon",
            style: Theme.of(context).textTheme.displayMedium,
          ).tr(),
        ),
      ),
    );
  }
}
