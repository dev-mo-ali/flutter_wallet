import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_point/logic/controllers/auth/start_up.dart';
import 'package:sun_point/logic/models/auth/start_up.dart';
import 'package:sun_point/ui/screen/auth/setup_tpin.dart';
// import 'package:sun_point/ui/pages/auth/tpin.dart';
import 'package:sun_point/utils/auth.dart';
import 'package:sun_point/utils/routes.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartUpCubit(),
      child: BlocListener<StartUpCubit, StartUpState>(
        listener: (context, state) {
          // TODO: Add missed routes
          if (state.goUpdate == true) {
            //   Navigator.of(context)
            //       .pushNamedAndRemoveUntil(Routes.upgrade, (route) => false);
          } else if (state.login == true && state.done) {
            if (state.goEmailVerify == true) {
              Navigator.of(context).pushReplacementNamed(Routes.emailVerify);
            } else if (state.goSetup == true) {
              Navigator.of(context).pushReplacementNamed(Routes.setupTPIN,
                  arguments: SetupTPINArgs());
            } else if (state.goSetup == false) {
              Navigator.of(context).pushReplacementNamed(Routes.home);
            }
          } else if (state.login == false || state.wrongCred == true) {
            if (state.wrongCred == true) {
              User.logout().then((value) => null);
            }
            Navigator.of(context).pushReplacementNamed(Routes.mainAuth);
          }
        },
        child: Scaffold(
          body: Center(
            child: BlocBuilder<StartUpCubit, StartUpState>(
              builder: (context, state) {
                if (state.loading) {
                  return const CircularProgressIndicator();
                } else if (state.loading == false && state.done == false) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login Failed",
                        style:
                            Theme.of(context).inputDecorationTheme.errorStyle,
                        textAlign: TextAlign.center,
                      ).tr(),
                      const SizedBox(
                        height: 16,
                      ),
                      TextButton(
                          onPressed: () => context.read<StartUpCubit>().login(),
                          child: const Text('Retry').tr()),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
