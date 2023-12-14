import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/features/db/models/app_specification.dart';

import '../../../../core/strings/app_string_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';

part 'get_form_state.dart';

class GetFormCubit extends Cubit<GetFormInitial> {
  GetFormCubit() : super(GetFormInitial.initial());

  Future<void> getQuestionsForm() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    final box = await Hive.openBox<String>(AppStringManager.formTable);

    final list = box.values.map(
      (e) {
        return e.getQ;
      },
    ).toList();

    emit(state.copyWith(statuses: CubitStatuses.done, result: list));
    box.close();
  }

  Questions? getRelated({required String rListQstId}) {
    return state.result.firstWhereOrNull((e) => e.qstId == rListQstId);
  }

  void _clearRelated({required String qId}) {
    for (var e in state.result) {
      if (e.rListQstId == qId) {
        e.answer = null;
        _clearRelated(qId: e.qstId);
      }
    }
  }

  void clearRelated({required String qId}) {
    _clearRelated(qId: qId);
    emit(state.copyWith(statuses: CubitStatuses.done));
  }

  void update() {
    emit(state.copyWith(request: state.request + 1));
  }
}
