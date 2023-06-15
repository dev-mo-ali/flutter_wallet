import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sun_point/logic/controllers/wallet/withdraw_request.dart';

import 'package:sun_point/logic/models/wallet/withdraw_request.dart';
import 'package:sun_point/logic/models/wallet/withdraw_requests.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/ui/widgets/yes_no_dialog.dart';

class WithdrawRequestArgs {
  int id;

  WithdrawRequestArgs({
    required this.id,
  });
}

class WithdrawRequestPage extends StatelessWidget {
  final WithdrawRequestArgs args;
  WithdrawRequestPage({super.key, required this.args});

  final DateFormat formater = DateFormat('dd/MM/yyyy H:m a');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WithdrawRequestCubit(args.id),
      child: Scaffold(
        appBar: AppBar(title: const Text('Withdraw.').tr()),
        body: MultiBlocListener(
          listeners: [
            BlocListener<WithdrawRequestCubit, WithdrawRequestState>(
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
          child: BlocBuilder<WithdrawRequestCubit, WithdrawRequestState>(
            buildWhen: (previous, current) =>
                previous.loading != current.loading,
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!state.loading && state.data == null) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Error occurred.",
                        style:
                            Theme.of(context).inputDecorationTheme.errorStyle,
                        textAlign: TextAlign.center,
                      ).tr(),
                      const SizedBox(
                        height: 16,
                      ),
                      TextButton(
                          onPressed: () => context
                              .read<WithdrawRequestCubit>()
                              .load()
                              .then((value) => null),
                          child: const Text('Retry').tr())
                    ],
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ).copyWith(top: 16),
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Account Balance',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge)
                                    .tr(),
                                Text(
                                  '${state.data!['amount']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ).tr(),
                                Builder(builder: (context) {
                                  switch (state.data!['status']) {
                                    case WithdrawRequestsState.STATUS_COMPLETED:
                                      return Text(
                                        'Completed',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontSize: 15,
                                                color: Colors
                                                    .greenAccent.shade700),
                                      ).tr();

                                    case WithdrawRequestsState.STATUS_PENDING:
                                      return Text(
                                        'Pending',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontSize: 15,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ).tr();

                                    case WithdrawRequestsState.STATUS_CANCELLED:
                                      return Text(
                                        'Cancelled',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontSize: 15,
                                                color: Colors.red.shade700),
                                      ).tr();

                                    case WithdrawRequestsState.STATUS_REJECTED:
                                      return Text(
                                        'Rejected',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontSize: 15,
                                                color: Colors.red.shade700),
                                      ).tr();
                                  }
                                  return const SizedBox();
                                }),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Bank',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ).tr(),
                                Text(
                                  state.data!['bank']['name'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Account Number',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ).tr(),
                                Text(
                                  state.data!['account_number'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Holder Name',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ).tr(),
                                Text(
                                  state.data!['holder_name'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date/Time',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ).tr(),
                                Text(
                                  formater.format(DateTime.parse(
                                      state.data!['updated_at'] ??
                                          state.data!['created_at'])
                                    ..toLocal()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  BlocBuilder<WithdrawRequestCubit, WithdrawRequestState>(
                    buildWhen: (previous, current) =>
                        previous.submitting != current.submitting,
                    builder: (context, state) {
                      if (state.submitting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Visibility(
                        visible: state.status ==
                            WithdrawRequestsState.STATUS_PENDING,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool? res = await showDialog(
                                context: context,
                                builder: (_) => const YesNoDialog(
                                    title: 'Cancel Request',
                                    text: 'askCancelReq'));
                            if (res == true) {
                              context.read<WithdrawRequestCubit>().cancel();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red.shade700),
                          ),
                          child: const Text('Cancel').tr(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
