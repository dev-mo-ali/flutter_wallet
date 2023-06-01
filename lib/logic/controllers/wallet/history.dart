import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/wallet/history.dart';

import 'package:sun_point/logic/providers/wallet.dart';
import 'package:sun_point/server/response.dart';

class HistoryCubit extends Cubit<HistoryState> {
  late int walletID;
  HistoryCubit() : super(HistoryState()) {
    load().then((value) => null);
  }
// load the wp balance and the wallet id
  Future<void> load() async {
    emit(state.copyWith(loading: true));
    ServerResponse response = await WalletAPI.getMyWallet();
    if (response.isSuccess) {
      String balance = response.data[0]['balance'];
      walletID = response.data[0]['id'];
      print(walletID);
      emit(state.copyWith(balance: balance));
      await loadTransactions();
    } else {
      emit(state.copyWith(loading: false));
    }
  }

// get the transactions
  Future<void> loadTransactions() async {
    emit(state.copyWith(loading: true));
    ServerResponse response =
        await WalletAPI.getTransactions(walletID, state.page);
    if (response.isSuccess) {
      // pagination

      List data = response.data['data'].toList();

      List history = [...state.history, ...data];

      emit(state.copyWith(
          loading: false,
          loaded: true,
          isEnd: data.length < 25,
          page: state.page + 1,
          history: history));
    } else {
      emit(state.copyWith(loading: false));
    }
  }
}
