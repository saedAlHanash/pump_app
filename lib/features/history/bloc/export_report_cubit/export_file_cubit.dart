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
import 'package:pump_app/main.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/strings/app_string_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';

part 'export_file_state.dart';

class ExportReportCubit extends Cubit<ExportReportInitial> {
  ExportReportCubit() : super(ExportReportInitial.initial());

  Future<void> saveFile(String? name) async {
    var directory = await getDownloadsDirectory();

    final filePathsBox = await Hive.openBox<String>(AppStringManager.filePathsBox);

    var fName = name ?? 'report${filePathsBox.length}';

    if (await File(join('${directory!.path}/$fName.xlsx')).exists()) {
      //loggerObject.w('true');
      fName = '$fName${filePathsBox.length}';
    }

    state.excel.delete('Sheet1');

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

  void exportForDb({
    required List<HistoryModel> list,
  }) async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();

    //تجميع الاستمارات بشكل منفصل
    final ll = list
        .groupListsBy<String>((e) => e.list.firstOrNull?.firstOrNull?.assessmentNu ?? '-')
        .values
        .toList();

    for (var e in ll) {
      s1(list: e);
    }

    await saveFile(
        'تقرير محاطات الضخ لقواعد المعطيات ${DateTime.now().formatDateTimeFileName}');
  }

  void exportForReview({
    required List<HistoryModel> list,
  }) async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();

    //تجميع الاستمارات بشكل منفصل
    final ll = list
        .groupListsBy<String>((e) => e.list.firstOrNull?.firstOrNull?.assessmentNu ?? '-')
        .values
        .toList();

    for (var e in ll) {
      s11(list: e);
    }

