import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sun_point/logic/controllers/account/reset_tpin2.dart';
import 'package:sun_point/logic/controllers/auth/setup_tpin.dart';
import 'package:sun_point/logic/models/account/reset_tpin2.dart';
import 'package:sun_point/logic/models/auth/setup_tpin.dart';
import 'package:sun_point/ui/screen/auth/security_question.dart';
import 'package:sun_point/ui/widgets/bottom_bar.dart';
import 'package:sun_point/ui/widgets/country_dialog.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';

class ResetTPIN2Args {
  String? prevTpin;
  String password;

  ResetTPIN2Args({
    this.prevTpin,
    required this.password,
  });
}

class ResetTPIN2Page extends StatelessWidget {
  ResetTPIN2Args args;
  List tpinFields = [];
  ResetTPIN2Page({
    Key? key,
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
      create: (context) => ResetTPIN2Cubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account Security').tr(),
        ),
        body: BlocListener<ResetTPIN2Cubit, ResetTPIN2State>(
          listenWhen: (previous, current) => current.error.isNotEmpty,
          listener: (context, state) {
            showDialog(
              context: context,
              builder: (_) => ErrorDialog(error: state.error),
            );
          },
          child: BlocBuilder<ResetTPIN2Cubit, ResetTPIN2State>(
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
                          'resetTPINSucc',
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
              return ListView(
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
                                decoration:
                                    const InputDecoration(counterText: ''),
                                onChanged: (v) {
                                  if (v.length == 1) {
                                    e['filled'] = true;
                                    if (index < tpinFields.length - 1) {
                                      tpinFields[index + 1]['node']
                                          .requestFocus();
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
                              Navigator.of(context).pushNamed(Routes.resetTPIN2,
                                  arguments: ResetTPIN2Args(
                                      prevTpin: code, password: args.password));
                            } else {
                              if (args.prevTpin == code) {
                                context
                                    .read<ResetTPIN2Cubit>()
                                    .submit(args.password, code);
                              } else {
                                context
                                    .read<ResetTPIN2Cubit>()
                                    .setError('tpinErr2');
                              }
                            }
                          } else {
                            context.read<ResetTPIN2Cubit>().setError('tpinErr');
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
              );
            },
          ),
        ),
      ),
    );
  }
}
