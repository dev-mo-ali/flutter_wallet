import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/wallet/user_balance.dart';
import 'package:sun_point/logic/providers/wallet.dart';
import 'package:sun_point/server/response.dart';

class UserBalanceCubit extends Cubit<UserBalanceState> {
  UserBalanceCubit() : super(UserBalanceState()) {
    load().then((value) => null);
  }
  // load the  balance and the wallet id
  Future<void> load() async {
    emit(state.copyWith(loading: true));
    ServerResponse response = await WalletAPI.getMyWallet();
    if (response.isSuccess) {
      String balance = response.data[0]['balance'].toString();
      emit(state.copyWith(balance: balance, loading: false));
    } else {
      emit(state.copyWith(loading: false));
    }
  }
}
