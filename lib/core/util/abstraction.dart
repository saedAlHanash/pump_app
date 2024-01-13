import '../strings/enum_manager.dart';

abstract class AbstractCubit<T>{
  final CubitStatuses statuses;
  final String error;
  final T result;


  const AbstractCubit({
    this.statuses = CubitStatuses.init,
    this.error = '',

    required this.result,
  });
}

