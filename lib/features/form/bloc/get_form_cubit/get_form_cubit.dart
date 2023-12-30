import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/features/db/models/app_specification.dart';
import 'package:pump_app/features/db/models/item_model.dart';

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

    mapGropingAsFormId.removeWhere((key, value) => value.isEmpty);

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

    mapGropingAsPageNumber.removeWhere((key, value) => value.isEmpty);

    mapGropingAsPageNumber.forEach((key, value) {
      gropingList.add(value.map((e) => e.copyWith()).toList()
        ..sort((a, b) => a.sequenceNo.compareTo(b.sequenceNo)));
    });
    hideVisible(gropingList);

    emit(
      state.copyWith(statuses: CubitStatuses.done, result: gropingList),
    );
  }

  Future<void> setQuestionsFromHistory({required List<List<Questions>> list}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    Future.delayed(
      const Duration(seconds: 1),
      () {
        emit(
          state.copyWith(statuses: CubitStatuses.done, result: list),
        );
      },
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

  void hideVisible(List<List<Questions>> gropingList) {
    final singleList = gropingList.expand((questionsList) => questionsList).toList();
    for (var e in singleList.where((element) => element.relatedAnswer.isNotEmpty)) {
      for (var e1 in singleList) {
        if (e1.qstId != e.relatedAnswer) continue;
        e1.isVisible = false;
        break;
      }
    }
  }

  bool updateShowRelatedAnswer(Questions q) {
    if (!q.needUpdateRelatedQst) return false;

    final singleList = state.result.expand((questionsList) => questionsList).toList();

    for (var e in singleList) {
      if (e.qstId != q.relatedAnswer) continue;

      e.isVisible = q.valueAnswer == q.answer?.answer;
      if (!e.isVisible) e.answer = null;

      updateShowRelatedAnswer(e);

      return true;
    }

    return false;
  }

  void setAnswer(
    Questions q, {
    ItemModel? answer,
    String? sAnswer,
    List<Questions>? answers,
  }) {
    if (q.answer == null) {
      q.answer ??= answer ?? ItemModel.fromJson({'1': sAnswer});
    } else {
      if (answer != null) q.answer = answer;
      if (sAnswer != null) q.answer!.answer = sAnswer;
      if (answers != null) q.answer!.answers.add(answers);
    }

    if (q.qstType == QType.list || q.qstType == QType.rList) clearRelated(qId: q.qstId);

    var needEmit = updateShowRelatedAnswer(q);

    if (needEmit) emit(state.copyWith(statuses: CubitStatuses.done));
  }

  String isComplete(int i) {
    for (var e in state.result[i]) {
      if (!e.isRequired) continue;
      if ((e.answer == null || e.answer!.answer.isEmpty) &&
          e.isVisible &&
          e.tableNumber.isEmpty) {
        return 'يرجى إكمال ${e.qstLabel}';
      }
    }
    return '';
  }
}
