import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/wallet/topup_request.dart';
import 'package:sun_point/logic/models/wallet/topup_requests.dart';
import 'package:sun_point/logic/providers/wallet.dart';
import 'package:sun_point/server/response.dart';

class TopupRequestCubit extends Cubit<TopupRequestState> {
  int id;
  TopupRequestCubit(this.id) : super(TopupRequestState()) {
    load().then((value) => null);
  }

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    ServerResponse response = await WalletAPI.getTopupRequest(id);
    if (response.isSuccess) {
      emit(state.copyWith(
          loading: false,
          data: response.data,
          status: response.data['status']));
    } else {
      emit(state.copyWith(loading: false));
    }
  }

  void cancel() async {
    if (!state.submitting) {
      emit(state.copyWith(submitting: true));

      ServerResponse response = await WalletAPI.cancelTopupRequest(id);
      print(response.response.body);
      if (response.isSuccess) {
        emit(state.copyWith(
            status: TopupRequestsState.STATUS_CANCELLED,
            submitting: false,
            error: ''));
      } else {
        emit(state.copyWith(submitting: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
