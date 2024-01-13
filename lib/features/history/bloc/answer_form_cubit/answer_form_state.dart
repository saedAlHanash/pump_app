part of 'answer_form_cubit.dart';

class AnswerFormInitial extends AbstractCubit<List<Questions>> {
  // final AnswerFormRequest request;

  const AnswerFormInitial({
    required super.result,
    super.error,
    // required this.request,
    super.statuses,
  });

  factory AnswerFormInitial.initial() {
    return const AnswerFormInitial(
      result: [],
      error: '',
      // request: AnswerFormRequest(),
      statuses: CubitStatuses.init,
    );
  }


  AnswerFormInitial copyWith({
    CubitStatuses? statuses,
    List<Questions>? result,
    String? error,
    // AnswerFormRequest? request,
  }) {
    return AnswerFormInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      // request: request ?? this.request,
    );
  }
}
