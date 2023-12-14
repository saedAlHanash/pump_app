import 'package:collection/collection.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/strings/enum_manager.dart';
import 'package:pump_app/core/widgets/my_text_form_widget.dart';
import 'package:pump_app/core/widgets/spinner_widget.dart';
import 'package:pump_app/features/db/models/item_model.dart';
import 'package:pump_app/features/form/bloc/get_form_cubit/get_form_cubit.dart';
import 'package:pump_app/features/form/ui/widget/header_widget.dart';
import 'package:pump_app/features/form/ui/widget/list_string_widget.dart';
import 'package:pump_app/features/form/ui/widget/list_widget.dart';
import 'package:pump_app/features/form/ui/widget/r_list_widget.dart';
import 'package:pump_app/main.dart';

import '../../../core/app/app_widget.dart';
import '../../../core/util/my_style.dart';
import '../../form/bloc/update_r_list_cubit/update_r_list_cubit.dart';
import '../../form/ui/widget/string_widget.dart';

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
  });

  final String assessmentNu;
  final DateTime? assessmentDate;
  final String assessmentName;
  final String pageNu;
  final String sequenceNo;
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
        return 0.0.verticalSpace;
      case QType.number:
        return 0.0.verticalSpace;
      case QType.mCheckbox:
        return 0.0.verticalSpace;
      case QType.table:
        return 0.0.verticalSpace;
      case QType.yesOrNo:
        return 0.0.verticalSpace;
      case QType.header:
        return HeaderWidget(q: this);
    }
  }

  factory Questions.fromJson(Map<String, dynamic> map) {
    return Questions(
      assessmentNu: map['0'] ?? '',
      assessmentDate: DateTime.tryParse(map['1'] ?? ''),
      assessmentName: map['2'] ?? '',
      pageNu: map['3'] ?? '',
      sequenceNo: map['4'] ?? '',
      qstId: map['5'] ?? '',
      qstLabel: map['6'] ?? '',
      qstType: QType.values[map['7'] ?? QType.header.index],
      qstDatasource: map['8'] ?? '',
      rListQstId: map['9'] ?? '',
      tableNumber: map['10'] ?? '',
      isRequired: map['11'] ?? false,
    );
  }

  factory Questions.fromData(List<Data?> e) {
    return Questions.fromJson(
      {
        '0': e.getValueOrNull(0),
        '1': e.getValueOrNull(1),
        '2': e.getValueOrNull(2),
        '3': e.getValueOrNull(3),
        '4': e.getValueOrNull(4),
        '5': e.getValueOrNull(5),
        '6': e.getValueOrNull(6),
        '7': e.getValueOrNull(7).getQType.index,
        '8': e.getValueOrNull(8),
        '9': e.getValueOrNull(9),
        '10': e.getValueOrNull(10),
        '11': e.getValueOrNull(11).isNotEmpty,
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
    };
  }
}
