import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pump_app/core/strings/app_string_manager.dart';
import 'package:pump_app/features/db/models/item_model.dart';
import 'package:collection/collection.dart';
import 'package:pump_app/main.dart';
import '../../features/db/models/app_specification.dart';
import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../strings/enum_manager.dart';
import '../widgets/spinner_widget.dart';

extension SplitByLength on String {
  List<String> splitByLength1(int length, {bool ignoreEmpty = false}) {
    List<String> pieces = [];

    for (int i = 0; i < this.length; i += length) {
      int offset = i + length;
      String piece = substring(i, offset >= this.length ? this.length : offset);

      if (ignoreEmpty) {
        piece = piece.replaceAll(RegExp(r'\s+'), '');
      }

      pieces.add(piece);
    }
    return pieces;
  }

  AttachmentType getLinkType({AttachmentType? type}) {
    if (type == AttachmentType.video) {
      if (contains('youtube')) {
        return AttachmentType.youtube;
      } else {
        return AttachmentType.video;
      }
    }
    return AttachmentType.image;
  }

  bool get canSendToSearch {
    if (isEmpty) false;

    return split(' ').last.length > 2;
  }

  int get numberOnly {
    final regex = RegExp(r'\d+');

    final numbers = regex.allMatches(this).map((match) => match.group(0)).join();

    try {
      return int.parse(numbers);
    } on Exception {
      return 0;
    }
  }

  String fixPhone() {
    if (startsWith('0')) return this;

    return '0$this';
  }

  bool get isZero => (num.tryParse(this) ?? 0) == 0;

  String get removeSpace => replaceAll(' ', '');

  Questions get getQ => Questions.fromJson(jsonDecode(this));

  Future<List<SpinnerItem>> getDataSureSpinnerItems({String? selectedId}) async {
    final box = await Hive.openBox<String>(this);
    return box.values
        .map(
          (e) => ItemModel.fromJson(jsonDecode(e)).getSpinnerItem(
            selectedId: selectedId,
          ),
        )
        .toList();
  }

//dataSource
  Future<List<SpinnerItem>> getRListDataSureSpinnerItems(
      {String? selectedId, Questions? related}) async {
    if (related == null) return [];

    final box = await Hive.openBox<String>(this);
    final list = box.values
        .map(
          (e) => ItemModel.fromJson(jsonDecode(e)).getSpinnerItem(
            selectedId: selectedId,
          ),
        )
        .toList();

    list.removeWhere((e) => e.fId != related.answer?.answer);
    return list;
  }
}

extension StringHelper on String? {
  bool get isBlank {
    if (this == null) return true;
    return this!.replaceAll(' ', '').isEmpty;
  }

  QType get getQType {
    if (this == 'List') return QType.list;
    if (this == 'R_List') return QType.rList;
    if (this == 'String') return QType.string;
    if (this == 'L-String') return QType.lString;
    if (this == 'Date') return QType.date;
    if (this == 'Number') return QType.number;
    if (this == 'M_checkbox') return QType.mCheckbox;
    if (this == 'Table') return QType.table;
    if (this == 'HLP_LINK') return QType.helperLink;
    if (this == 'Header') return QType.header;
    return QType.header;
  }
}

final oCcy = NumberFormat("#,###", "en_US");

extension MaxInt on num {
  int get max => 2147483647;

  String get formatPrice => oCcy.format(this);
}

extension QTypeH on QType {
  bool get isQ => this != QType.table && this != QType.header && this != QType.helperLink;
}

extension ListHelper on List<Data?> {
  String getValueOrEmpty(int i) {
    if (isEmpty) return '';
    if (i >= length) return '';
    if (i < 0) return '';
    return this[i]?.value.toString() ?? '';
  }
}

extension SheetHelper on Sheet {
  Future<void> saveInHive() async {
    final Box<String> box = await Hive.openBox(sheetName);
    await box.clear();
    await box.flush();

    final l = rows.skip(1);

    for (List<Data?> e in l) {
      await box.add(
        sheetName == AppStringManager.formTable
            ? jsonEncode(Questions.fromData(e))
            : jsonEncode(ItemModel.fromData(e)),
      );
    }
    await  box.close();
  }

  Future<void> updateInHive() async {
    final Box<String> box = await Hive.openBox(sheetName);
    final String key = sheetName == AppStringManager.formTable
        ? rows.firstOrNull?.getValueOrEmpty(5) ?? ''
        : rows.firstOrNull?.getValueOrEmpty(1) ?? '';

    if (key.isEmpty) box.clear();

    for (List<Data?> e in rows) {
      final key = sheetName == AppStringManager.formTable
          ? e.getValueOrEmpty(5)
          : e.getValueOrEmpty(1);
      if (key.isEmpty) {
        await box.add(jsonEncode(Questions.fromData(e)));
      } else {
        await box.put(key, jsonEncode(Questions.fromData(e)));
      }
    }

    await   box.close();
  }
}

