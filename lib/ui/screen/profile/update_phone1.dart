import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/profile/update_phone1.dart';
import 'package:sun_point/logic/models/profile/update_phone1.dart';
import 'package:sun_point/ui/screen/profile/update_phone2.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class UpdatePhone1Page extends StatelessWidget {
  UpdatePhone1Page({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdatePhone1Cubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Phone Number').tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<UpdatePhone1Cubit, UpdatePhone1State>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) async {
                Navigator.of(context).pushReplacementNamed(Routes.updatePhone2,
                    arguments: UpdatePhone2Args(password: state.password!));
              },
            ),
            BlocListener<UpdatePhone1Cubit, UpdatePhone1State>(
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
                      Icons.phone_outlined,
                      size: 70,
                    )),
              ),
              Center(
                child: Text(
                  'CHANGE PHONE NUMBER',
                  style: Theme.of(context).textTheme.displayMedium,
                ).tr(),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Text('updatePhoneNu1Sum',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge)
                    .tr(),
              ),
              const SizedBox(
                height: 32,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: isNotEmpty,
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password".tr(),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              BlocSelector<UpdatePhone1Cubit, UpdatePhone1State, bool>(
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
                      context
                          .read<UpdatePhone1Cubit>()
                          .checkPassword(password.text);
                    }
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
