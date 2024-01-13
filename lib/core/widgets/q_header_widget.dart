import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/db/models/app_specification.dart';
import '../strings/app_color_manager.dart';

class QHeaderWidget extends StatelessWidget {
  const QHeaderWidget({super.key, required this.q});

  final Questions q;

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      text: q.qstLabel,
      matchParent: true,
      color: AppColorManager.gray,
      size: 14.0.sp,
      fontFamily: FontManager.cairo.name,
      drawableStart: q.isRequired
          ? DrawableText(
              text: ' * ',
              color: Colors.red,
              drawablePadding: 5.0.w,
            )
          : null,
    );
  }
}
