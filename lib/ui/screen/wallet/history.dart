import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/wallet/history.dart';
import 'package:sun_point/logic/models/wallet/history.dart';
import 'package:sun_point/ui/screen/drawer_page.dart';
import 'package:sun_point/ui/screen/wallet/transaction.dart';
import 'package:sun_point/ui/widgets/side_bar_header.dart';
import 'package:sun_point/utils/routes.dart';
import 'package:sun_point/utils/ui/constant.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  ScrollController genController(HistoryCubit cubit) {
    ScrollController controller = ScrollController();

    controller.addListener(() {
      if (!controller.position.outOfRange &&
          controller.offset >= controller.position.maxScrollExtent &&
          !cubit.state.loading &&
          !cubit.state.isEnd) {
        cubit.loadTransactions().then((value) => null);
      }
    });

    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(),
      child: DrawerPage(
        current: Routes.history,
        child: Column(
          children: [
            const SideBarHeader(),
            Expanded(
              child: BlocBuilder<HistoryCubit, HistoryState>(
                buildWhen: (previous, current) =>
                    previous.loading != current.loading && !previous.loaded,
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!state.loaded && !state.loading) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Error occurred.",
                            style: Theme.of(context)
                                .inputDecorationTheme
                                .errorStyle,
                            textAlign: TextAlign.center,
                          ).tr(),
                          const SizedBox(
                            height: 16,
                          ),
                          TextButton(
                              onPressed: () => context
                                  .read<HistoryCubit>()
                                  .load()
                                  .then((value) => null),
                              child: const Text('Retry').tr())
                        ],
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    controller: genController(context.read<HistoryCubit>()),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Text(
                                'Account Balance',
                                style: Theme.of(context).textTheme.labelLarge,
                              ).tr(),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                state.balance.toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        BlocSelector<HistoryCubit, HistoryState, List>(
                          selector: (state) => state.history,
                          builder: (context, state) {
                            if (state.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Center(
                                    child: Text(
                                  'No items was found',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ).tr()),
                              );
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: state.map((e) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: InkWell(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(Routes.transaction,
                                              arguments:
                                                  TransactionArgs(id: e['id'])),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    e['type'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                  ).tr(),
                                                  Builder(builder: (context) {
                                                    switch (e['status']) {
                                                      case HistoryState
                                                            .STATUS_COMPLETED:
                                                        return Text(
                                                          'Completed',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .greenAccent
                                                                .shade700,
                                                          ),
                                                        ).tr();

                                                      case HistoryState
                                                            .STATUS_PENDING:
                                                        return Text(
                                                          'Pending',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary),
                                                        ).tr();

                                                      case HistoryState
                                                            .STATUS_CANCELLED:
                                                        return Text(
                                                          'Cancelled',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .red.shade700,
                                                          ),
                                                        ).tr();

                                                      case HistoryState
                                                            .STATUS_REJECTED:
                                                        return Text(
                                                          'Rejected',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .red.shade700,
                                                          ),
                                                        ).tr();
                                                    }
                                                    return const SizedBox();
                                                  }),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    dateFormat.format(
                                                        DateTime.parse(e[
                                                                'updated_at'] ??
                                                            e['created_at'])),
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    '${e['amount']}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        BlocSelector<HistoryCubit, HistoryState, bool>(
                          selector: (state) {
                            return state.loading;
                          },
                          builder: (context, state) {
                            return Visibility(
                              visible: state,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
