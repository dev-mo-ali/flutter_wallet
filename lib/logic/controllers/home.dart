import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/home.dart';
import 'package:sun_point/logic/providers/utilis.dart';
import 'package:sun_point/server/response.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState()) {
    load().then((value) => null);
  }
  Future<void> load() async {
    emit(state.copyWith(loading: true));
    List<ServerResponse> requests =
        await Future.wait([GeneralAPI.getPromotions()]);
    if (requests.every((request) => request.isSuccess)) {
      emit(state.copyWith(
          loading: false, loaded: true, promotions: requests[0].data));
    } else {
      emit(state.copyWith(loading: false));
    }
  }
}
