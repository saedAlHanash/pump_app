import 'dart:convert';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_button.dart';
import 'package:pump_app/core/widgets/my_button.dart';
import 'package:pump_app/core/widgets/my_card_widget.dart';

import '../../../../core/util/my_style.dart';
import '../../../../core/util/snack_bar_message.dart';
import '../../../../router/app_router.dart';
import '../../../db/models/app_specification.dart';
import '../../../form/bloc/get_form_cubit/get_form_cubit.dart';
import '../../bloc/get_history_cubit/get_history_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: BlocBuilder<GetHistoryCubit, GetHistoryInitial>(
        builder: (context, state) {
          if (state.statuses.loading) {
            return MyStyle.loadingWidget();
          }
          return ListView.separated(
            separatorBuilder: (_, i) => 10.0.verticalSpace,
            itemCount: state.result.length,
            itemBuilder: (_, i) {
              final item = state.result[i];

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteName.answers,
                    arguments: item.list.expand((list) => list).toList(),
                  );
                },
                child: MyCardWidget(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context
                              .read<GetFormCubit>()
                              .setQuestionsFromHistory(list: item.list);
                          Navigator.pushNamed(context, RouteName.startForm);
                        },
                        icon: const ImageMultiType(
                          url: Icons.edit,
                          color: AppColorManager.ampere,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            DrawableText(text: item.date.formatDateTime),
                            DrawableText(text: item.name ?? ''),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DeleteConfirmationDialog();
                            },
                          ).then((value) {
                            if (value != null && value is bool && value) {
                              context.read<GetHistoryCubit>().deleteItem(i);
                            }
                          });
                        },
                        icon: const ImageMultiType(
                          url: Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تأكيد عملية الحذف'),
      content: Text('هل أنت متأكد من حذف عنصر من السجل؟'),
      actions: [
        Row(
          children: [
            Expanded(
              child: MyButton(
                text: 'إلغاء',
                color: Colors.black,
                onTap: () {
                  Navigator.of(context).pop(false); // Return false when cancel is pressed
                },
              ),
            ),
            10.0.horizontalSpace,
            Expanded(
              child: MyButton(
                color: Colors.red,
                text: 'حذف',
                onTap: () {
                  Navigator.of(context).pop(true); // Return true when delete is pressed
                },
              ),
            ),
          ],
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
      return DeleteConfirmationDialog();
    },
  );

  if (deleteConfirmed) {
    // Delete logic goes here
    print('Item deleted!');
  } else {
    print('Delete canceled!');
  }
}
