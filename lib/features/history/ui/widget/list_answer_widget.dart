import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/widgets/q_header_widget.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../db/models/app_specification.dart';

class ListAnswerWidget extends StatelessWidget {
  const ListAnswerWidget({super.key, required this.q});

  final Questions q;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QHeaderWidget(q: q),
        Container(
          width: 1.0.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0.r),
            color: AppColorManager.f1.withOpacity(0.5),
          ),
          padding: const EdgeInsets.all(7.0).r,
          margin: const EdgeInsets.only(top: 5.0, bottom: 10.0).h,
          child: DrawableText(
            text: q.answer?.name ?? '',
          ),
        ),
      ],
    );
  }
}
