import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up').tr(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                child: const Icon(
                  Icons.wallet,
                  size: 70,
                )),
          ),
          Center(
            child: Text(
              'TOP UP',
              style: Theme.of(context).textTheme.displayMedium,
            ).tr(),
          ),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: Column(
              children: [
                Text('topUpSum',
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
        ],
      ),
    );
  }
}
