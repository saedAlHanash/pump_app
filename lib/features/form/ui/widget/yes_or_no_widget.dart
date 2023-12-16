import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/features/db/models/item_model.dart';

import '../../../../core/widgets/spinner_widget.dart';
import '../../../db/models/app_specification.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class YesNoWidget extends StatelessWidget {
  const YesNoWidget({super.key, required this.q});

  final Questions q;

  @override
  Widget build(BuildContext context) {
    return SpinnerWidget(
      hintText: q.qstLabel,
      width: 0.9.sw,
      isRequired: q.isRequired,
      items: [
        SpinnerItem(
          item: ItemModel.fromJson({
            '1': 'true',
            '2': 'true',
          }),
          isSelected: q.answer?.id == 'true',
          name: 'نعم',
        ),
        SpinnerItem(
          item: ItemModel.fromJson({
            '1': 'false',
            '2': 'false',
          }),
          isSelected: q.answer?.id == 'false',
          name: 'لا',
        ),
      ],
      onChanged: (item) {
        q.answer = item.item;
      },
    );
  }
}
