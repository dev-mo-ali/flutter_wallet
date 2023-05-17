import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sun_point/logic/controllers/auth/updata_id_image.dart';
import 'package:sun_point/logic/controllers/auth/update_email.dart';
import 'package:sun_point/logic/models/auth/update_email.dart';
import 'package:sun_point/logic/models/auth/update_id_image.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class UpdateIDImageArgs {
  String username;
  UpdateIDImageArgs({
    required this.username,
  });
}

class UpdateIDImagePage extends StatelessWidget {
  UpdateIDImageArgs args;
  UpdateIDImagePage({
    Key? key,
    required this.args,
  }) : super(key: key);
  TextEditingController idNumber = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateIDImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update Identification Image').tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<UpdateIDImageCubit, UpdateIDImageState>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) async {
                Navigator.of(context).pushReplacementNamed(Routes.registerSucc);
              },
            ),
            BlocListener<UpdateIDImageCubit, UpdateIDImageState>(
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(
                            color: Theme.of(context).iconTheme.color!,
                            width: 2)),
                    child: const Icon(
                      FontAwesomeIcons.passport,
                      size: 60,
                    )),
              ),
              Center(
                child: Text(
                  'UPDATE IDENTIFICATION IMAGE',
                  style: Theme.of(context).textTheme.displayMedium,
                ).tr(),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Text('updateIDImageSum',
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
                  controller: idNumber,
                  decoration: InputDecoration(
                    labelText: "IC / Passport number".tr(),
                    prefixIcon: const Icon(Icons.numbers),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocSelector<UpdateIDImageCubit, UpdateIDImageState, String?>(
                selector: (state) {
                  return state.idImg;
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            const Icon(FontAwesomeIcons.idCard),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => context
                                    .read<UpdateIDImageCubit>()
                                    .selectICImg(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    state == null
                                        ? 'Select IC / Passport Image'
                                        : state.split('/').last,
                                    style: Theme.of(context)
                                        .inputDecorationTheme
                                        .labelStyle,
                                  ).tr(),
                                ),
                              ),
                            ),
                            state != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      File(state),
                                      width: 40,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: Text(
                          'Max size: 5MB',
                          style: Theme.of(context).textTheme.labelSmall,
                        ).tr(),
                      )
                    ],
                  );
                },
              ),
              BlocSelector<UpdateIDImageCubit, UpdateIDImageState, String>(
                selector: (state) {
                  return state.idType;
                },
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: 'ic',
                          groupValue: state,
                          onChanged: (value) => context
                              .read<UpdateIDImageCubit>()
                              .selectIdType(value!),
                          title: const Text('IC').tr(),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: 'passport',
                          groupValue: state,
                          onChanged: (value) => context
                              .read<UpdateIDImageCubit>()
                              .selectIdType(value!),
                          title: const Text('Passport').tr(),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 8,
              ),
              BlocSelector<UpdateIDImageCubit, UpdateIDImageState, bool>(
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
                          .read<UpdateIDImageCubit>()
                          .submit(args.username, idNumber.text);
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
