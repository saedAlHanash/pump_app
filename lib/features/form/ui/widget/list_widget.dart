import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';

import '../../../../core/widgets/spinner_widget.dart';
import '../../../db/models/app_specification.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({super.key, required this.q});
  final Questions q;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: q.qstDatasource.getDataSureSpinnerItems(selectedId: q.answer?.id),
      builder: (context, snapShot) {
        if (!snapShot.hasData) return 0.0.verticalSpace;
        return SpinnerWidget(
          hintText: q.qstLabel,
          width: 0.9.sw,
          isRequired: q.isRequired,
          items: snapShot.data!,
          onChanged: (item) {
            q.answer = item.item;
            context.read<GetFormCubit>().clearRelated(qId: q.qstId);
          },
        );
      },
    );
  }
}
