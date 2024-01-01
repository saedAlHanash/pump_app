import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/features/db/models/app_specification.dart';
import 'package:pump_app/features/history/data/history_model.dart';
import 'package:pump_app/features/history/data/history_model.dart';
import 'package:pump_app/main.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/strings/app_string_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';

part 'export_file_state.dart';

class ExportReportCubit extends Cubit<ExportReportInitial> {
  ExportReportCubit() : super(ExportReportInitial.initial());

  void saveExcelFile(
      {required List<HistoryModel> list,
      required Map<String, int> m,
      String? name}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    await Permission.manageExternalStorage.request();
    await Permission.storage.request();

    _saveDataIds(m, list);

    var directory = await getDownloadsDirectory();

    final filePathsBox = await Hive.openBox<String>(AppStringManager.filePathsBox);

    var fName = name ?? 'report${filePathsBox.length}';

    if (await File(join('${directory!.path}/$fName.xlsx')).exists()) {
      loggerObject.w('true');
      fName = '$fName${filePathsBox.length}';
    }

    final file = File(join('${directory.path}/$fName.xlsx'))
      ..createSync(recursive: true)
      ..writeAsBytesSync(state.excel.save() ?? []);

    await filePathsBox.put(file.path, DateTime.now().toIso8601String());
    await filePathsBox.close();

    // Copy the file to the Downloads directory
    final downloadsFilePath = '/storage/emulated/0/Download/'
        '$fName.xlsx';

    try {
      await file.copy(downloadsFilePath);
    } on Exception catch (e) {
      loggerObject.e(e);
      emit(state.copyWith(statuses: CubitStatuses.error));
    }

    Future.delayed(
      const Duration(seconds: 1),
      () {
        emit(state.copyWith(statuses: CubitStatuses.done));
      },
    );
  }

  void _saveDataIds(Map<String, int> m, List<HistoryModel> list) {
    final headerList = List<CellValue?>.from(m.keys.map((e) => TextCellValue(e)))
      ..insert(0, const TextCellValue('UUID'));

    state.sheetObject.appendRow(headerList);
    state.sheetObjectTable.appendRow(headerList);

    final uuID = const Uuid().v4();

    ///for in all forms
    for (var e in list) {
      _saveShite(
        headerLength: m.length,
        list: e.list.singleList,
        sheet: state.sheetObject,
        m: m,
        uuID: uuID,
      );
    }
  }

  void _saveShite({
    required int headerLength,
    required List<Questions> list,
    Sheet? sheet,
    required Map<String, int> m,
    required String uuID,
  }) {
    final emptyList = List.generate(headerLength, (_) => const TextCellValue(''));

    ///put answer in on form
    for (var e in list) {
      if (e.qstType.isQ && e.answer != null) {
        emptyList[(m[e.qstId]) ?? 0] = TextCellValue(e.answer?.answer ?? '-');
      } else if (e.qstType == QType.table && e.answer != null) {
        for (var e1 in e.answer!.answers) {
          _saveShite(
            headerLength: headerLength,
            list: e1,
            sheet: state.sheetObjectTable,
            m: m,
            uuID: uuID,
          );
        }
      }
    }
    sheet?.appendRow(emptyList..insert(0, TextCellValue(uuID)));
  }
}