extension HelperJson on Map<String, dynamic> {
  num getAsNum(String key) {
    if (this[key] == null) return -1;
    return num.tryParse((this[key]).toString()) ?? -1;
  }
}

extension CubitStatusesHelper on CubitStatuses {
  bool get loading => this == CubitStatuses.loading;

  bool get done => this == CubitStatuses.done;
}

extension FormatDuration on Duration {
  String get format =>
      '${inMinutes.remainder(60).toString().padLeft(2, '0')}:${(inSeconds.remainder(60)).toString().padLeft(2, '0')}';
}

extension ApiStatusCode on int {
  bool get success => (this >= 200 && this <= 210);

  //
  // int get countDiv2 {
  //   final dr = this / 2; //double result
  //   final ir = this ~/ 2; //int result
  //   return (ir < dr) ? ir + 1 : ir;
  // }
  int get countDiv2 => (this ~/ 2 < this / 2) ? this ~/ 2 + 1 : this ~/ 2;
}

extension TextEditingControllerHelper on TextEditingController {
  void clear() {
    if (text.isNotEmpty) text = '';
  }
}

extension DateUtcHelper on DateTime {
  int get hashDate => (day * 61) + (month * 83) + (year * 23);

  DateTime get getUtc => DateTime.utc(year, month, day);

  String get formatDate => DateFormat('yyyy/MM/dd', 'en').format(this);

  String get formatDateAther => DateFormat('yyyy/MM/dd HH:MM', 'en').format(this);

  String get formatTime => DateFormat('h:mm a', 'en').format(this);

  String get formatDateTime => '$formatTime $formatDate';

  DateTime addFromNow({int? year, int? month, int? day, int? hour}) {
    return DateTime(
      this.year + (year ?? 0),
      this.month + (month ?? 0),
      this.day + (day ?? 0),
      this.hour + (hour ?? 0),
    );
  }

  DateTime initialFromDateTime({required DateTime date, required TimeOfDay time}) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  FormatDateTime getFormat({DateTime? serverDate}) {
    final difference = this.difference(serverDate ?? DateTime.now());

    final months = difference.inDays.abs() ~/ 30;
    final days = difference.inDays.abs() % 360;
    final hours = difference.inHours.abs() % 24;
    final minutes = difference.inMinutes.abs() % 60;
    final seconds = difference.inSeconds.abs() % 60;
    return FormatDateTime(
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  String formatDuration({DateTime? serverDate}) {
    final result = getFormat(serverDate: serverDate);

    final formattedDuration = StringBuffer();

    formattedDuration.write('منذ: ');
    var c = 0;
    if (result.months > 0) {
      c++;
      formattedDuration.write('و ${result.months} شهر ');
    }
    if (result.days > 0 && c < 2) {
      c++;
      formattedDuration.write('و ${result.days} يوم  ');
    }
    if (result.hours > 0 && c < 2) {
      c++;
      formattedDuration.write('و ${result.hours} ساعة  ');
    }
    if (result.minutes > 0 && c < 2) {
      c++;
      formattedDuration.write('و ${result.minutes} دقيقة  ');
    }
    if (result.seconds > 0 && c < 2) {
      c++;
      formattedDuration.write('و ${result.seconds} ثانية ');
    }

    return formattedDuration.toString().trim().replaceFirst('و', '');
  }
}

extension FirstItem<E> on Iterable<E> {
  E? get firstItem => isEmpty ? null : first;
}

extension GetDateTimesBetween on DateTime {
  List<DateTime> getDateTimesBetween({
    required DateTime end,
    required Duration period,
  }) {
    var dateTimes = <DateTime>[];
    var current = add(period);
    while (current.isBefore(end)) {
      if (dateTimes.length > 24) {
        break;
      }
      dateTimes.add(current);
      current = current.add(period);
    }
    return dateTimes;
  }
}

extension ListRelated on List<Questions> {
  void clearRelated(String qId) {}
}

extension ListH<T> on List<List<T>> {
  List<T> get singleList => expand((list) => list).toList();
}

extension EnumHelper on Enum {
  String get arabicName {
    if (this is HomeCards) {
      switch (this as HomeCards) {
        case HomeCards.loadData:
          return S().loadData;
        case HomeCards.fileHistory:
          return S().fileHistory;
        case HomeCards.startForm:
          return S().startForm;
        case HomeCards.history:
          return S().history;
      }
    }
    return '';
  }

  dynamic get icon {
    if (this is HomeCards) {
      switch (this as HomeCards) {
        case HomeCards.loadData:
          return Assets.iconsFiles;
        case HomeCards.fileHistory:
          return Assets.iconsFileHistory;
        case HomeCards.startForm:
          return Assets.iconsForm;
        case HomeCards.history:
          return Assets.iconsHistory;
      }
    }
    return '';
  }
}

class FormatDateTime {
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const FormatDateTime({
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });
}
