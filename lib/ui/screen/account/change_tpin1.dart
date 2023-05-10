import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sun_point/logic/controllers/reset_password.dart';
// import 'package:sun_point/logic/models/reset_password.dart';
// import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class ChangeTPIN1Page extends StatelessWidget {
  ChangeTPIN1Page({super.key});
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Security').tr(),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(
              height: 32,
            ),
            const Text(
              'Enter sign in password',
            ).tr(),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              validator: isNotEmpty,
              controller: password,
              obscureText: true,
              decoration: InputDecoration(hintText: "Password".tr()),
            ),
            SizedBox(
              height: 64,
            ),
            const SizedBox(
              height: 8,
            ),
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.changeTPIN2);
                    }
                  },
                  child: const Text('Next').tr());
            }),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
