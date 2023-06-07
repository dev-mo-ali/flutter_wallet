import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ContactUsDialog extends StatelessWidget {
  const ContactUsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            Text('plzContact',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge)
                .tr(),
            Text('Tel:',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge)
                .tr(args: ['+92 123 123 123']),
            Text('Email:',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge)
                .tr(args: ['world@point.com']),
          ],
        ),
      ),
    );
  }
}
