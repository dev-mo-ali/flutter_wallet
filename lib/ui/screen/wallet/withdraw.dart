import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sun_point/logic/controllers/wallet/withdraw.dart';
import 'package:sun_point/logic/models/wallet/withdraw.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/utils/validators.dart';

class WithdrawPage extends StatelessWidget {
  final TextEditingController amount = TextEditingController(),
      accountNumber = TextEditingController(),
      holderName = TextEditingController();
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
          ),
          body: BlocSelector<WithdrawCubit, WithdrawState, bool>(
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
                      enabled: !state,
                      controller: amount,
                      validator: !state ? amountValidator : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'\d|\.'))
                      ],
                      decoration: InputDecoration(
                        labelText: "Amount".tr(),
                      ),
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
                    DropdownButtonFormField(
                        hint: const Text("Select your bank").tr(),
                        items: List.generate(
                            3,
                            (index) => DropdownMenuItem(
                                value: index,
                                child: Text("Bank ${index + 1}"))),
                        onChanged: (v) {}),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: accountNumber,
                      validator: isNotEmpty,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: "Account Number".tr(),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: holderName,
                      validator: isNotEmpty,
                      decoration: const InputDecoration(
                        labelText: "Holder Name",
                      ),
                    ),
                    Center(
                      child: SizedBox.square(
                        dimension: 32,
                        child: BlocSelector<WithdrawCubit, WithdrawState, bool>(
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
                            if (_formKey.currentState!.validate()) {}
                          },
                          child: const Text("Next").tr());
                    })
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
