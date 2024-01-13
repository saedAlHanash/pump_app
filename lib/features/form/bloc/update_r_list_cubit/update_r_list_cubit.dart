import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';
import '../../../../main.dart';
import '../../../db/models/app_specification.dart';

part 'update_r_list_state.dart';

class UpdateRListCubit extends Cubit<UpdateRListInitial> {
  UpdateRListCubit() : super(UpdateRListInitial.initial());

  void updateRList() {
    emit(state.copyWith(result: state.result + 1, statuses: CubitStatuses.loading));

    Future.delayed(
      const Duration(milliseconds: 600),
      () {
        emit(state.copyWith(statuses: CubitStatuses.done));
      },
    );
  }
}
