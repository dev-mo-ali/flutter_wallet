import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sun_point/logic/controllers/auth/login.dart';
import 'package:sun_point/logic/models/auth/login.dart';
import 'package:sun_point/ui/screen/auth/setup_tpin.dart';
import 'package:sun_point/ui/widgets/country_dialog.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // TextEditingController phone = TextEditingController(),
  //     password = TextEditingController();
  TextEditingController phone = TextEditingController(text: '12345678'),
      password = TextEditingController(text: '12345678');
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login").tr(),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<LoginCubit, LoginState>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) {
                if (state.goEmailVerify == true) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.emailVerify, (route) => false);
                } else if (state.goSetup == true) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.setupTPIN, (route) => false,
                      arguments: SetupTPINArgs());
                } else {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(Routes.home, (route) => false);
                }
              },
            ),
            BlocListener<LoginCubit, LoginState>(
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(
                            color: Theme.of(context).iconTheme.color!,
                            width: 2)),
                    child: const Icon(
                      FontAwesomeIcons.rightFromBracket,
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
                      BlocSelector<LoginCubit, LoginState, String>(
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
                                context.read<LoginCubit>().setCode(code);
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
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
                BlocSelector<LoginCubit, LoginState, String>(
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
                  height: 12,
                ),
                TextFormField(
                  validator: isNotEmpty,
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password".tr(),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocSelector<LoginCubit, LoginState, bool>(
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
                              .read<LoginCubit>()
                              .login(phone.text, password.text);
                        }
                      },
                      child: const Text("Login").tr());
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
