import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/features/db/models/app_specification.dart';
import 'package:pump_app/features/history/data/history_model.dart';
import 'package:pump_app/features/history/data/history_model.dart';
import 'package:pump_app/main.dart';

import '../../../../core/strings/app_string_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';

part 'get_history_state.dart';

class GetHistoryCubit extends Cubit<GetHistoryInitial> {
  GetHistoryCubit() : super(GetHistoryInitial.initial());

  Future<void> getAllHistory() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    final box = await Hive.openBox<String>(AppStringManager.answerBox);

    final list = box.values.map((e) => HistoryModel.fromJson(jsonDecode(e))).toList();

    emit(state.copyWith(statuses: CubitStatuses.done, result: list));

    await   box.close();
  }

  Map<String, int> getQIds() {
    final m = <String, int>{};
    state.result.forEachIndexed(
      (index, assessment) {
        assessment.list.singleList.forEachIndexed((i, answer) {
          if (m[answer.qstId] == null) m[answer.qstId] = m.length;
        });
      },
    );

    return m;
  }

  void deleteItem(int i) async {
    final box = await Hive.openBox<String>(AppStringManager.answerBox);
    box.deleteAt(i);
    state.result.removeAt(i);
    emit(state.copyWith());
  }
}
