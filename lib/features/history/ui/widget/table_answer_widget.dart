import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/widgets/q_header_widget.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../db/models/app_specification.dart';

class TableAnswerWidget extends StatelessWidget {
  const TableAnswerWidget({super.key, required this.q});

  final Questions q;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        QHeaderWidget(q: q),
        if (q.answer != null && q.answer!.answers.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(10.0).r,
            decoration: BoxDecoration(
              border: Border.all(color: AppColorManager.black),
              borderRadius: BorderRadius.all(Radius.circular(12.0.r)),
            ),
            child: Column(
                children: q.answer!.answers.map((e) {
              return SizedBox(
                height: e.length * 95.0.h,
                child: Column(
                  children: e.map((e1) => e1.getTableAnswerWidget).toList()
                    ..add(const Divider()),
                ),
              );
            }).toList()),
          ),
      ],
    );
  }
}
