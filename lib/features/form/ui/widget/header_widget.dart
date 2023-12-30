import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';

import 'package:pump_app/features/db/models/app_specification.dart';

import '../../../../core/util/snack_bar_message.dart';
import '../../../../main.dart';
import '../pages/pdf_viewer_page.dart';

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
      fontFamily: FontManager.cairoBold.name,
      drawableEnd: IconButton(
          onPressed: () async {
            loggerObject.w(q.valueAnswer);

            final filePath = await getFilePath(q.valueAnswer);
            loggerObject.w(filePath);

            if (context.mounted) {
              NoteMessage.showMyDialog(
                context,
                child: SizedBox(
                  height: 0.8.sh,
                  child: PdfViewerWidget(url: filePath ?? ''),
                ),
              );
            }
          },
          icon: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColorManager.gray,
              ),
            ),
            child: const Icon(
              Icons.question_mark_sharp,
              color: AppColorManager.gray,
            ),
          )),
    );
  }
}
