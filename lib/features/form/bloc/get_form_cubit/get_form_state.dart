part of 'get_form_cubit.dart';

class GetFormInitial extends AbstractCubit<List<List<Questions>>> {
  final Map<String, List<Questions>> allFormes;
  final List<String> rAnswers;
  final List<String> rList;
  final List<String> eAnswers;
  final List<String> rValues;

  const GetFormInitial({
    required super.result,
    super.error,
    required this.allFormes,
    required this.rAnswers,
    required this.rList,
    required this.eAnswers,
    required this.rValues,
    super.statuses,
  });

  factory GetFormInitial.initial() {
    return const GetFormInitial(
      result: [],
      rAnswers: [],
      rList: [],
      eAnswers: [],
      rValues: [],
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
    List<String>? rAnswers,
    List<String>? rList,
    List<String>? eAnswers,
    List<String>? rValues,
    String? error,
    Map<String, List<Questions>>? allFormes,
  }) {
    return GetFormInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      rAnswers: rAnswers ?? this.rAnswers,
      rList: rList ?? this.rList,
      eAnswers: eAnswers ?? this.eAnswers,
      rValues: rValues ?? this.rValues,
      error: error ?? this.error,
      allFormes: allFormes ?? this.allFormes,
    );
  }
}
