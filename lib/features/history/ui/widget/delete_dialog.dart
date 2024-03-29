import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';

import '../../../../generated/l10n.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  DrawableText(
        text: S.of(context).confirmDelete,
        color: Colors.black,
      ),
      content:  DrawableText(
        text: S.of(context).deleteFromHistory,
        color: Colors.grey,
      ),
      actions: [
        TextButton(
          style:
              const ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColorManager.red)),
          child: DrawableText(
            color: Colors.white,
            text: S.of(context).delete,
            fontFamily: FontManager.cairoBold.name,
            matchParent: true,
            textAlign: TextAlign.center,
            drawableEnd: const ImageMultiType(
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

  } else {

  }
}
