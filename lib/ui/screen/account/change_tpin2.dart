import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sun_point/logic/controllers/reset_password.dart';
// import 'package:sun_point/logic/models/reset_password.dart';
// import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class ChangeTPIN2Page extends StatelessWidget {
  List tpinFields = [];
  ChangeTPIN2Page({super.key}) {
    tpinFields = List.generate(
        6,
        (index) => {
              'controller': TextEditingController(),
              'node': FocusNode(),
              'filled': false
            });
  }
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
              'Enter your new transaction pin',
            ).tr(),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: tpinFields.map((e) {
                  int index = tpinFields.indexOf(e);
                  return SizedBox(
                      width: 45,
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        onKeyEvent: (value) {
                          if (index > 0 &&
                              value.physicalKey ==
                                  PhysicalKeyboardKey.backspace &&
                              !e['filled']) {
                            tpinFields[index - 1]['node'].requestFocus();
                          }
                        },
                        child: TextField(
                          controller: e['controller'],
                          focusNode: e['node'],
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(counterText: ''),
                          onChanged: (v) {
                            if (v.length == 1) {
                              e['filled'] = true;
                              if (index < tpinFields.length - 1) {
                                tpinFields[index + 1]['node'].requestFocus();
                              } else {
                                e['node'].unfocus();
                              }
                            } else {
                              e['filled'] = false;
                            }
                          },
                        ),
                      ));
                }).toList(),
              ),
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
//
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
