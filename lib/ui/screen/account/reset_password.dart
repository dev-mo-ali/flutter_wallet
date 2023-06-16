import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/account/reset_password.dart';
import 'package:sun_point/logic/models/account/reset_password.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
// import 'package:sun_point/logic/controllers/reset_password.dart';
// import 'package:sun_point/logic/models/reset_password.dart';
// import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});
  final TextEditingController password = TextEditingController(),
      newPassword = TextEditingController(),
      confPassword = TextEditingController();

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'fieldReq'.tr();
    }

    if (value.length < 8) {
      return 'passErr'.tr();
    }
    return null;
  }

  String? passConfValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'fieldReq'.tr();
    }

    if (value != newPassword.text) {
      return 'passErr2'.tr();
    }
    if (value.length < 8) {
      return 'passErr'.tr();
    }
    return null;
  }

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account Security').tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ResetPasswordCubit, ResetPasswordState>(
              listenWhen: (previous, current) => current.error.isNotEmpty,
              listener: (context, state) {
                showDialog(
                    context: context,
                    builder: (_) => ErrorDialog(error: state.error));
              },
            ),
          ],
          child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
            buildWhen: (previous, current) => previous.done != current.done,
            builder: (context, state) {
              if (state.done) {
                return Padding(
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
                                  color: Theme.of(context).iconTheme.color!,
                                  width: 2)),
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
                                style:
                                    Theme.of(context).textTheme.displayMedium)
                            .tr(),
                      ),
                      Center(
                        child: Text(
                          'resetPassSucc',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge,
                        ).tr(),
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.home);
                          },
                          child: const Text('Ok').tr())
                    ],
                  ),
                );
              }
              return Form(
                  key: _key,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      const Text(
                        'Change Sign In Password',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ).tr(),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Enter sign in password',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontSize: 16),
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
                        height: 64,
                      ),
                      Text(
                        'Enter your new password',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontSize: 16),
                      ).tr(),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        validator: passwordValidator,
                        controller: newPassword,
                        obscureText: true,
                        decoration: InputDecoration(hintText: "Password".tr()),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        validator: passConfValidator,
                        controller: confPassword,
                        obscureText: true,
                        decoration:
                            InputDecoration(hintText: "Confirm Password".tr()),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      BlocSelector<ResetPasswordCubit, ResetPasswordState,
                          bool>(
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
                                context.read<ResetPasswordCubit>().submit(
                                    password.text,
                                    newPassword.text,
                                    confPassword.text);
                              }
                            },
                            child: const Text('Confirm').tr());
                      }),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(Routes.forgetPassword);
                          },
                          child: const Text('Forget Password?').tr(),
                        ),
                      )
                    ],
                  ));
            },
          ),
        ),
      ),
    );
  }
}
