import 'package:bloc/bloc.dart';

import 'package:sun_point/logic/models/wallet/withdraw_requests.dart';
import 'package:sun_point/logic/providers/wallet.dart';
import 'package:sun_point/server/response.dart';

class WithdrawRequestsCubit extends Cubit<WithdrawRequestsState> {
  WithdrawRequestsCubit() : super(WithdrawRequestsState()) {
    load().then((value) => null);
  }

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    ServerResponse response = await WalletAPI.getWithdrawRequests(state.page);
    if (response.isSuccess) {
      List data = [...state.requests, ...response.data['data']];
      emit(state.copyWith(
        requests: data,
        loading: false,
        page: state.page + 1,
        loaded: true,
        pageCount: response.data['last_page'],
      ));
    } else {
      emit(state.copyWith(loading: false));
    }
  }
}
