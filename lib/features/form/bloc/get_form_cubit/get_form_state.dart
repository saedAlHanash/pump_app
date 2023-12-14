part of 'get_form_cubit.dart';

class GetFormInitial extends AbstractCubit<List<Questions>> {
  final int request;

  const GetFormInitial({
    required super.result,
    super.error,
    required this.request,
    super.statuses,
  });

  factory GetFormInitial.initial() {
    return const GetFormInitial(
      result: [],
      error: '',
      request:0,
      statuses: CubitStatuses.init,
    );
  }

  // @override
  // List<Object> get props => [statuses, result, error,request];

  GetFormInitial copyWith({
    CubitStatuses? statuses,
    List<Questions>? result,
    String? error,
    int? request,
  }) {
    return GetFormInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
    );
  }
}
