import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sun_point/logic/controllers/profile/update_phone3.dart';
import 'package:sun_point/logic/models/profile/update_phone3.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';

class UpdatePhone3Args {
  String phone;
  String password;
  UpdatePhone3Args({
    required this.phone,
    required this.password,
  });
}

// ignore: must_be_immutable
class UpdatePhone3Page extends StatelessWidget {
  List otpFields = [];
  UpdatePhone3Args args;
  UpdatePhone3Page({
    super.key,
    required this.args,
  }) {
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
      create: (context) => UpdatePhone3Cubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change Phone Number").tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<UpdatePhone3Cubit, UpdatePhone3State>(
              listenWhen: (previous, current) => current.error.isNotEmpty,
              listener: (context, state) {
                for (var e in otpFields) {
                  e['controller'].clear();
                }
                showDialog(
                    context: context,
                    builder: (_) => ErrorDialog(error: state.error));
              },
            ),
            BlocListener<UpdatePhone3Cubit, UpdatePhone3State>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(Routes.home, (route) => false);
              },
              child: Container(),
            )
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
                      Icons.phone_outlined,
                      size: 70,
                    )),
              ),
              Center(
                child: Text('CHANGE PHONE NUMBER',
                        style: Theme.of(context).textTheme.displayMedium)
                    .tr(),
              ),
              Center(
                child: Text(
                  'updatePhone3Sum',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ).tr(),
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
                                  (value.physicalKey ==
                                          PhysicalKeyboardKey.backspace ||
                                      value.physicalKey ==
                                          const PhysicalKeyboardKey(
                                              0x1100000043)) &&
                                  !e['filled']) {
                                otpFields[index - 1]['node'].requestFocus();
                              }
                            },
                            child: TextField(
                              controller: e['controller'],
                              focusNode: e['node']
                                ..addListener(() {
                                  e['controller'].selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: e['controller'].text.length));
                                }),
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
                                          .read<UpdatePhone3Cubit>()
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
              Center(
                child: BlocSelector<UpdatePhone3Cubit, UpdatePhone3State, int>(
                  selector: (state) {
                    return state.secondsReaming;
                  },
                  builder: (context, state) {
                    if (state == 0) {
                      return const SizedBox();
                    }
                    int min = state ~/ 60;
                    int secs = state % 60;
                    String time = '$min:${secs > 9 ? secs : '0$secs'}';
                    return Text(
                      time,
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  },
                ),
              ),
              BlocBuilder<UpdatePhone3Cubit, UpdatePhone3State>(
                buildWhen: (previous, current) =>
                    previous.resending != current.resending ||
                    previous.secondsReaming != current.secondsReaming,
                builder: (context, state) {
                  return Visibility(
                    visible: state.secondsReaming == 0,
                    child: Visibility(
                      visible: !state.resending,
                      replacement: const SizedBox.square(
                          dimension: 32,
                          child: Center(child: CircularProgressIndicator())),
                      child: TextButton(
                        child: const Text('Resend').tr(),
                        onPressed: () {
                          context.read<UpdatePhone3Cubit>().resend(
                              args.phone, args.password, context.locale);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'yourNumOTP',
                textAlign: TextAlign.center,
              ).tr(args: [args.phone]),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'changeNumOTP',
                textAlign: TextAlign.center,
              ).tr(args: [args.phone]),
              const SizedBox(
                height: 12,
              ),
              BlocSelector<UpdatePhone3Cubit, UpdatePhone3State, bool>(
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Back").tr())
            ],
          ),
        ),
      ),
    );
  }
}
