import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  final String title;
  final String text;
  const YesNoDialog({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        padding: const EdgeInsets.all(16),
        height: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ).tr(),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.labelLarge,
              ).tr(),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes').tr()),
                const SizedBox(
                  width: 16,
                ),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No').tr())
              ],
            )
          ],
        ),
      ),
    );
  }
}
