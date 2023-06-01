import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/auth/forget_password2.dart';
import 'package:sun_point/logic/models/auth/forget_password2.dart';
import 'package:sun_point/ui/widgets/country_dialog.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';

class ForgetPassword2Args {
  String otp;
  ForgetPassword2Args({
    required this.otp,
  });
}

// ignore: must_be_immutable
class ForgetPassword2Page extends StatelessWidget {
  ForgetPassword2Args args;
  ForgetPassword2Page({
    Key? key,
    required this.args,
  }) : super(key: key);

  final TextEditingController phone = TextEditingController(),
      password = TextEditingController(),
      passConf = TextEditingController();

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

    if (value != password.text) {
      return 'passErr2'.tr();
    }
    if (value.length < 8) {
      return 'passErr'.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPassword2Cubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forget Password').tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ForgetPassword2Cubit, ForgetPassword2State>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(Routes.mainAuth, (route) => false);
              },
              child: Container(),
            ),
            BlocListener<ForgetPassword2Cubit, ForgetPassword2State>(
              listenWhen: (previous, current) => current.error.isNotEmpty,
              listener: (context, state) {
                showDialog(
                    context: context,
                    builder: (_) => ErrorDialog(
                          error: state.error,
                        ));
              },
            ),
          ],
          child: ListView(
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
                            color: Theme.of(context).iconTheme.color!,
                            width: 2)),
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
                child: Text('forgetPass2Summ',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge)
                    .tr(),
              ),
              const SizedBox(
                height: 32,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: (Theme.of(context)
                          .inputDecorationTheme
                          .enabledBorder as OutlineInputBorder)
                      .borderRadius,
                  border: Border.all(
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .enabledBorder!
                          .borderSide
                          .color),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone),
                    BlocSelector<ForgetPassword2Cubit, ForgetPassword2State,
                        String>(
                      selector: (state) {
                        return state.countryCode;
                      },
                      builder: (context, state) {
                        return InkWell(
                          onTap: () async {
                            String? code = await showDialog(
                                context: context,
                                builder: (_) => const CountryDialog());
                            if (code != null) {
                              context
                                  .read<ForgetPassword2Cubit>()
                                  .setCode(code);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '+$state',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: phone,
                        decoration: InputDecoration(
                          hintText: "Phone Number".tr(),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                validator: passwordValidator,
                controller: password,
                decoration: InputDecoration(
                  labelText: "Password".tr(),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                validator: passConfValidator,
                controller: passConf,
                decoration: InputDecoration(
                  labelText: "Password Confirmation".tr(),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              BlocSelector<ForgetPassword2Cubit, ForgetPassword2State, bool>(
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
                    context
                        .read<ForgetPassword2Cubit>()
                        .submit(phone.text, password.text, args.otp);
                  },
                  child: const Text('Next').tr(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
