part of 'update_r_list_cubit.dart';

class UpdateRListInitial extends AbstractCubit<int> {
  // final UpdateRListRequest request;

  const UpdateRListInitial({
    required super.result,
    super.error,
    // required this.request,
    super.statuses,
  });

  factory UpdateRListInitial.initial() {
    return const UpdateRListInitial(
      result: 0,
      error: '',
      // request: UpdateRListRequest(),
      statuses: CubitStatuses.init,
    );
  }



  UpdateRListInitial copyWith({
    CubitStatuses? statuses,
    int? result,
    String? error,
    // UpdateRListRequest? request,
  }) {
    return UpdateRListInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      // request: request ?? this.request,
    );
  }
}
