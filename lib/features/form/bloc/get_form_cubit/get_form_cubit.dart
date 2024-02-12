import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/features/db/models/app_specification.dart';
import 'package:pump_app/features/db/models/item_model.dart';

import '../../../../core/strings/app_string_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';
import '../../../../core/widgets/spinner_widget.dart';
import '../../../../generated/l10n.dart';

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

    Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(
        statuses: CubitStatuses.done,
        allFormes: mapGropingAsFormId,
      ));
    });

    await box.close();
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

    final List<String> rAnswers = [];
    final List<String> eAnswers = [];
    final List<String> rList = [];

    for (var e in gropingList.singleList) {
      if (e.rListQstId.isNotEmpty) rList.add(e.rListQstId);

      if (e.relatedAnswer.isNotEmpty) rAnswers.add(e.qstId);

      if (e.equalTo.isNotEmpty) eAnswers.add(e.equalTo);
    }

    emit(
      state.copyWith(
        statuses: CubitStatuses.done,
        result: gropingList,
        rAnswers: rAnswers,
        eAnswers: eAnswers,
        rList: rList,
      ),
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
    final singleList = gropingList.singleList;

    for (var e in singleList.where((element) => element.relatedAnswer.isNotEmpty)) {
      for (var e1 in singleList) {
        for (var e2 in e.relatedAnswer) {
          if (e1.qstId != e2) continue;
          e1.isVisible = false;
          break;
        }
      }
    }
  }

  void updateShowRelatedAnswer(Questions q) {
    _updateShowRelatedAnswer(q);
    emit(state.copyWith(statuses: CubitStatuses.done));
  }

  void _updateShowRelatedAnswer(Questions q) {
    //قائمة الأسئلة المرتبطة بهذا السؤال
    final listRelatedQ = state.result.singleList
        .where((element) => q.relatedAnswer.contains(element.qstId))
        .toList();

    for (var e in listRelatedQ) {
      e.isVisible = q.valueAnswer == q.answer?.answer;
      if (!e.isVisible) e.answer = null;
      _updateShowRelatedAnswer(e);
    }
  }

  void setAnswer(
    Questions q, {
    ItemModel? answer,
    String? sAnswer,
    List<Questions>? answers,
  }) {
    q.answer ??= answer ?? ItemModel.fromJson({'1': sAnswer, '2': sAnswer});

    if (answer != null) {
      q.answer = answer;
    }

    if (sAnswer != null) {
      q.answer!
        ..answer = sAnswer
        ..name = sAnswer;
    }

    if (answers != null) {
      q.answer!.answers.add(answers.map((e) => e.copyWith()).toList());
    }

    if (state.eAnswers.contains(q.qstId)) {
      saveEqualTo(q);
    }

    if (q.qstType.isList && state.rList.contains(q.qstId)) {
      clearRelated(qId: q.qstId);
    }

    if (state.rAnswers.contains(q.qstId)) {
      updateShowRelatedAnswer(q);
    }
  }

  String isComplete(int i) {
    for (var e in state.result[i]) {
      if (!e.isRequired || e.equalTo.isNotEmpty) continue;
      if ((e.answer == null || e.answer!.answer.isEmpty) &&
          e.isVisible &&
          e.tableNumber.isEmpty) {
        return 'يرجى إكمال ${e.qstLabel}';
      }
    }
    return '';
  }

  void saveEqualTo(Questions q) {
    _saveEqualTo(q);
    _clearTableEqualAnswerData(q);
    emit(state.copyWith(statuses: CubitStatuses.done));
  }

  void _clearTableEqualAnswerData(Questions q) {
    final tables =
        state.result.singleList.where((element) => element.qstType == QType.table);

    final list = state.result.singleList.where((e) => e.equalTo == q.qstId);
    for (var t in tables) {
      for (var q in list) {
        if (t.tableNumber == q.tableNumber) {
          t.answer?.answers.clear();
          break;
        }
      }
    }
  }

  void _saveEqualTo(Questions q) {
    final list = state.result.singleList.where((e) {
      final r = e.equalTo == q.qstId;
      return r;
    }).toList();

    for (var e in list) {
      e.answer = q.answer;
      if (state.eAnswers.contains(e.qstId)) {
        _saveEqualTo(e);
      }
    }
  }

  // void saveEqualToTable(List<Questions> list) {
  //   final allList = state.result.singleList
  //     ..where(
  //       (e) => e.tableNumber.isNotEmpty || !e.qstType.isQ,
  //     );
  //
  //   for (var e in list) {
  //     if (e.equalTo.isEmpty) return;
  //     e.answer = allList.firstWhereOrNull((e1) => e1.qstId == e.equalTo)?.answer;
  //   }
  // }

  String iTable(List<Questions> list) {
    for (var e in list) {
      if (!e.isRequired || e.equalTo.isNotEmpty) continue;
      if ((e.answer == null || e.answer!.answer.isEmpty) && e.isVisible) {
        return '${S().pleasComplete}${e.qstLabel}';
      }
    }
    return '';
  }

  List<SpinnerItem> get getAssessmentSpinnerItems {
    final list = <SpinnerItem>[];
    state.allFormes.forEach((key, value) {
      list.add(SpinnerItem(id: key, name: value.firstOrNull?.assessmentName));
    });
    return list;
  }
}
