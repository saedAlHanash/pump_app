import 'package:excel/excel.dart' as excel;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/core/strings/enum_manager.dart';
import 'package:pump_app/core/widgets/q_header_widget.dart';
import 'package:pump_app/features/db/models/item_model.dart';
import 'package:pump_app/features/form/ui/widget/date_widget.dart';
import 'package:pump_app/features/form/ui/widget/header_widget.dart';
import 'package:pump_app/features/form/ui/widget/list_string_widget.dart';
import 'package:pump_app/features/form/ui/widget/list_widget.dart';
import 'package:pump_app/features/form/ui/widget/number_widget.dart';
import 'package:pump_app/features/form/ui/widget/r_list_widget.dart';

import '../../form/ui/widget/string_widget.dart';
import '../../form/ui/widget/table_answer_widget.dart';
import '../../form/ui/widget/table_widget.dart';
import '../../form/ui/widget/yes_or_no_widget.dart';

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

  //-------

  ItemModel? answer;

  Widget get getWidget {
    if (tableNumber.isNotEmpty && qstType != QType.table) {
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
      case QType.yesOrNo:
        return YesNoWidget(q: this);
      case QType.header:
        return HeaderWidget(q: this);
    }
  }

  Widget get getTableWidget {
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
      case QType.yesOrNo:
        return YesNoWidget(q: this);
      case QType.header:
        return HeaderWidget(q: this);
    }
  }

  Widget get getTableAnswerWidget {
    switch (qstType) {
      case QType.list:
        return TableAnswerWidget(q: this);
      case QType.rList:
        return TableAnswerWidget(q: this);
      case QType.string:
        return TableAnswerWidget(q: this);
      case QType.lString:
        return TableAnswerWidget(q: this);
      case QType.date:
        return TableAnswerWidget(q: this);
      case QType.number:
        return TableAnswerWidget(q: this);
      case QType.mCheckbox:
        return 0.0.verticalSpace;
      case QType.table:
        return Column(
          children: [
            QHeaderWidget(q: this),
            Container(
              padding: const EdgeInsets.all(10.0).r,
              decoration: BoxDecoration(
                border: Border.all(color: AppColorManager.black),
                borderRadius: BorderRadius.all(Radius.circular(12.0.r)),
              ),
              child: Column(
                children: answer?.answers.map((e) {
                      return Column(
                        children: e.map((e1) => e1.getTableAnswerWidget).toList()
                          ..add(const Divider()),
                      );
                    }).toList() ??
                    <Widget>[
                      Container(
                        height: 20,
                        width: 50,
                        color: Colors.red,
                      )
                    ],
              ),
            ),
          ],
        );
      case QType.yesOrNo:
        return TableAnswerWidget(q: this);
      case QType.header:
        return HeaderWidget(q: this);
    }
    return 0.0.verticalSpace;
  }

  factory Questions.fromJson(Map<String, dynamic> map) {
    return Questions(
      assessmentNu: map['0'] ?? '',
      assessmentDate: DateTime.tryParse(map['1'] ?? ''),
      assessmentName: map['2'] ?? '',
      pageNu: map['3'] ?? '',
      sequenceNo: int.tryParse(map['4'].toString() ?? '') ?? 0,
      qstId: map['5'] ?? '',
      qstLabel: map['6'] ?? '',
      qstType: QType.values[map['7'] ?? QType.header.index],
      qstDatasource: map['8'] ?? '',
      rListQstId: map['9'] ?? '',
      tableNumber: map['10'] ?? '',
      isRequired: map['11'] ?? false,
      answer: map['answer'] == null ? null : ItemModel.fromJson(map['answer']),
    );
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
    bool? isRequired,
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
    );
  }
}
// Column(
// children: answer?.answers.map((e) {
// return Column(
// children: e.map((e1) => e1.getTableAnswerWidget).toList()
// ..add(const Divider()),
// );
// }).toList() ??
// <Widget>[
// Container(
// height: 20,
// width: 50,
// color: Colors.red,
// )
// ],
// )
