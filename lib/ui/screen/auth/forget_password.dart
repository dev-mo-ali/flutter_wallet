import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/auth/update_email.dart';
import 'package:sun_point/logic/models/auth/update_email.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class ForgetPasswordPage extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password').tr(),
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
                  Icons.password_outlined,
                  size: 70,
                )),
          ),
          Center(
            child: Text(
              'FORGET PASSWORD',
              style: Theme.of(context).textTheme.displayMedium,
            ).tr(),
          ),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: Column(
              children: [
                Text('forgetPassSum',
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
          const SizedBox(
            height: 32,
          ),
          const SizedBox(
            height: 8,
          ),
          Builder(builder: (context) {
            return ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back').tr(),
            );
          }),
        ],
      ),
    );
  }
}
