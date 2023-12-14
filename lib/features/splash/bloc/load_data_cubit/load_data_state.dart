part of 'load_data_cubit.dart';


class LoadDataInitial extends AbstractCubit<bool> {
  // final LoadDataRequest request;

  const LoadDataInitial({
    required super.result,
    super.error,
    // required this.request,
    super.statuses,
  });

  factory LoadDataInitial.initial() {
    return LoadDataInitial(
      result: false,
      error: '',
      // request: LoadDataRequest(),
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<Object> get props => [statuses, result, error];

  LoadDataInitial copyWith({
    CubitStatuses? statuses,
    bool? result,
    String? error,
    // LoadDataRequest? request,
  }) {
    return LoadDataInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      // request: request ?? this.request,
    );
  }
}
