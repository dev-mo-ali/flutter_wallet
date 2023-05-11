import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/logic/controllers/auth/security_question.dart';
import 'package:sun_point/logic/models/auth/security_question.dart';

import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/ui/widgets/select_dialog.dart';

import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class ResetSecurityQuePage extends StatelessWidget {
  ResetSecurityQuePage({super.key});

  TextEditingController answer = TextEditingController();
  // TextEditingController answer = TextEditingController(text: 'test');
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SecurityQueCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account Security').tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<SecurityQueCubit, SecurityQueState>(
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
          child: BlocBuilder<SecurityQueCubit, SecurityQueState>(
            buildWhen: (previous, current) =>
                previous.loading != current.loading,
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!state.loading && state.questions == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Error occurred.",
                        style:
                            Theme.of(context).inputDecorationTheme.errorStyle,
                        textAlign: TextAlign.center,
                      ).tr(),
                      const SizedBox(
                        height: 16,
                      ),
                      TextButton(
                          onPressed: () => context
                              .read<SecurityQueCubit>()
                              .getQuestions()
                              .then((value) => null),
                          child: const Text('Retry').tr())
                    ],
                  ),
                );
              }
              if (state.questions != null && state.questions!.isEmpty) {
                return const Center(
                  child: Text(
                    'No Questions',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
              return BlocBuilder<SecurityQueCubit, SecurityQueState>(
                buildWhen: (previous, current) => current.done != previous.done,
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium)
                                .tr(),
                          ),
                          Center(
                            child: Text(
                              'resetQueSucc',
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
                      Padding(
                        padding: const EdgeInsets.only(top: 42, bottom: 36),
                        child: SvgPicture.asset(
                          'assets/svg/question.svg',
                          width: 70,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Set Security Question',
                          style: Theme.of(context).textTheme.displayMedium,
                        ).tr(),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          'secQueSum',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge,
                        ).tr(),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          int? qid = await showDialog(
                              context: context,
                              builder: (_) => SelectDialog(
                                    items: state.questions!
                                        .map((e) => {
                                              'text': e[
                                                  'question_${context.locale.languageCode == "en" ? "en" : "cn"}'],
                                              'value': e['id']
                                            })
                                        .toList(),
                                  ));
                          if (qid != null) {
                            context
                                .read<SecurityQueCubit>()
                                .selectQuestion(qid);
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)))),
                        icon: const Icon(Icons.arrow_drop_down),
                        label: SizedBox(
                          width: double.infinity,
                          child:
                              BlocBuilder<SecurityQueCubit, SecurityQueState>(
                            buildWhen: (previous, current) =>
                                previous.currentQuestion !=
                                current.currentQuestion,
                            builder: (context, state) {
                              return Text(
                                (state.currentQuestion!)[
                                    'question_${context.locale.languageCode == "en" ? "en" : "cn"}'],
                                style: const TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          cursorColor: Theme.of(context).colorScheme.primary,
                          decoration:
                              InputDecoration(hintText: 'Your Answer'.tr()),
                          validator: isNotEmpty,
                          controller: answer,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: BlocSelector<SecurityQueCubit, SecurityQueState,
                            bool>(
                          selector: (state) => state.submitting,
                          builder: (context, state) {
                            return state
                                ? const CircularProgressIndicator()
                                : const SizedBox();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<SecurityQueCubit>()
                                  .reset(answer.text);
                            }
                          },
                          child: const Text('Next').tr())
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
