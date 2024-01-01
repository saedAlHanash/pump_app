import '../../db/models/app_specification.dart';

class HistoryModel {
  HistoryModel({
    required this.list,
    required this.date,
    this.name,
  });

  final List<List<Questions>> list;
  final DateTime date;
  final String? name;

  Map<String, dynamic> toJson() {
    return {
      "list": list.map((x) => x.map((x) => x.toJson()).toList()).toList(),
      'date': DateTime.now().toIso8601String(),
      'name': name,
    };
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      list: json["list"] == null
          ? []
          : List<List<Questions>>.from(
              json["list"]!.map((x) => x == null
                  ? []
                  : List<Questions>.from(x!.map((x) => Questions.fromJson(x)))),
            ),
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
      name: json['name'] ?? '',
    );
  }

//</editor-fold>
}
