part of 'export_file_cubit.dart';

class ExportReportInitial extends AbstractCubit<bool> {
  final excel = Excel.createExcel();
  late final Sheet sheetObject;

  late final Sheet sheetObjectTable;

  ExportReportInitial({
    required super.result,
    super.error,
    super.statuses,
  }) {
    sheetObject = excel['Sheet1'];
    sheetObjectTable = excel['Sheet2'];
  }

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
