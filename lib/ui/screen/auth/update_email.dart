import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/auth/update_email.dart';
import 'package:sun_point/logic/models/auth/update_email.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class UpdateEmailPage extends StatelessWidget {
  UpdateEmailPage({super.key});
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateEmailCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Email').tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<UpdateEmailCubit, UpdateEmailState>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) async {
                await User.logout();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(Routes.login, (route) => false);
              },
            ),
            BlocListener<UpdateEmailCubit, UpdateEmailState>(
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
              Center(
                child: Text(
                  'CHANGE EMAIL',
                  style: Theme.of(context).textTheme.displayMedium,
                ).tr(),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Text('updateEmailSum',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge)
                    .tr(),
              ),
              const SizedBox(
                height: 32,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: isNotEmpty,
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  decoration: InputDecoration(hintText: 'Email'.tr()),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              BlocSelector<UpdateEmailCubit, UpdateEmailState, bool>(
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
                      context.read<UpdateEmailCubit>().update(email.text);
                    }
                  },
                  child: const Text('Update').tr(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
