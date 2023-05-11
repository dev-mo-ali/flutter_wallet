import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sun_point/utils/routes.dart';

class SetupSuccPage extends StatelessWidget {
  const SetupSuccPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register").tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 42,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(
                        color: Theme.of(context).iconTheme.color!, width: 2)),
                child: const Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 70,
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Center(
              child: Text('SUCCESS!',
                      style: Theme.of(context).textTheme.displayMedium)
                  .tr(),
            ),
            Center(
              child: Text(
                'SetupSuccPage',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ).tr(),
            ),
            const SizedBox(
              height: 64,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Routes.home);
                },
                child: const Text('Ok').tr())
          ],
        ),
      ),
    );
  }
}
