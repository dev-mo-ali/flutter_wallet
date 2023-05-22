import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sun_point/logic/controllers/profile/update_phone2.dart';
import 'package:sun_point/logic/models/profile/update_phone2.dart';
import 'package:sun_point/ui/screen/profile/update_phone3.dart';
import 'package:sun_point/ui/widgets/country_dialog.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';

class UpdatePhone2Args {
  String password;
  UpdatePhone2Args({
    required this.password,
  });
}

class UpdatePhone2Page extends StatelessWidget {
  final UpdatePhone2Args args;

  UpdatePhone2Page({
    Key? key,
    required this.args,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdatePhone2Cubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Phone Number').tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<UpdatePhone2Cubit, UpdatePhone2State>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) async {
                Navigator.of(context).pushNamed(Routes.updatePhone3,
                    arguments: UpdatePhone3Args(
                        phone: state.countryCode + phone.text,
                        password: args.password));
              },
            ),
            BlocListener<UpdatePhone2Cubit, UpdatePhone2State>(
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
                child: Text('updatePhoneNu2Sum',
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: (Theme.of(context)
                                .inputDecorationTheme
                                .enabledBorder as OutlineInputBorder)
                            .borderRadius,
                        border: Border.all(
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .enabledBorder!
                                .borderSide
                                .color),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.phone),
                          BlocSelector<UpdatePhone2Cubit, UpdatePhone2State,
                              String>(
                            selector: (state) {
                              return state.countryCode;
                            },
                            builder: (context, state) {
                              return InkWell(
                                onTap: () async {
                                  String? code = await showDialog(
                                      context: context,
                                      builder: (_) => const CountryDialog());
                                  if (code != null) {
                                    context
                                        .read<UpdatePhone2Cubit>()
                                        .secCode(code);
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    '+$state',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: phone,
                              decoration: InputDecoration(
                                hintText: "Phone Number".tr(),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                              ),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocSelector<UpdatePhone2Cubit, UpdatePhone2State, String>(
                      selector: (state) => state.phoneError,
                      builder: (context, state) {
                        return state.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  state,
                                  style: Theme.of(context)
                                      .inputDecorationTheme
                                      .errorStyle,
                                ).tr(),
                              )
                            : const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              BlocSelector<UpdatePhone2Cubit, UpdatePhone2State, bool>(
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
                      context.read<UpdatePhone2Cubit>().submit(
                          phone.text,
                          args.password,
                          context.locale.languageCode == 'en' ? 'en' : 'cn');
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
