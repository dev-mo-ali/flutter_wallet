import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    required this.error,
  }) : super(key: key);
  final String error;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 32,
            ),
            SizedBox.square(
              dimension: 100,
              child: Image.asset('assets/error.png'),
            ),
            const SizedBox(
              height: 8,
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              'ERROR',
              style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ).tr(),
            const SizedBox(
              height: 64,
            ),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ).tr(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK').tr()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}