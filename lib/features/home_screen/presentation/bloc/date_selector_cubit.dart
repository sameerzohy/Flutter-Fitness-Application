import 'package:flutter_bloc/flutter_bloc.dart';

class DateSelectorCubit extends Cubit<DateTime> {
  DateSelectorCubit() : super(DateTime.now());
  void setDate(DateTime date) {
    emit(date);
  }
}
