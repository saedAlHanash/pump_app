part of 'get_form_cubit.dart';

class GetFormInitial extends AbstractCubit<List<List<Questions>>> {
  final Map<String, List<Questions>> allFormes;

  const GetFormInitial({
    required super.result,
    super.error,
    required this.allFormes,
    super.statuses,
  });

  factory GetFormInitial.initial() {
    return const GetFormInitial(
      result: [],
      error: '',
      allFormes: {},
      statuses: CubitStatuses.init,
    );
  }

  // @override
  // List<Object> get props => [statuses, result, error,allFormes];

  GetFormInitial copyWith({
    CubitStatuses? statuses,
    List<List<Questions>>? result,
    String? error,
    Map<String, List<Questions>>? allFormes,
  }) {
    return GetFormInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      allFormes: allFormes ?? this.allFormes,
    );
  }
}
