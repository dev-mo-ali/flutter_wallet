import 'package:bloc/bloc.dart';
import 'package:sun_point/logic/models/auth/setup_tpin.dart';

class SetupTPINCubit extends Cubit<SetupTPINState> {
  SetupTPINCubit() : super(SetupTPINState());
  void setError(String error) => emit(state.copyWith(error: error));
}
