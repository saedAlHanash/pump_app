part of 'get_history_cubit.dart';

class GetHistoryInitial extends AbstractCubit<List<HistoryModel>> {

  const GetHistoryInitial({
    required super.result,
    super.error,
    super.statuses,
  });

  factory GetHistoryInitial.initial() {
    return const GetHistoryInitial(
      result: [],
      error: '',
      statuses: CubitStatuses.init,
    );
  }

  // @override

  GetHistoryInitial copyWith({
    CubitStatuses? statuses,
    List<HistoryModel>? result,
    String? error,
  }) {
    return GetHistoryInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}
