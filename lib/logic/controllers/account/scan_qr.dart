import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/account/scan_qr.dart';
import 'package:sun_point/logic/providers/account.dart';
import 'package:sun_point/server/response.dart';

class ScanQrCubit extends Cubit<ScanQrState> {
  ScanQrCubit() : super(ScanQrState());

  void getUser(String qr) async {
    if (!state.loading && state.data == null) {
      emit(state.copyWith(loading: true));

      ServerResponse response = await AccountAPI.getUserByQr(qr);
      if (response.isSuccess) {
        emit(state.copyWith(loading: false, data: response.data, error: ''));
      } else {
        emit(state.copyWith(loading: false, error: response.code.code));
        emit(state.copyWith(error: ''));
      }
    }
  }
}
