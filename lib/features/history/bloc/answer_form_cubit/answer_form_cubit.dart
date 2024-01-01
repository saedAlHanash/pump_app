import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/features/db/models/app_specification.dart';

import '../../../../core/strings/app_string_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';

part 'answer_form_state.dart';

class AnswerFormCubit extends Cubit<AnswerFormInitial> {
  AnswerFormCubit() : super(AnswerFormInitial.initial());

  Future<void> getQuestionsForm() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    final box = await Hive.openBox<String>(AppStringManager.formTable);

    final list = box.values
        .map(
          (e) {

            return e.getQ;
          },
        )
        .toList();

    emit(state.copyWith(statuses: CubitStatuses.done, result: list));
   await box.close();
  }
}
