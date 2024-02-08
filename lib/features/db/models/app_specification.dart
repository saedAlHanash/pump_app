import 'package:excel/excel.dart' as excel;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/strings/enum_manager.dart';
import 'package:pump_app/features/db/models/item_model.dart';
import 'package:pump_app/features/form/ui/widget/date_widget.dart';
import 'package:pump_app/features/form/ui/widget/header_widget.dart';
import 'package:pump_app/features/form/ui/widget/list_string_widget.dart';
import 'package:pump_app/features/form/ui/widget/list_widget.dart';
import 'package:pump_app/features/form/ui/widget/number_widget.dart';
import 'package:pump_app/features/form/ui/widget/r_list_widget.dart';
import 'package:pump_app/features/history/ui/widget/table_answer_widget.dart';

import '../../form/ui/widget/string_widget.dart';
import '../../form/ui/widget/table_widget.dart';
import '../../history/ui/widget/list_answer_widget.dart';
import '../../history/ui/widget/string_answer_widget.dart';

class Questions {
  Questions({
    required this.assessmentNu,
    required this.assessmentDate,
    required this.assessmentName,
    required this.pageNu,
    required this.sequenceNo,
    required this.qstId,
    required this.qstLabel,
    required this.qstType,
    required this.qstDatasource,
    required this.rListQstId,
    required this.tableNumber,
    required this.isRequired,
    required this.relatedAnswer,
    required this.valueAnswer,
    required this.isVisible,
    required this.min,
    required this.max,
    required this.helpLink,
    required this.equalTo,
    this.answer,
  });

  final String assessmentNu;
  final DateTime? assessmentDate;
  final String assessmentName;
  final String pageNu;
  final int sequenceNo;
  final String qstId;
  final String qstLabel;
  final QType qstType;
  final String qstDatasource;
  final String rListQstId;
  final String tableNumber;
  final bool isRequired;
  final List<String> relatedAnswer;
  final String valueAnswer;
  final dynamic min;
  final dynamic max;
  final String helpLink;
  final String equalTo;
  ItemModel? answer;

  bool isVisible = true;

  bool get needUpdateRelatedQst => relatedAnswer.isNotEmpty;

  String get sMin => min is DateTime ? (min as DateTime).formatDate : min.toString();

  String get sMax => max is DateTime ? (max as DateTime).formatDate : max.toString();

  String get getSheetName {
    List<String> charactersToRemove = ["/", "\\", "*", "[", "]"];

    String pattern = charactersToRemove.map((char) => "\\$char").join("|");

    return assessmentName.replaceAll(RegExp(pattern), '_').splitByLength1(31).first;
  }

  Widget get getWidget {
    if (tableNumber.isNotEmpty && qstType != QType.table || equalTo.isNotEmpty) {
      return 0.0.verticalSpace;
    }

    if (!isVisible) {
      return 0.0.verticalSpace;
    }

    switch (qstType) {
      case QType.list:
        return ListWidget(q: this);
      case QType.rList:
        return RListWidget(q: this);
      case QType.string:
        return StringWidget(q: this);
      case QType.lString:
        return ListStringWidget(q: this);
      case QType.date:
        return DateWidget(q: this);
      case QType.number:
        return NumberWidget(q: this);
      case QType.mCheckbox:
        return 0.0.verticalSpace;
      case QType.table:
        return TableWidget(q: this);
      case QType.header:
        return HeaderWidget(q: this);
    }
  }

  Widget get getTableWidget {
    if (equalTo.isNotEmpty) return 0.0.verticalSpace;
    switch (qstType) {
      case QType.list:
        return ListWidget(q: this);
      case QType.rList:
        return RListWidget(q: this);
      case QType.string:
        return StringWidget(q: this);
      case QType.lString:
        return ListStringWidget(q: this);
      case QType.date:
        return DateWidget(q: this);
      case QType.number:
        return NumberWidget(q: this);
      case QType.mCheckbox:
        return 0.0.verticalSpace;
      case QType.table:
        return TableWidget(q: this);
      case QType.header:
        return HeaderWidget(q: this);
    }
  }

  Widget get getTableAnswerWidget {
    if (equalTo.isNotEmpty) return 0.0.verticalSpace;
    switch (qstType) {
      case QType.list:
      case QType.rList:
        return ListAnswerWidget(q: this);
      case QType.lString:
      case QType.date:
      case QType.number:
      case QType.string:
        return StringAnswerWidget(q: this);

      case QType.mCheckbox:
        return 0.0.verticalSpace;

      case QType.table:
        return TableAnswerWidget(q: this);
      case QType.header:
        return HeaderWidget(q: this);
    }
  }

