import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_point/logic/controllers/wallet/withdraw_requests.dart';
import 'package:sun_point/logic/models/wallet/withdraw_requests.dart';
import 'package:sun_point/ui/screen/wallet/withdraw_request.dart';
import 'package:sun_point/utils/routes.dart';

class WithdrawRequestsPage extends StatelessWidget {
  WithdrawRequestsPage({super.key});
  final DateFormat dateFormat = DateFormat('yyyy/MM/dd', 'en');
  ScrollController genController(WithdrawRequestsCubit cubit) {
    ScrollController controller = ScrollController();

    controller.addListener(() {
      if (!controller.position.outOfRange &&
          controller.offset >= controller.position.maxScrollExtent &&
          !cubit.state.loading &&
          cubit.state.page < cubit.state.pageCount) {
        cubit.load().then((value) => null);
      }
    });

    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WithdrawRequestsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Withdraw").tr(),
        ),
        body: BlocBuilder<WithdrawRequestsCubit, WithdrawRequestsState>(
          buildWhen: (previous, current) =>
              previous.loading != current.loading && !previous.loaded,
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
                            .read<WithdrawRequestsCubit>()
                            .load()
                            .then((value) => null),
                        child: const Text('Retry').tr())
                  ],
                ),
              );
            }

            return BlocSelector<WithdrawRequestsCubit, WithdrawRequestsState,
                List>(
              selector: (state) {
                return state.requests;
              },
              builder: (context, state) {
                if (state.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                        child: Text(
                      'No items was found',
                      style: Theme.of(context).textTheme.displayMedium,
                    ).tr()),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: genController(
                            context.read<WithdrawRequestsCubit>()),
                        padding: const EdgeInsets.all(16),
                        itemCount: state.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                                Routes.withdrawRequest,
                                arguments: WithdrawRequestArgs(
                                    id: state[index]['id'])),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Builder(builder: (context) {
                                      switch (state[index]['status']) {
                                        case WithdrawRequestsState
                                              .STATUS_COMPLETED:
                                          return Text(
                                            'Completed',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.greenAccent.shade700,
                                            ),
                                          ).tr();

                                        case WithdrawRequestsState
                                              .STATUS_PENDING:
                                          return Text(
                                            'Pending',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ).tr();

                                        case WithdrawRequestsState
                                              .STATUS_CANCELLED:
                                          return Text(
                                            'Cancelled',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red.shade700,
                                            ),
                                          ).tr();

                                        case WithdrawRequestsState
                                              .STATUS_REJECTED:
                                          return Text(
                                            'Rejected',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red.shade700,
                                            ),
                                          ).tr();
                                      }
                                      return const SizedBox();
                                    }),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          dateFormat.format(DateTime.parse(
                                              state[index]['updated_at'] ??
                                                  state[index]['created_at'])),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          '${state[index]['amount']}',
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
                        ),
                      ),
                    ),
                    BlocSelector<WithdrawRequestsCubit, WithdrawRequestsState,
                        bool>(
                      selector: (state) {
                        return state.loading;
                      },
                      builder: (context, state) {
                        return Center(
                          child: Visibility(
                            visible: state,
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: SizedBox.square(
                                dimension: 32,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        );
                      },
                    )
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
