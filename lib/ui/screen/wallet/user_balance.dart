import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/logic/controllers/wallet/user_balance.dart';
import 'package:sun_point/logic/models/wallet/user_balance.dart';

class UserBalanceDialog extends StatelessWidget {
  const UserBalanceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBalanceCubit(),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: 350,
          child: BlocBuilder<UserBalanceCubit, UserBalanceState>(
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!state.loading && state.balance == null) {
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
                              .read<UserBalanceCubit>()
                              .load()
                              .then((value) => null),
                          child: const Text('Retry').tr()),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(15).copyWith(top: 24),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              border: Border.all(
                                  color: Theme.of(context).iconTheme.color!,
                                  width: 2)),
                          child: SvgPicture.asset(
                            'assets/svg/balance.svg',
                            color: Theme.of(context).iconTheme.color,
                          )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Your Balance Is',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 18),
                    ).tr(),
                    Text(
                      state.balance!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge,
                    ).tr(),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok").tr())
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
