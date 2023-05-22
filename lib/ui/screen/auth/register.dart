import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sun_point/logic/controllers/auth/register.dart';
import 'package:sun_point/logic/models/auth/register.dart';
import 'package:sun_point/logic/providers/auth.dart';
import 'package:sun_point/ui/screen/auth/otp.dart';
import 'package:sun_point/ui/widgets/country_dialog.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {
  List userIdFields = [];
  final TextEditingController phone = TextEditingController(),
      agent = TextEditingController(),
      password = TextEditingController(),
      passConf = TextEditingController();

  // final TextEditingController phone = TextEditingController(text: '123456789'),
  //     agent = TextEditingController(text: "AA"),
  //     password = TextEditingController(text: '12345678'),
  //     passConf = TextEditingController(text: '12345678');

  final GlobalKey<FormState> _formKey = GlobalKey();

  RegisterPage({super.key}) {
    userIdFields = List.generate(
        4,
        (index) => {
              'controller': TextEditingController(),
              'node': FocusNode(),
              'filled': false
            });
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'fieldReq'.tr();
    }

    if (value.length < 8) {
      return 'passErr'.tr();
    }
    return null;
  }

  String? passConfValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'fieldReq'.tr();
    }

    if (value != password.text) {
      return 'passErr2'.tr();
    }
    if (value.length < 8) {
      return 'passErr'.tr();
    }
    return null;
  }

  String? agentValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'fieldReq'.tr();
    }
    RegExp regEx = RegExp(r'^[A-Z]{2}$');
    if (!regEx.hasMatch(value)) {
      return 'agentErr'.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register").tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<RegisterCubit, RegisterState>(
              listenWhen: (previous, current) => current.error.isNotEmpty,
              listener: (context, state) {
                showDialog(
                    context: context,
                    builder: (_) => ErrorDialog(error: state.error));
              },
            ),
            BlocListener<RegisterCubit, RegisterState>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) {
                Navigator.of(context).pushNamed(Routes.otp,
                    arguments: OTPArgs(
                        phone: state.countryCode + phone.text,
                        registeredUser: {
                          'phone': state.countryCode + phone.text,
                          'agent': agent.text,
                          'userID': userIdFields
                              .map((e) => e['controller'].text)
                              .toList()
                              .join(),
                          'password': password.text
                        },
                        type: AuthAPI.OTP_TYPE_CODE_REGISTER));
              },
            ),
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
                      BlocSelector<RegisterCubit, RegisterState, String>(
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
                                    .read<RegisterCubit>()
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
                const SizedBox(
                  height: 4,
                ),
                BlocSelector<RegisterCubit, RegisterState, String>(
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
                  height: 16,
                ),
                TextFormField(
                  controller: agent,
                  validator: agentValidator,
                  maxLength: 2,
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: "Agent Code".tr(),
                    prefixIcon: const Icon(Icons.person_2_outlined),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'User ID (4-digits)',
                        style:
                            Theme.of(context).inputDecorationTheme.labelStyle,
                      ).tr(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: userIdFields.map((e) {
                          int index = userIdFields.indexOf(e);
                          return SizedBox(
                              width: 45,
                              child: KeyboardListener(
                                focusNode: FocusNode(),
                                onKeyEvent: (value) {
                                  if (index > 0 &&
                                      value.physicalKey ==
                                          PhysicalKeyboardKey.backspace &&
                                      !e['filled']) {
                                    userIdFields[index - 1]['node']
                                        .requestFocus();
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
                                      if (index < userIdFields.length - 1) {
                                        userIdFields[index + 1]['node']
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
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocSelector<RegisterCubit, RegisterState, String>(
                  selector: (state) => state.userIdError,
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
                  height: 14,
                ),
                TextFormField(
                  obscureText: true,
                  validator: passwordValidator,
                  controller: password,
                  decoration: InputDecoration(
                    labelText: "Password".tr(),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: true,
                  validator: passConfValidator,
                  controller: passConf,
                  decoration: InputDecoration(
                    labelText: "Password Confirmation".tr(),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocSelector<RegisterCubit, RegisterState, bool>(
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
                          context.read<RegisterCubit>().register(
                              phone.text,
                              agent.text,
                              userIdFields
                                  .map((e) => e['controller'].text)
                                  .toList()
                                  .join(),
                              context.locale.languageCode == 'en'
                                  ? 'en'
                                  : 'cn');
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
