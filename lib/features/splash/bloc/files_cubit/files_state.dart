part of 'files_cubit.dart';

class FilesInitial extends AbstractCubit<List<XFile>> {
  final List<FileStat> request;

  const FilesInitial({
    required super.result,
    super.error,
    required this.request,
    super.statuses,
  });

  factory FilesInitial.initial() {
    return const FilesInitial(
      result:[] ,
      error: '',
      request: <FileStat>[],
      statuses: CubitStatuses.init,
    );
  }

  FilesInitial copyWith({
    CubitStatuses? statuses,
    List<XFile>? result,
    String? error,
    List<FileStat>? request,
  }) {
    return FilesInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
    );
  }
}
