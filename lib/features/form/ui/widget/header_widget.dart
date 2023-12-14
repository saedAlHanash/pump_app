import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/features/db/models/app_specification.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.q});

  final Questions q;

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      padding: const EdgeInsets.all(7.0).r,
      text: q.qstLabel,
      matchParent: true,
      size: 20.0.sp,
      fontFamily: FontManager.cairoBold,
    );
  }
}
