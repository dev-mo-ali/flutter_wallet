import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sun_point/logic/controllers/auth/setup_tpin.dart';
import 'package:sun_point/logic/models/auth/setup_tpin.dart';
import 'package:sun_point/ui/screen/auth/security_question.dart';

import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';

class SetupTPINArgs {
  String? prevTpin;

  SetupTPINArgs({
    this.prevTpin,
  });
}

// ignore: must_be_immutable
class SetupTPINPage extends StatelessWidget {
  final SetupTPINArgs args;
  List tpinFields = [];
  SetupTPINPage({
    super.key,
    required this.args,
  }) {
    tpinFields = List.generate(
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
      create: (context) => SetupTPINCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Setup").tr(),
        ),
        body: BlocListener<SetupTPINCubit, SetupTPINState>(
          listenWhen: (previous, current) => current.error.isNotEmpty,
          listener: (context, state) {
            showDialog(
              context: context,
              builder: (_) => ErrorDialog(error: state.error),
            );
          },
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
                child: Text('SET PIN CODE',
                        style: Theme.of(context).textTheme.displayMedium)
                    .tr(),
              ),
              Center(
                child: Text(
                  args.prevTpin == null ? 'tpin1Sum' : 'tpin2Sum',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ).tr(),
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
              const SizedBox(
                height: 64,
              ),
              Builder(builder: (context) {
                return ElevatedButton(
                    onPressed: () {
                      String code = tpinFields
                          .map((e) => e['controller'].text)
                          .toList()
                          .join();
                      if (code.length == 6) {
                        if (args.prevTpin == null) {
                          Navigator.of(context).pushNamed(Routes.setupTPIN,
                              arguments: SetupTPINArgs(prevTpin: code));
                        } else {
                          if (args.prevTpin == code) {
                            Navigator.of(context).pushNamed(
                                Routes.setupQuestion,
                                arguments: SecurityQueArgs(tpin: code));
                          } else {
                            context.read<SetupTPINCubit>().setError('tpinErr2');
                          }
                        }
                      } else {
                        context.read<SetupTPINCubit>().setError('tpinErr');
                      }
                    },
                    child: const Text("Next").tr());
              }),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'tpinPlz',
              ).tr()
            ],
          ),
        ),
      ),
    );
  }
}
