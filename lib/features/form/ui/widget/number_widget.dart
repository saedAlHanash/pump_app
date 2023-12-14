import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';

import '../../../../core/util/my_style.dart';
import '../../../../core/widgets/my_text_form_widget.dart';
import '../../../../core/widgets/spinner_widget.dart';
import '../../../db/models/app_specification.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class NumberWidget extends StatelessWidget {
  const NumberWidget({super.key, required this.q});

  final Questions q;

  @override
  Widget build(BuildContext context) {
    return MyTextFormOutLineWidget(
      label: q.qstLabel,
      isRequired: q.isRequired,
      keyBordType: TextInputType.number,
      controller: TextEditingController(text: q.answer?.id),
      onChanged: (val) {
        q.answer?.id = val;
      },
    );
  }
}
