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

  Future<void> getAllForm() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    final box = await Hive.openBox<String>(AppStringManager.formTable);

    final list = box.values.map((e) => e.getQ).toList()
      ..sort((a, b) => a.sequenceNo.compareTo(b.sequenceNo));

    final mapGropingAsFormId = list.groupListsBy<String>((e) => e.assessmentNu)
      ..removeWhere((key, value) => key.isEmpty);

    emit(state.copyWith(
      statuses: CubitStatuses.done,
      allFormes: mapGropingAsFormId,
    ));
    box.close();
  }

  Future<void> getQuestionsForm({required String assessmentId}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    final mapGropingAsPageNumber =
        state.allFormes[assessmentId]?.groupListsBy<String>((e) => e.pageNu) ?? {};

    final gropingList = <List<Questions>>[];

    mapGropingAsPageNumber.forEach((key, value) {
      gropingList.add(value.map((e) => e.copyWith()).toList()
        ..sort((a, b) => a.sequenceNo.compareTo(b.sequenceNo)));
    });

    emit(
      state.copyWith(statuses: CubitStatuses.done, result: gropingList),
    );
  }

  Questions? getRelated({required String rListQstId}) {
    for (var e in state.result) {
      for (var e1 in e) {
        if (e1.qstId == rListQstId) return e1;
      }
    }
    return null;
  }

  void _clearRelated({required String qId}) {
    for (var e1 in state.result) {
      for (var e in e1) {
        if (e.rListQstId == qId) {
          e.answer = null;
          _clearRelated(qId: e.qstId);
        }
      }
    }
  }

  void clearRelated({required String qId}) {
    _clearRelated(qId: qId);
    emit(state.copyWith(statuses: CubitStatuses.done));
  }

  String isComplete(int i) {
    for (var e in state.result[i]) {
      if (!e.isRequired) continue;
      if (e.answer == null || e.answer!.name.isEmpty) return 'يرجى إكمال ${e.qstLabel}';
    }
    return '';
  }
}
