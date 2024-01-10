part of 'export_file_cubit.dart';

class ExportReportInitial extends AbstractCubit<bool> {
  final excel = Excel.createExcel();
  final List<Sheet> sheets = [];

  Sheet getSheet(String name) => excel[name];

  ExportReportInitial({
    required super.result,
    super.error,
    super.statuses,
  });

  factory ExportReportInitial.initial() {
    return ExportReportInitial(
      result: false,
      error: '',
      statuses: CubitStatuses.init,
    );
  }

  // @override

  ExportReportInitial copyWith({
    CubitStatuses? statuses,
    bool? result,
    String? error,
  }) {
    return ExportReportInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}
