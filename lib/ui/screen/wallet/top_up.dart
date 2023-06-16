import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/wallet/top_up.dart';
import 'package:sun_point/logic/models/wallet/top_up.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class TopUpPage extends StatelessWidget {
  final TextEditingController amount = TextEditingController(),
      voucher = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  TopUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopUpCubit(),
      child: BlocListener<TopUpCubit, TopUpState>(
        listenWhen: (previous, current) => current.error.isNotEmpty,
        listener: (context, state) {
          showDialog(
              context: context,
              builder: (_) => ErrorDialog(
                    error: state.error,
                  ));
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Top Up').tr(),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.topupRequests);
                  },
                  child: const Text(
                    "My Requests",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ).tr())
            ],
          ),
          body: BlocBuilder<TopUpCubit, TopUpState>(
            buildWhen: (previous, current) =>
                previous.loading != current.loading,
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!state.loading && state.config == null) {
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
                              .read<TopUpCubit>()
                              .load()
                              .then((value) => null),
                          child: const Text('Retry').tr())
                    ],
                  ),
                );
              }
              return BlocSelector<TopUpCubit, TopUpState, bool>(
                selector: (state) {
                  return state.done;
                },
                builder: (context, state) {
                  if (state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                Icons.done,
                                color: Colors.green,
                                size: 70,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Center(
                            child: Text('SUCCESS!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium)
                                .tr(),
                          ),
                          Center(
                            child: Text(
                              'topUpSucc',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelLarge,
                            ).tr(),
                          ),
                          const SizedBox(
                            height: 64,
                          ),
                          _card(),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ok').tr())
                        ],
                      ),
                    );
                  }

                  return Form(
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
                                Icons.wallet,
                                size: 70,
                              )),
                        ),
                        Center(
                          child: Text(
                            'TOP UP',
                            style: Theme.of(context).textTheme.displayMedium,
                          ).tr(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Text('topUpSum',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelLarge)
                              .tr(),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        BlocBuilder<TopUpCubit, TopUpState>(
                          buildWhen: (previous, current) =>
                              previous.isVoucher != current.isVoucher,
                          builder: (context, state) {
                            return TextFormField(
                              enabled: !state.isVoucher,
                              controller: amount,
                              validator:
                                  !state.isVoucher ? amountValidator : null,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'\d|\.'))
                              ],
                              decoration: InputDecoration(
                                  labelText: "Amount".tr(),
                                  helperText: "range".tr(args: [
                                    state.config!['from'].toString(),
                                    state.config!['to'].toString()
                                  ])),
                              onChanged: (value) =>
                                  context.read<TopUpCubit>().getAmount(value),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        BlocSelector<TopUpCubit, TopUpState, bool>(
                          selector: (state) => state.isVoucher,
                          builder: (context, state) {
                            return CheckboxListTile(
                              value: state,
                              title: const Text('Use a voucher').tr(),
                              onChanged: (value) {
                                context.read<TopUpCubit>().setIsVoucher(value!);
                                if (value) {
                                  amount.clear();
                                } else {
                                  voucher.clear();
                                }
                              },
                            );
                          },
                        ),
                        BlocSelector<TopUpCubit, TopUpState, bool>(
                          selector: (state) => state.isVoucher,
                          builder: (context, state) {
                            return TextFormField(
                              controller: voucher,
                              enabled: state,
                              validator: state ? isNotEmpty : null,
                              decoration: InputDecoration(
                                  labelText: "Voucher Code".tr()),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        _card(),
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: SizedBox.square(
                            dimension: 32,
                            child: BlocSelector<TopUpCubit, TopUpState, bool>(
                              selector: (state) {
                                return state.submitting;
                              },
                              builder: (context, state) {
                                return Visibility(
                                    visible: state,
                                    child: const CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Builder(builder: (context) {
                          return ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<TopUpCubit>()
                                      .submit(amount.text, voucher.text);
                                }
                              },
                              child: const Text("Next").tr());
                        })
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Center _card() {
    return Center(
      child: BlocSelector<TopUpCubit, TopUpState, bool>(
        selector: (state) => state.isVoucher,
        builder: (context, state) {
          return Visibility(
            visible: !state,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'You will receive',
                      style: Theme.of(context).textTheme.labelLarge,
                    ).tr(),
                    BlocBuilder<TopUpCubit, TopUpState>(
                      buildWhen: (previous, current) =>
                          previous.loadingAmount != current.loadingAmount ||
                          previous.amount != current.amount,
                      builder: (context, state) {
                        return Visibility(
                          visible: state.loadingAmount,
                          replacement: Text(
                            state.amount.toStringAsFixed(2),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(fontSize: 18),
                          ),
                          child: const CircularProgressIndicator(),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
