import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/auth/email_verify.dart';
import 'package:sun_point/logic/models/auth/email_verify.dart';
import 'package:sun_point/ui/screen/auth/setup_tpin.dart';

import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class EmailVerifyPage extends StatelessWidget {
  EmailVerifyPage({
    super.key,
  });

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailVerifyCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Email Verify").tr(),
          actions: [
            IconButton(
                onPressed: () async {
                  await User.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.mainAuth, (route) => false);
                },
                icon: const Icon(Icons.logout_outlined)),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<EmailVerifyCubit, EmailVerifyState>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) async {
                User user = await User.getUser();
                if (!user.setup) {
                  Navigator.of(context).pushReplacementNamed(Routes.setupTPIN,
                      arguments: SetupTPINArgs());
                } else {
                  Navigator.of(context).pushReplacementNamed(
                    Routes.home,
                  );
                }
              },
            ),
            BlocListener<EmailVerifyCubit, EmailVerifyState>(
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
                      Icons.email_outlined,
                      size: 70,
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Text('EMAIL VERIFICATION',
                        style: Theme.of(context).textTheme.displayMedium)
                    .tr(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Center(
                  child: Text(
                    'emailVerSum',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
                  ).tr(),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: isNotEmpty,
                    maxLength: 4,
                    controller: code,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Verification Code'.tr(),
                        counterText: ''),
                  )),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: BlocSelector<EmailVerifyCubit, EmailVerifyState, int>(
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
              BlocBuilder<EmailVerifyCubit, EmailVerifyState>(
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
                          context.read<EmailVerifyCubit>().resend();
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 8,
              ),
              BlocSelector<EmailVerifyCubit, EmailVerifyState, bool>(
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
                      if (_formKey.currentState!.validate()) {
                        context.read<EmailVerifyCubit>().verify(code.text);
                      }
                    },
                    child: const Text("Next").tr());
              }),
              const SizedBox(
                height: 8,
              ),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: 'yourEmail'.tr(),
                  ),
                  TextSpan(
                      text: 'yourEmail2'.tr(args: ['ghale@evo.com']),
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                ]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.updateEmail);
                  },
                  child: const Text("Change Email").tr()),
            ],
          ),
        ),
      ),
    );
  }
}
