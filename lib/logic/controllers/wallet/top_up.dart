import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/wallet/top_up.dart';
import 'package:sun_point/logic/providers/wallet.dart';
import 'package:sun_point/server/response.dart';
import 'package:sun_point/utils/validators.dart';

class TopUpCubit extends Cubit<TopUpState> {
  TopUpCubit() : super(TopUpState()) {
    load().then((value) => null);
  }
  String amount = '';
  void setIsVoucher(bool value) {
    emit(state.copyWith(isVoucher: value, amount: 0));
  }

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    ServerResponse response = await WalletAPI.getTopUpConfig();
    if (response.isSuccess) {
      emit(state.copyWith(loading: false, config: response.data));
    } else {
      emit(state.copyWith(loading: false));
      emit(state.copyWith(error: ''));
    }
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
    if (!state.submitting) {
      emit(state.copyWith(submitting: true));
      double? amount = double.tryParse(amountStr);
      if (state.isVoucher) {
        ServerResponse rs = await WalletAPI.topUpCheckVoucher(voucherCode);
        print(rs.response.body);
        if (rs.isSuccess) {
          amount = rs.data['amount'];
        } else {
          emit(state.copyWith(submitting: false, error: rs.code.code));
          emit(state.copyWith(error: ''));
          return;
        }
      }

      ServerResponse response =
          await WalletAPI.topUp(amount, state.isVoucher, voucherCode);
      if (response.isSuccess) {
        emit(state.copyWith(
            done: true, amount: amount, submitting: false, error: ''));
      } else {
        emit(state.copyWith(submitting: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
