import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/wallet/transfer.dart';
import 'package:sun_point/logic/providers/wallet.dart';
import 'package:sun_point/server/response.dart';

class TransferCubit extends Cubit<TransferState> {
  TransferCubit() : super(TransferState()) {
    load().then((value) => null);
  }

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    ServerResponse response = await WalletAPI.getTransferConfig();
    if (response.isSuccess) {
      emit(state.copyWith(loading: false, config: response.data));
    } else {
      emit(state.copyWith(loading: false));
    }
  }

  void submit(String phone, String amount) async {
    if (!state.submitting) {
      emit(state.copyWith(submitting: true));
      ServerResponse response =
          await WalletAPI.transferCredit(phone, double.parse(amount));
      if (response.isSuccess) {
        emit(state.copyWith(done: true, submitting: false, error: ''));
      } else {
        emit(state.copyWith(submitting: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }

  void setUser(Map? user) {
    if (user != null) {
      emit(state.copyWith(fullName: user['name'], qrUsed: true));
    } else {
      emit(state.copyWith(qrUsed: false));
    }
  }
}
