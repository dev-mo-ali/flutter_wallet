import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sun_point/logic/controllers/wallet/topup_request.dart';

import 'package:sun_point/logic/models/wallet/topup_request.dart';
import 'package:sun_point/logic/models/wallet/topup_requests.dart';
import 'package:sun_point/ui/widgets/erro_dialog.dart';
import 'package:sun_point/ui/widgets/yes_no_dialog.dart';

class TopupRequestArgs {
  int id;

  TopupRequestArgs({
    required this.id,
  });
}

class TopupRequestPage extends StatelessWidget {
  final TopupRequestArgs args;
  TopupRequestPage({super.key, required this.args});

  final DateFormat formater = DateFormat('dd/MM/yyyy H:m a');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopupRequestCubit(args.id),
      child: Scaffold(
        appBar: AppBar(title: const Text('Topup.').tr()),
        body: MultiBlocListener(
          listeners: [
            BlocListener<TopupRequestCubit, TopupRequestState>(
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
          child: BlocBuilder<TopupRequestCubit, TopupRequestState>(
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
                              .read<TopupRequestCubit>()
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
                                BlocSelector<TopupRequestCubit,
                                        TopupRequestState, String>(
                                    selector: (state) => state.status!,
                                    builder: (context, state) {
                                      switch (state) {
                                        case TopupRequestsState.STATUS_APPROVED:
                                        case TopupRequestsState
                                              .STATUS_COMPLETED:
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

                                        case TopupRequestsState.STATUS_PENDING:
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

                                        case TopupRequestsState
                                              .STATUS_CANCELLED:
                                          return Text(
                                            'Cancelled',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                    fontSize: 15,
                                                    color: Colors.red.shade700),
                                          ).tr();

                                        case TopupRequestsState.STATUS_REJECTED:
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
                  BlocBuilder<TopupRequestCubit, TopupRequestState>(
                    buildWhen: (previous, current) =>
                        previous.submitting != current.submitting,
                    builder: (context, state) {
                      if (state.submitting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Visibility(
                        visible:
                            state.status == TopupRequestsState.STATUS_PENDING,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool? res = await showDialog(
                                context: context,
                                builder: (_) => const YesNoDialog(
                                    title: 'Cancel Request',
                                    text: 'askCancelReq'));
                            if (res == true) {
                              context.read<TopupRequestCubit>().cancel();
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
