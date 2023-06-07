import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/logic/controllers/auth/enter_pin.dart';
import 'package:sun_point/logic/models/auth/enter_pin.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';

// ignore: must_be_immutable
class EnterPINPage extends StatelessWidget {
  List pinFields = [];
  EnterPINPage({
    super.key,
  }) {
    pinFields = List.generate(
        6,
        (index) => {
              'controller': TextEditingController(),
              'node': FocusNode(),
              'filled': false
            });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EnterPINCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Enter PIN").tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<EnterPINCubit, EnterPINState>(
              listenWhen: (previous, current) => current.error.isNotEmpty,
              listener: (context, state) {
                showDialog(
                    context: context,
                    builder: (_) => ErrorDialog(error: state.error));
              },
            ),
            BlocListener<EnterPINCubit, EnterPINState>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) {
                Navigator.of(context).pushReplacementNamed(Routes.showQR);
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
                    width: 90,
                    height: 90,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(
                            color: Theme.of(context).iconTheme.color!,
                            width: 2)),
                    child: SvgPicture.asset(
                      'assets/svg/tpin.svg',
                      color: Theme.of(context).iconTheme.color,
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Text('ENTER PIN',
                        style: Theme.of(context).textTheme.displayMedium)
                    .tr(),
              ),
              Center(
                child: Text(
                  'pinSum',
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
                    children: pinFields.map((e) {
                      int index = pinFields.indexOf(e);
                      return SizedBox(
                          width: 45,
                          child: KeyboardListener(
                            focusNode: FocusNode(),
                            onKeyEvent: (value) {
                              if (index > 0 &&
                                  value.physicalKey ==
                                      PhysicalKeyboardKey.backspace &&
                                  !e['filled']) {
                                pinFields[index - 1]['node'].requestFocus();
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
                                  if (index < pinFields.length - 1) {
                                    pinFields[index + 1]['node'].requestFocus();
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
                  );
                }),
              ),
              const SizedBox(
                height: 12,
              ),
              BlocSelector<EnterPINCubit, EnterPINState, bool>(
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
                      String code =
                          pinFields.map((e) => e['controller'].text).join();
                      if (code.length == 6) {
                        context.read<EnterPINCubit>().check(code);
                      }
                    },
                    child: const Text("Next").tr());
              })
            ],
          ),
        ),
      ),
    );
  }
}
