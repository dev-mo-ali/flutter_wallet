import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/auth/forget_password1.dart';
import 'package:sun_point/logic/models/auth/forget_password1.dart';
import 'package:sun_point/ui/screen/auth/forget_password2.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';

// ignore: must_be_immutable
class ForgetPassword1Page extends StatelessWidget {
  List otpFields = [];
  ForgetPassword1Page({super.key}) {
    otpFields = List.generate(
        4,
        (index) => {
              'controller': TextEditingController(),
              'node': FocusNode(),
              'filled': false
            });
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPassword1Cubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forget Password').tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ForgetPassword1Cubit, ForgetPassword1State>(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Builder(builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: otpFields.map((e) {
                      int index = otpFields.indexOf(e);
                      return SizedBox(
                          width: 45,
                          child: KeyboardListener(
                            focusNode: FocusNode(),
                            onKeyEvent: (value) {
                              if (index > 0 &&
                                  value.physicalKey ==
                                      PhysicalKeyboardKey.backspace &&
                                  !e['filled']) {
                                otpFields[index - 1]['node'].requestFocus();
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
                              decoration:
                                  const InputDecoration(counterText: ''),
                              onChanged: (v) {
                                if (v.length == 1) {
                                  e['filled'] = true;
                                  if (index < otpFields.length - 1) {
                                    otpFields[index + 1]['node'].requestFocus();
                                  } else {
                                    e['node'].unfocus();
                                    String code = otpFields
                                        .map((e) => e['controller'].text)
                                        .toList()
                                        .join();
                                    if (code.length == 4) {
                                      context
                                          .read<ForgetPassword1Cubit>()
                                          .submit(code);
                                    }
                                  }
                                } else {
                                  e['filled'] = false;
                                }
                              },
                            ),
                          ));
                    }).toList(),
                  );
                }),
              ),
              const SizedBox(
                height: 8,
              ),
              BlocSelector<ForgetPassword1Cubit, ForgetPassword1State, bool>(
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
                    Navigator.of(context).pushNamed(Routes.forgetPassword2,
                        arguments: ForgetPassword2Args(otp: '1111'));
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
