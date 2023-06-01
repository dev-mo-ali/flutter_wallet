import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sun_point/logic/controllers/wallet/transaction.dart';
import 'package:sun_point/logic/models/wallet/history.dart';
import 'package:sun_point/logic/models/wallet/transaction.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/ui/widgets/yes_no_dialog.dart';
import 'package:sun_point/utils/routes.dart';

class TransactionArgs {
  int id;

  TransactionArgs({
    required this.id,
  });
}

class TransactionPage extends StatelessWidget {
  final TransactionArgs args;
  TransactionPage({super.key, required this.args});

  final DateFormat formater = DateFormat('dd/MM/yyyy H:m a');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit(args.id),
      child: Scaffold(
        appBar: AppBar(title: const Text('Transaction').tr()),
        body: MultiBlocListener(
          listeners: [
            BlocListener<TransactionCubit, TransactionState>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) => Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.home, (route) => false),
            ),
            BlocListener<TransactionCubit, TransactionState>(
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
          child: BlocBuilder<TransactionCubit, TransactionState>(
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
                              .read<TransactionCubit>()
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
                                    case HistoryState.STATUS_COMPLETED:
                                      return Text(
                                        'Transaction Completed',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontSize: 15,
                                                color: Colors
                                                    .greenAccent.shade700),
                                      ).tr();

                                    case HistoryState.STATUS_PENDING:
                                      return Text(
                                        'Transaction Pending',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontSize: 15,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ).tr();

                                    case HistoryState.STATUS_CANCELLED:
                                      return Text(
                                        'Transaction Cancelled',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontSize: 15,
                                                color: Colors.red.shade700),
                                      ).tr();

                                    case HistoryState.STATUS_REJECTED:
                                      return Text(
                                        'Transaction Rejected',
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
                                  'Transaction Type',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ).tr(),
                                Text(
                                  state.data!['type'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 15),
                                ).tr(),
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
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Transaction Ref.',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ).tr(),
                                Text(
                                  state.data!['ref'],
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
                  BlocBuilder<TransactionCubit, TransactionState>(
                    buildWhen: (previous, current) =>
                        previous.done != current.done,
                    builder: (context, state) {
                      if (state.data!['status'] ==
                              HistoryState.STATUS_PENDING &&
                          !state.done) {
                        switch (state.data!['service_type']) {
                          case HistoryState.SERVICE_TYPE_TOPUP:
                            return ElevatedButton(
                              onPressed: () async {
                                bool? res = await showDialog(
                                    context: context,
                                    builder: (_) => const YesNoDialog(
                                        title: 'Cancel Request',
                                        text: 'askCancelReq'));
                                if (res == true) {
                                  context
                                      .read<TransactionCubit>()
                                      .cancelTopUpRequest();
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.red.shade700),
                              ),
                              child: const Text('Cancel').tr(),
                            );
                          case HistoryState.SERVICE_TYPE_WITHDRAW:
                            return ElevatedButton(
                              onPressed: () async {
                                bool? res = await showDialog(
                                    context: context,
                                    builder: (_) => const YesNoDialog(
                                        title: 'Cancel Request',
                                        text: 'askCancelReq'));
                                if (res == true) {
                                  context
                                      .read<TransactionCubit>()
                                      .cancelWithdrawRequest();
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.red.shade700),
                              ),
                              child: const Text('Cancel').tr(),
                            );
                        }
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    height: 64,
                    child:
                        BlocSelector<TransactionCubit, TransactionState, bool>(
                      selector: (state) => state.submitting,
                      builder: (context, state) {
                        return state
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox();
                      },
                    ),
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