    await saveFile('تقرير محاطات الضخ للمراجعة ${DateTime.now().formatDateTimeFileName}');
  }

  void s1({
    required List<HistoryModel> list,
  }) {
    //توليد
    final uuID = const Uuid().v4();
    //توليد صفحة باسم الاستمارة
    final sheetName = list.first.list.firstOrNull?.firstOrNull?.assessmentNu ?? uuID;
    final sheet = state.getSheet(sheetName);
    //جلب جميع معرفات الأسئلة مع مواقعهم في القائمة
    final qIdHeaderAndIndex = getQIds(list);
    //توليد ترويسة الصفحة
    final headerList =
        List<CellValue>.from(qIdHeaderAndIndex.keys.map((e) => TextCellValue(e)))
          ..insert(0, const TextCellValue('UUID'));

    sheet.appendRow(headerList);
    for (var e in list) {
      s2(
        sheet: sheet,
        list: e.list.singleList,
        qIdHeaderAndIndex: qIdHeaderAndIndex,
      );
    }
  }

  void s2({
    required List<Questions> list,
    Sheet? sheet,
    required Map<String, int> qIdHeaderAndIndex,
  }) {
    final uuID = const Uuid().v4();

    // توليد القائمة المؤقتة بقيم فارغة
    final emptyList = List.generate(
      qIdHeaderAndIndex.length,
      (_) => const TextCellValue(''),
    );

    // تعبئة القيم في القائمة المؤقتة
    for (var e in list) {
      //اذا كان جواب لسؤال
      if (e.qstType.isQ && e.answer != null && e.tableNumber.isEmpty) {
        emptyList[(qIdHeaderAndIndex[e.qstId]) ?? 0] =
            TextCellValue(e.answer?.answer ?? '-');
      }
      // اذا كان جدول
      else if (e.qstType == QType.table &&
          e.answer != null &&
          e.answer!.answers.isNotEmpty) {
        s3(
          list: e.answer!.answers,
          tableId: e.tableNumber,
          uuID: uuID,
        );
      }
    }
    sheet?.appendRow(emptyList..insert(0, TextCellValue(uuID)));
  }

  void s3({
    required List<List<Questions>> list,
    required String uuID,
    required String tableId,
  }) {
    final sheetName = list.first.firstOrNull?.assessmentNu ?? uuID;
    final sheet = state.getSheet('${sheetName}table$tableId');

    if (sheet.rows.firstOrNull?.firstOrNull?.value == null) {
      sheet.appendRow([const TextCellValue('UUID')]);
    }

    final header = List<String>.from(
        (sheet.rows.firstOrNull ?? []).map((e) => e?.value.toString() ?? ''))
      ..removeWhere((element) => element.isEmpty);

    for (var e1 in list) {
      // توليد القائمة المؤقتة بقيم فارغة
      final emptyList =
          List.generate(header.length, (_) => TextCellValue(_ == 0 ? uuID : ''));

      for (var e in e1) {
        if (e.qstType.isQ && e.answer != null) {
          var i = getIndexFromHeaderList(header, e.qstId);
          if (i == null) {
            header.add(e.qstId);
            emptyList.add(TextCellValue(e.answer?.answer ?? '-'));
            sheet.updateCell(
                CellIndex.indexByColumnRow(columnIndex: header.length - 1, rowIndex: 0),
                TextCellValue(e.qstId));
          } else {
            emptyList[i] = TextCellValue(e.answer?.answer ?? '-');
          }
        } else if (e.qstType == QType.table && e.answer != null) {}
      }
      sheet.appendRow(emptyList);
    }
  }

  void s11({
    required List<HistoryModel> list,
  }) {
    //توليد
    final uuID = const Uuid().v4();
    //توليد صفحة باسم الاستمارة
    final sheetName = list.first.list.firstOrNull?.firstOrNull?.getSheetName ?? uuID;
    final sheet = state.getSheet(sheetName);
    //جلب جميع معرفات الأسئلة مع مواقعهم في القائمة
    final qIdHeaderAndIndex = getNames(list);
    //توليد ترويسة الصفحة
    final headerList =
        List<CellValue>.from(qIdHeaderAndIndex.keys.map((e) => TextCellValue(e)))
          ..insert(0, const TextCellValue('UUID'));

    sheet.appendRow(headerList);
    for (var e in list) {
      s22(
        sheet: sheet,
        list: e.list.singleList,
        qIdHeaderAndIndex: qIdHeaderAndIndex,
      );
    }
  }

  void s22({
    required List<Questions> list,
    Sheet? sheet,
    required Map<String, int> qIdHeaderAndIndex,
  }) {
    final uuID = const Uuid().v4();

    // توليد القائمة المؤقتة بقيم فارغة
    final emptyList = List.generate(
      qIdHeaderAndIndex.length,
      (_) => const TextCellValue(''),
    );

    // تعبئة القيم في القائمة المؤقتة
    for (var e in list) {
      //اذا كان جواب لسؤال
      if (e.qstType.isQ && e.answer != null && e.tableNumber.isEmpty) {
        emptyList[(qIdHeaderAndIndex[e.qstLabel]) ?? 0] =
            TextCellValue('\t\t\t ${e.answer?.name ?? ' - '}\t\t\t ');
      }
      // اذا كان جدول
      else if (e.qstType == QType.table &&
          e.answer != null &&
          e.answer!.answers.isNotEmpty) {
        s33(
          list: e.answer!.answers,
          tableId: e.tableNumber,
          uuID: uuID,
        );
      }
    }
    sheet?.appendRow(emptyList..insert(0, TextCellValue(uuID)));
  }

  void s33({
    required List<List<Questions>> list,
    required String uuID,
    required String tableId,
  }) {
    final sheetName = list.first.firstOrNull?.assessmentNu ?? uuID;
    final sheet = state.getSheet('${sheetName}table$tableId');
    if (sheet.rows.firstOrNull?.firstOrNull?.value == null) {
      sheet.appendRow([const TextCellValue('UUID')]);
    }

    final header = List<String>.from(
        (sheet.rows.firstOrNull ?? []).map((e) => e?.value.toString() ?? ''))
      ..removeWhere((element) => element.isEmpty);

    for (var e1 in list) {
      // توليد القائمة المؤقتة بقيم فارغة
      final emptyList =
          List.generate(header.length, (_) => TextCellValue(_ == 0 ? uuID : ''));

      for (var e in e1) {
        if (e.qstType.isQ && e.answer != null) {
          var i = getIndexFromHeaderList(header, e.qstLabel);
          if (i == null) {
            header.add(e.qstLabel);
            emptyList.add(TextCellValue('\t\t\t ${e.answer?.name ?? ' - '}\t\t\t '));
            sheet.updateCell(
                CellIndex.indexByColumnRow(columnIndex: header.length - 1, rowIndex: 0),
                TextCellValue(e.qstLabel));
          } else {
            emptyList[i] = TextCellValue(e.answer?.name ?? '-');
          }
        } else if (e.qstType == QType.table && e.answer != null) {}
      }
      sheet.appendRow(emptyList);
    }
  }

  int? getIndexFromHeaderList(List<String> headers, String qId) {
    var i = 0;
    for (var e in headers) {
      if (e == qId) return i;
      i = i + 1;
    }
    return null;
  }

  //------------helper-----------

  Map<String, int> getQIds(List<HistoryModel> l) {
    final m = <String, int>{};
    l.forEachIndexed(
      (i, assessment) {
        assessment.list.singleList.forEachIndexed((i, answer) {
          //سؤال وليس سؤال ضمن جدول
          if (answer.qstType.isQ && answer.tableNumber.isEmpty) {
            if (m[answer.qstId] == null) m[answer.qstId] = m.length;
          }
        });
      },
    );

    return m;
  }

  Map<String, int> getNames(List<HistoryModel> l) {
    final m = <String, int>{};
    l.forEachIndexed(
      (i, assessment) {
        assessment.list.singleList.forEachIndexed((i, answer) {
          //سؤال وليس سؤال ضمن جدول
          if (answer.qstType.isQ && answer.tableNumber.isEmpty) {
            if (m[answer.qstLabel] == null) m[answer.qstLabel] = m.length;
          }
        });
      },
    );

    return m;
  }
}
