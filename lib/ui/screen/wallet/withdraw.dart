import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/logic/controllers/wallet/withdraw.dart';
import 'package:sun_point/logic/models/wallet/withdraw.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';

class WithdrawPage extends StatelessWidget {
  final TextEditingController amount = TextEditingController(text: '111'),
      accountNumber = TextEditingController(text: '123'),
      holderName = TextEditingController(text: 'user');
  final GlobalKey<FormState> _formKey = GlobalKey();

  WithdrawPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WithdrawCubit(),
      child: BlocListener<WithdrawCubit, WithdrawState>(
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
            title: const Text('Withdraw').tr(),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.withdrawRequests);
                  },
                  child: const Text("My Requests").tr())
            ],
          ),
          body: BlocBuilder<WithdrawCubit, WithdrawState>(
            buildWhen: (previous, current) =>
                previous.loading != current.loading,
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!state.loading && !state.loaded) {
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
                              .read<WithdrawCubit>()
                              .load()
                              .then((value) => null),
                          child: const Text('Retry').tr())
                    ],
                  ),
                );
              }
              return BlocBuilder<WithdrawCubit, WithdrawState>(
                buildWhen: (previous, current) => previous.done != current.done,
                builder: (context, state) {
                  if (state.done) {
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
                              'withdrawSucc',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelLarge,
                            ).tr(),
                          ),
                          const SizedBox(
                            height: 64,
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
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000),
                                  border: Border.all(
                                      color: Theme.of(context).iconTheme.color!,
                                      width: 2)),
                              child: SvgPicture.asset(
                                'assets/svg/withdraw.svg',
                                width: 65,
                                color: Theme.of(context).iconTheme.color,
                              )),
                        ),
                        Center(
                          child: Text(
                            'WITHDRAWTitle',
                            style: Theme.of(context).textTheme.displayMedium,
                          ).tr(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Text('withdrawSum',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelLarge)
                              .tr(),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: amount,
                          validator: amountValidator,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'\d|\.'))
                          ],
                          decoration: InputDecoration(
                              labelText: "Amount".tr(),
                              helperText: "range".tr(args: [
                                state.config!['from'].toString(),
                                state.config!['to'].toString()
                              ])),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Bank Details:",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ).tr(),
                        const SizedBox(
                          height: 8,
                        ),
                        BlocBuilder<WithdrawCubit, WithdrawState>(
                          buildWhen: (previous, current) =>
                              previous.bankId != current.bankId,
                          builder: (context, state) {
                            return DropdownButtonFormField<int>(
                                validator: (value) =>
                                    value == null ? 'fieldReq'.tr() : null,
                                value: state.bankId,
                                hint: const Text("Select your bank").tr(),
                                items: state.banks!
                                    .map((e) => DropdownMenuItem<int>(
                                        value: e['id'], child: Text(e['name'])))
                                    .toList(),
                                onChanged: (v) {
                                  context.read<WithdrawCubit>().selectBank(v!);
                                });
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: accountNumber,
                          validator: isNotEmpty,
                          decoration: InputDecoration(
                            labelText: "Account Number".tr(),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: holderName,
                          validator: isNotEmpty,
                          decoration: const InputDecoration(
                            labelText: "Holder Name",
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: SizedBox.square(
                            dimension: 32,
                            child: BlocSelector<WithdrawCubit, WithdrawState,
                                bool>(
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
                                  context.read<WithdrawCubit>().submit(
                                      amount.text,
                                      accountNumber.text,
                                      holderName.text);
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
}
