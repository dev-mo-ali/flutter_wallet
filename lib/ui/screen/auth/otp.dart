import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sun_point/logic/controllers/auth/otp.dart';
import 'package:sun_point/logic/models/auth/otp.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/ui/screen/auth/register2.dart';
import 'package:sun_point/ui/widgets/bottom_bar.dart';
import 'package:sun_point/ui/widgets/country_dialog.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';

class OTPArgs {
  String phone;
  String type;
  Map? registeredUser;
  OTPArgs({
    required this.phone,
    required this.type,
    this.registeredUser,
  });
}

class OTPPage extends StatelessWidget {
  List otpFields = [];
  OTPArgs args;
  OTPPage({
    Key? key,
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
      create: (context) => OTPCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register").tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<OTPCubit, OTPState>(
              listenWhen: (previous, current) => current.error.isNotEmpty,
              listener: (context, state) {
                showDialog(
                    context: context,
                    builder: (_) => ErrorDialog(error: state.error));
              },
            ),
            BlocListener<OTPCubit, OTPState>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) {
                if (args.type == AuthAPI.OTP_TYPE_CODE_REGISTER) {
                  Navigator.of(context).pushReplacementNamed(Routes.register2,
                      arguments: Register2Args(
                          registeredUser: args.registeredUser!,
                          otp: otpFields
                              .map((e) => e['controller'].text)
                              .toList()
                              .join()));
                }
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
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(
                            color: Theme.of(context).iconTheme.color!,
                            width: 2)),
                    child: SvgPicture.asset(
                      'assets/svg/otp.svg',
                      width: 70,
                      color: Theme.of(context).iconTheme.color,
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Text('OTP VERIFICATION',
                        style: Theme.of(context).textTheme.displayMedium)
                    .tr(),
              ),
              Center(
                child: Text(
                  'otpSum',
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
                                      context.read<OTPCubit>().checkOTP(
                                          args.phone, code, args.type);
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
                child: BlocSelector<OTPCubit, OTPState, int>(
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
              BlocBuilder<OTPCubit, OTPState>(
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
                          context.read<OTPCubit>().resend(args.type, args.phone,
                              context.locale, args.registeredUser);
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
              BlocSelector<OTPCubit, OTPState, bool>(
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
