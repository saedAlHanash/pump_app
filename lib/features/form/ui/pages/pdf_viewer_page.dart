import 'dart:io';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/util/snack_bar_message.dart';

class PdfViewerWidget extends StatelessWidget {
  const PdfViewerWidget({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const Center(
          child: DrawableText(text: 'المعلومات المطلوبة غير متوفرة حاليا'));
    }
    return SfPdfViewer.file(
      File(url),
      onDocumentLoadFailed: (details) {
        NoteMessage.showErrorDialog(context, text: 'خطأ في تحميل الملف');
      },
    );
  }
}
