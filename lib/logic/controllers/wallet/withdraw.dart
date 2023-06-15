import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/wallet/withdraw.dart';
import 'package:sun_point/logic/providers/wallet.dart';
import 'package:sun_point/server/response.dart';

class WithdrawCubit extends Cubit<WithdrawState> {
  WithdrawCubit() : super(WithdrawState()) {
    load().then((value) => null);
  }

  void selectBank(int id) => emit(state.copyWith(bankId: id));

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    List<ServerResponse> responses = await Future.wait(
        [WalletAPI.getWithdrawConfig(), WalletAPI.getBanks()]);
    if (responses.every((res) => res.isSuccess)) {
      emit(state.copyWith(
          loaded: true,
          config: responses[0].data,
          banks: responses[1].data,
          loading: false,
          error: ''));
    } else {
      emit(state.copyWith(loading: false));
    }
  }

  void submit(String amount, String accountNumber, String holderName) async {
    if (!state.submitting) {
      emit(state.copyWith(submitting: true));

      ServerResponse response = await WalletAPI.withdraw(
          double.parse(amount), state.bankId!, accountNumber, holderName);
      ;
      if (response.isSuccess) {
        emit(state.copyWith(done: true, submitting: false, error: ''));
      } else {
        emit(state.copyWith(submitting: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
