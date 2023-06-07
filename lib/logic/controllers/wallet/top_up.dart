import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/wallet/top_up.dart';
import 'package:sun_point/logic/providers/wallet.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/validators.dart';

class TopUpCubit extends Cubit<TopUpState> {
  TopUpCubit() : super(TopUpState());
  String amount = '';
  void setIsVoucher(bool value) {
    emit(state.copyWith(isVoucher: value, amount: 0));
  }

  void getAmount(String amount) async {
    this.amount = amount;
    if (amountValidator(amount) != null) {
      emit(state.copyWith(amount: 0, loadingAmount: false));
      return;
    }
    emit(state.copyWith(loadingAmount: true));

    ServerResponse response =
        await WalletAPI.getEstimatedTopupPoints(double.parse(amount));
    if (response.isSuccess) {
      if (amount == this.amount) {
        emit(state.copyWith(
            loadingAmount: false,
            amount: response.data['estimated_topup_points'].toDouble(),
            error: ''));
      }
    } else {
      emit(state.copyWith(loadingAmount: false, error: response.code.code));
      emit(state.copyWith(error: ''));
    }
  }

  void submit(String amountStr, String voucherCode) async {
    if (!state.loading) {
      emit(state.copyWith(loading: true));
      double? amount = double.tryParse(amountStr);
      if (state.isVoucher) {
        ServerResponse rs = await WalletAPI.topUpCheckVoucher(voucherCode);
        print(rs.response.body);
        if (rs.isSuccess) {
          amount = rs.data['amount'];
        } else {
          emit(state.copyWith(loading: false, error: rs.code.code));
          emit(state.copyWith(error: ''));
          return;
        }
      }

      ServerResponse response =
          await WalletAPI.topUp(amount, state.isVoucher, voucherCode);
      if (response.isSuccess) {
        emit(state.copyWith(
            done: true, amount: amount, loading: false, error: ''));
      } else {
        emit(state.copyWith(loading: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
