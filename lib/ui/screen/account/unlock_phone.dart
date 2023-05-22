import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/account/unlock_phone.dart';
import 'package:sun_point/logic/models/account/unlock_phone.dart';
import 'package:sun_point/utils/routes.dart';

class UnlockPhonePage extends StatelessWidget {
  const UnlockPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnlockPhoneCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Unlock Phone").tr(),
        ),
        body: BlocConsumer<UnlockPhoneCubit, UnlockPhoneState>(
          listenWhen: (previous, current) => current.done,
          listener: (context, state) => Navigator.of(context)
              .pushNamedAndRemoveUntil(
                  Routes.unlockPhoneSucc, (route) => false),
          buildWhen: (previous, current) => previous.loading != current.loading,
          builder: (context, state) {
            if (state.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!state.loading && !state.done) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Error occurred.",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ).tr(),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                        onPressed: () => context
                            .read<UnlockPhoneCubit>()
                            .load()
                            .then((value) => null),
                        child: const Text('Retry').tr())
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
