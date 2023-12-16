import 'package:excel/excel.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/widgets/spinner_widget.dart';

import 'app_specification.dart';

class ItemModel {
  ItemModel({
    required this.fKey,
    required this.id,
    required this.name,
    required this.answers,
  });

  String fKey;
  String id;
  String name;

  List<List<Questions>> answers;

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      fKey: json['0'] ?? '',
      id: json['1'] ?? '',
      name: json['2'] ?? '',
      answers: json["list"] == null
          ? []
          : List<List<Questions>>.from(json["list"]!.map((x) => x == null
              ? []
              : List<Questions>.from(x!.map((x) => Questions.fromJson(x))))),
    );
  }

  factory ItemModel.fromData(List<Data?> e) {
    return ItemModel.fromJson(
      {
        '0': e.getValueOrEmpty(0),
        '1': e.getValueOrEmpty(1),
        '2': e.getValueOrEmpty(2),
      },
    );
  }

  SpinnerItem getSpinnerItem({String? selectedId}) => SpinnerItem(
        name: name,
        id: id,
        fId: fKey,
        isSelected: selectedId == id,
        item: this,
      );

  Map<String, dynamic> toJson() {
    return {
      '0': fKey,
      '1': id,
      '2': name,
      "list": answers.map((x) => x.map((x) => x.toJson()).toList()).toList(),
    };
  }

// ItemModel copyWith({
//   String? fKey,
//   String? id,
//   String? name,
// }) {
//   return ItemModel(
//     fKey: fKey ?? this.fKey,
//     id: id ?? this.id,
//     name: name ?? this.name,
//   );
// }
}