  factory Questions.fromJson(Map<String, dynamic> map) {
    var q = Questions(
      assessmentNu: map['0'] ?? '',
      assessmentDate: DateTime.tryParse(map['1'] ?? ''),
      assessmentName: map['2'] ?? '',
      pageNu: map['3'] ?? '',
      sequenceNo: int.tryParse(map['4']?.toString() ?? '0') ?? 0,
      qstId: map['5'] ?? '',
      qstLabel: map['6'] ?? '',
      qstType: QType.values[map['7'] ?? QType.header.index],
      qstDatasource: map['8'] ?? '',
      rListQstId: map['9'] ?? '',
      tableNumber: map['10'] ?? '',
      isRequired: map['11'] ?? false,
      relatedAnswer: ((map['12'] ?? '') as String).split(';')
        ..removeWhere((element) => element.isEmpty),
      valueAnswer: map['13'] ?? '',
      min: num.tryParse(map['14'] ?? '-') ?? DateTime.tryParse(map['14'] ?? '-'),
      max: num.tryParse(map['15'] ?? '-') ?? DateTime.tryParse(map['15'] ?? '-'),
      helpLink: map['16'] ?? '',
      equalTo: map['17'] ?? '',
      isVisible: map['isVisible'] ?? true,
      answer: map['answer'] == null ? null : ItemModel.fromJson(map['answer']),
    );
    return q;
  }

  factory Questions.fromData(List<excel.Data?> e) {
    return Questions.fromJson(
      {
        '0': e.getValueOrEmpty(0),
        '1': e.getValueOrEmpty(1),
        '2': e.getValueOrEmpty(2),
        '3': e.getValueOrEmpty(3),
        '4': e.getValueOrEmpty(4),
        '5': e.getValueOrEmpty(5),
        '6': e.getValueOrEmpty(6),
        '7': e.getValueOrEmpty(7).getQType.index,
        '8': e.getValueOrEmpty(8),
        '9': e.getValueOrEmpty(9),
        '10': e.getValueOrEmpty(10),
        '11': e.getValueOrEmpty(11).isNotEmpty,
        '12': e.getValueOrEmpty(12),
        '13': e.getValueOrEmpty(13),
        '14': e.getValueOrEmpty(14),
        '15': e.getValueOrEmpty(15),
        '16': e.getValueOrEmpty(16),
        '17': e.getValueOrEmpty(17),
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '0': assessmentNu,
      '1': assessmentDate?.toIso8601String(),
      '2': assessmentName,
      '3': pageNu,
      '4': sequenceNo,
      '5': qstId,
      '6': qstLabel,
      '7': qstType.index,
      '8': qstDatasource,
      '9': rListQstId,
      '10': tableNumber,
      '11': isRequired,
      '12': (relatedAnswer.join(';')),
      '13': valueAnswer,
      '14': min != null
          ? ((min is DateTime) ? (min as DateTime).toIso8601String() : min.toString())
          : null,
      '15': max != null
          ? ((max is DateTime) ? (max as DateTime).toIso8601String() : max.toString())
          : null,
      '16': helpLink,
      '17': equalTo,
      'isVisible': isVisible,
      'answer': answer?.toJson(),
    };
  }

  Questions copyWith({
    String? assessmentNu,
    DateTime? assessmentDate,
    String? assessmentName,
    String? pageNu,
    int? sequenceNo,
    String? qstId,
    String? qstLabel,
    QType? qstType,
    String? qstDatasource,
    String? rListQstId,
    String? tableNumber,
    List<String>? relatedAnswer,
    String? valueAnswer,
    dynamic min,
    dynamic max,
    String? helpLink,
    String? equalTo,
    bool? isRequired,
    bool? isVisible,
  }) {
    return Questions(
      assessmentNu: assessmentNu ?? this.assessmentNu,
      assessmentDate: assessmentDate ?? this.assessmentDate,
      assessmentName: assessmentName ?? this.assessmentName,
      pageNu: pageNu ?? this.pageNu,
      sequenceNo: sequenceNo ?? this.sequenceNo,
      qstId: qstId ?? this.qstId,
      qstLabel: qstLabel ?? this.qstLabel,
      qstType: qstType ?? this.qstType,
      qstDatasource: qstDatasource ?? this.qstDatasource,
      rListQstId: rListQstId ?? this.rListQstId,
      tableNumber: tableNumber ?? this.tableNumber,
      isRequired: isRequired ?? this.isRequired,
      relatedAnswer: relatedAnswer ?? this.relatedAnswer,
      valueAnswer: valueAnswer ?? this.valueAnswer,
      min: min ?? this.min,
      max: max ?? this.max,
      isVisible: isVisible ?? this.isVisible,
      helpLink: helpLink ?? this.helpLink,
      equalTo: equalTo ?? this.equalTo,
      answer: answer,
    );
  }
}
