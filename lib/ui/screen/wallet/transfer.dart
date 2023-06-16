import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/logic/controllers/wallet/transfer.dart';
import 'package:sun_point/logic/models/wallet/transfer.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferPage extends StatelessWidget {
  TransferPage({super.key});

  final TextEditingController phone = TextEditingController(text: ''),
      amount = TextEditingController(text: '');
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransferCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Transfer").tr(),
          actions: [
            BlocBuilder<TransferCubit, TransferState>(
              buildWhen: (previous, current) =>
                  previous.loading != current.loading ||
                  previous.done != current.done,
              builder: (context, state) {
                return Visibility(
                    visible: state.config != null && !state.done,
                    child: IconButton(
                      onPressed: () async {
                        var data = await Navigator.of(context)
                            .pushNamed(Routes.scanQr);
                        if (data != null) {
                          context.read<TransferCubit>().setUser(data as Map);
                          phone.text = data['username'];
                        }
                      },
                      icon: const Icon(Icons.qr_code),
                    ));
              },
            )
          ],
        ),
        body: BlocConsumer<TransferCubit, TransferState>(
          listenWhen: (previous, current) => current.error.isNotEmpty,
          listener: (context, state) {
            showDialog(
                context: context,
                builder: (_) => ErrorDialog(error: state.error));
          },
          buildWhen: (previous, current) => previous.loading != current.loading,
          builder: (context, state) {
            if (state.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!state.loading && state.config == null) {
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
                            .read<TransferCubit>()
                            .load()
                            .then((value) => null),
                        child: const Text('Retry').tr())
                  ],
                ),
              );
            }
            return BlocBuilder<TransferCubit, TransferState>(
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
                                  style:
                                      Theme.of(context).textTheme.displayMedium)
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
                return ListView(
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
                            'assets/svg/transfer.svg',
                            width: 65,
                            color: Theme.of(context).iconTheme.color,
                          )),
                    ),
                    Center(
                      child: Text(
                        'TRANSFERTitle',
                        style: Theme.of(context).textTheme.displayMedium,
                      ).tr(),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Text('transferSum',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelLarge)
                          .tr(),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: phone,
                              onChanged: (_) =>
                                  context.read<TransferCubit>().setUser(null),
                              validator: phoneNumberValidator,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: "Receiver Phone Number".tr()),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            BlocBuilder<TransferCubit, TransferState>(
                              buildWhen: (previous, current) =>
                                  previous.qrUsed != current.qrUsed,
                              builder: (context, state) {
                                return Visibility(
                                  visible: state.qrUsed,
                                  child: TextFormField(
                                    controller: TextEditingController(
                                        text: state.fullName),
                                    enabled: false,
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black),
                                    decoration: InputDecoration(
                                        labelText: "Receiver Full Name".tr(),
                                        disabledBorder: Theme.of(context)
                                            .inputDecorationTheme
                                            .enabledBorder),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: amount,
                              validator: amountValidator,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'\d|\.'))
                              ],
                              decoration: InputDecoration(
                                labelText: "Amount".tr(),
                                helperText: "range".tr(
                                  args: [
                                    state.config!['from'].toString(),
                                    state.config!['to'].toString()
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: SizedBox.square(
                                dimension: 32,
                                child: BlocSelector<TransferCubit,
                                    TransferState, bool>(
                                  selector: (state) {
                                    return state.submitting;
                                  },
                                  builder: (context, state) {
                                    return Visibility(
                                        visible: state,
                                        child:
                                            const CircularProgressIndicator());
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<TransferCubit>()
                                        .submit(phone.text, amount.text);
                                  }
                                },
                                child: const Text("Next").tr()),
                          ],
                        ))
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
