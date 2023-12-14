import 'package:excel/excel.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/widgets/spinner_widget.dart';

class ItemModel {
  String fKey;
  String id;
  String name;

  factory ItemModel.fromJson(Map<String, dynamic> map) {
    return ItemModel(
      fKey: map['0'] ?? '',
      id: map['1'] ?? '',
      name: map['2'] ?? '',
    );
  }

  factory ItemModel.fromData(List<Data?> e) {
    return ItemModel.fromJson(
      {
        '0': e.getValueOrNull(0),
        '1': e.getValueOrNull(1),
        '2': e.getValueOrNull(2),
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
    };
  }

  ItemModel({
    required this.fKey,
    required this.id,
    required this.name,
  });

  ItemModel copyWith({
    String? fKey,
    String? id,
    String? name,
  }) {
    return ItemModel(
      fKey: fKey ?? this.fKey,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
