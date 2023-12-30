import 'package:drawable_text/drawable_text.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/core/widgets/my_button.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const DrawableText(
        text: 'تأكيد عملية الحذف',
        color: Colors.black,
      ),
      content: const DrawableText(
        text: 'هل أنت متأكد من حذف عنصر من السجل؟',
        color: Colors.grey,
      ),
      actions: [
        TextButton(
          style:
              ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColorManager.red)),
          child: DrawableText(
            color: Colors.white,
            text: 'حذف',
            fontFamily: FontManager.cairoBold.name,
            matchParent: true,
            textAlign: TextAlign.center,
            drawableEnd: ImageMultiType(
              url: Icons.delete,
              color: AppColorManager.whit,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true); // Return true when delete is pressed
          },
        ),
      ],
    );
  }
}

// Usage example
void showDeleteConfirmation(BuildContext context) async {
  final bool deleteConfirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return const DeleteConfirmationDialog();
    },
  );

  if (deleteConfirmed) {
    // Delete logic goes here
    print('Item deleted!');
  } else {
    print('Delete canceled!');
  }
}
