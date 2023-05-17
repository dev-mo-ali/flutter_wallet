import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sun_point/logic/controllers/auth/register2.dart';
import 'package:sun_point/logic/models/auth/register2.dart';
import 'package:sun_point/ui/widgets/bottom_bar.dart';
import 'package:sun_point/ui/widgets/country_dialog.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';
import 'package:url_launcher/url_launcher.dart';

class Register2Args {
  Map registeredUser;
  String otp;
  Register2Args({
    required this.registeredUser,
    required this.otp,
  });
}

class Register2Page extends StatelessWidget {
  Register2Args args;
  DateFormat format = DateFormat('yyyy-MM-dd');
  Register2Page({
    Key? key,
    required this.args,
  }) : super(key: key);

  TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      idNumber = TextEditingController(),
      emergencyName = TextEditingController(),
      emergencyPhone = TextEditingController(),
      emergencyRelationship = TextEditingController();

  // TextEditingController name = TextEditingController(text: 'ghale'),
  //     email = TextEditingController(text: 'ghale@evo.com'),
  //     idNumber = TextEditingController(text: '123'),
  //     emergencyName = TextEditingController(text: 'mohamed'),
  //     emergencyPhone = TextEditingController(text: '123456789'),
  //     emergencyRelationship = TextEditingController(text: 'co-worker');
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Register2Cubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register").tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<Register2Cubit, Register2State>(
              listenWhen: (previous, current) => current.error.isNotEmpty,
              listener: (context, state) {
                showDialog(
                    context: context,
                    builder: (_) => ErrorDialog(error: state.error));
              },
            ),
            BlocListener<Register2Cubit, Register2State>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.registerSucc, (route) => route.isFirst);
              },
            )
          ],
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      FontAwesomeIcons.user,
                      size: 70,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                TextFormField(
                  validator: isNotEmpty,
                  controller: name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Full Name".tr(),
                    prefixIcon: const Icon(Icons.person_2_outlined),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  validator: isNotEmpty,
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email".tr(),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
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
                      const Icon(Icons.calendar_month_outlined),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: BlocSelector<Register2Cubit, Register2State,
                            DateTime?>(
                          selector: (state) {
                            return state.birth;
                          },
                          builder: (context, state) {
                            return InkWell(
                              onTap: () async {
                                DateTime? birth = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) => Theme(
                                      data: ThemeData(
                                          colorScheme:
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? ColorScheme.dark(
                                                      primary: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      surface: Theme.of(context)
                                                          .cardColor,
                                                      onPrimary: Colors.white,
                                                      onSurface: Colors.white54,
                                                    )
                                                  : ColorScheme.light(
                                                      primary: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      surface: Theme.of(context)
                                                          .cardColor,
                                                      onPrimary: Colors.white,
                                                      onSurface: Colors.black54,
                                                    )),
                                      child: child!),
                                );
                                if (birth != null) {
                                  context
                                      .read<Register2Cubit>()
                                      .setBirth(birth);
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  state != null
                                      ? format.format(state)
                                      : 'Birthday',
                                  style: Theme.of(context)
                                      .inputDecorationTheme
                                      .labelStyle,
                                ).tr(),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                BlocSelector<Register2Cubit, Register2State, String>(
                  selector: (state) => state.birthError,
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
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Identification',
                    style: Theme.of(context).textTheme.labelLarge,
                  ).tr(),
                ),
                TextFormField(
                  validator: isNotEmpty,
                  controller: idNumber,
                  decoration: InputDecoration(
                    labelText: "IC / Passport number".tr(),
                    prefixIcon: const Icon(Icons.numbers),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocSelector<Register2Cubit, Register2State, String?>(
                  selector: (state) {
                    return state.icImg;
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
                                      .read<Register2Cubit>()
                                      .selectICImg(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
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
                BlocSelector<Register2Cubit, Register2State, String>(
                  selector: (state) => state.icImgError,
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
                BlocSelector<Register2Cubit, Register2State, String>(
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
                                .read<Register2Cubit>()
                                .setIDType(value!),
                            title: const Text('IC').tr(),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: 'passport',
                            groupValue: state,
                            onChanged: (value) => context
                                .read<Register2Cubit>()
                                .setIDType(value!),
                            title: const Text('Passport').tr(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Emergency Contact',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                TextFormField(
                  validator: isNotEmpty,
                  controller: emergencyName,
                  decoration: InputDecoration(
                    labelText: "Full Name".tr(),
                    prefixIcon: const Icon(Icons.person_2_outlined),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  validator: isNotEmpty,
                  controller: emergencyRelationship,
                  decoration: InputDecoration(
                    labelText: "Relationship".tr(),
                    prefixIcon: const Icon(FontAwesomeIcons.peopleArrows),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
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
                      BlocSelector<Register2Cubit, Register2State, String>(
                        selector: (state) {
                          return state.countryCode;
                        },
                        builder: (context, state) {
                          return InkWell(
                            onTap: () async {
                              String? code = await showDialog(
                                  context: context,
                                  builder: (_) => CountryDialog());
                              if (code != null) {
                                context
                                    .read<Register2Cubit>()
                                    .setCountyCode(code);
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '+$state',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: emergencyPhone,
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
                BlocSelector<Register2Cubit, Register2State, String>(
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
                const SizedBox(
                  height: 8,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.labelMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'By continuing, you agree to our '.tr(),
                      ),
                      TextSpan(
                          text: 'Privacy Policy'.tr(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse(
                                  'https://worldpoint2u.com/privacy-terms/');
                              if (await canLaunchUrl(url)) {
                                launchUrl(url, mode: LaunchMode.inAppWebView);
                              }
                            }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocSelector<Register2Cubit, Register2State, bool>(
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
                          context.read<Register2Cubit>().submitRequest(
                              name: name.text,
                              password: args.registeredUser['password'],
                              number: args.registeredUser['phone'],
                              otp: args.otp,
                              email: email.text,
                              agentCode: args.registeredUser['agent'],
                              userID: args.registeredUser['userID'],
                              identificationNumber: idNumber.text,
                              emergencyName: emergencyName.text,
                              emergencyPhone: emergencyPhone.text,
                              emergencyRelationship:
                                  emergencyRelationship.text);
                        }
                      },
                      child: const Text("Register").tr());
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
