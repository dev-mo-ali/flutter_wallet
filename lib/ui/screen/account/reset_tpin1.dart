import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/account/reset_tpin1.dart';
import 'package:sun_point/logic/models/account/reset_tpin1.dart';
import 'package:sun_point/ui/screen/account/reset_tpin2.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
// import 'package:sun_point/logic/controllers/reset_password.dart';
// import 'package:sun_point/logic/models/reset_password.dart';
// import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class ResetTPIN1Page extends StatelessWidget {
  ResetTPIN1Page({super.key});
  final TextEditingController password = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetTPIN21Cubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account Security').tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ResetTPIN21Cubit, ResetTPIN1State>(
              listenWhen: (previous, current) => current.error.isNotEmpty,
              listener: (context, state) {
                showDialog(
                    context: context,
                    builder: (_) => ErrorDialog(error: state.error));
              },
            ),
            BlocListener<ResetTPIN21Cubit, ResetTPIN1State>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) {
                Navigator.of(context).pushReplacementNamed(Routes.resetTPIN2,
                    arguments: ResetTPIN2Args(password: password.text));
              },
              child: Container(),
            )
          ],
          child: Form(
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
                const SizedBox(
                  height: 8,
                ),
                BlocSelector<ResetTPIN21Cubit, ResetTPIN1State, bool>(
                  selector: (state) {
                    return state.loading;
                  },
                  builder: (context, state) {
                    return Center(
                      child: SizedBox.square(
                        dimension: 32,
                        child: Visibility(
                          visible: state,
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Builder(builder: (context) {
                  return ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          context
                              .read<ResetTPIN21Cubit>()
                              .checkPassword(password.text);
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
        ),
      ),
    );
  }
}
