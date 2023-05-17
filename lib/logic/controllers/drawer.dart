import 'package:bloc/bloc.dart';

class DrawerCubit extends Cubit<bool> {
  DrawerCubit() : super(false);

  void openDrawer() => emit(true);
  void closeDrawer() => emit(false);
}
