import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/wallet/transaction.dart';

import 'package:sun_point/logic/providers/wallet.dart';
import 'package:sun_point/server/response.dart';

class TransactionCubit extends Cubit<TransactionState> {
  int id;
  TransactionCubit(this.id) : super(TransactionState()) {
    load().then((value) => null);
  }
// load the transaction data
  Future<void> load() async {
    emit(state.copyWith(loading: true));
    ServerResponse response = await WalletAPI.getTransaction(id);
    if (response.isSuccess) {
      emit(state.copyWith(loading: false, data: response.data));
    } else {
      emit(state.copyWith(loading: false));
    }
  }

  void cancelTopUpRequest() async {
    emit(state.copyWith(submitting: true));
    // send http request
    ServerResponse response =
        await WalletAPI.cancelTopupRequest(state.data!['ref']);
    if (response.isSuccess) {
      emit(state.copyWith(submitting: false, done: true, error: ''));
    } else {
      emit(state.copyWith(submitting: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }

  void cancelWithdrawRequest() async {
    emit(state.copyWith(submitting: true));
    // send http request
    ServerResponse response =
        await WalletAPI.cancelWithdrawalRequest(state.data!['ref']);
    if (response.isSuccess) {
      emit(state.copyWith(submitting: false, done: true, error: ''));
    } else {
      emit(state.copyWith(submitting: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }
}
