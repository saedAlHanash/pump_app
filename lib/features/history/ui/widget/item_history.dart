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
import 'package:pump_app/core/widgets/my_card_widget.dart';

import '../../../../core/util/my_style.dart';
import '../../../../generated/assets.dart';
import '../../../../router/app_router.dart';
import '../../../form/bloc/get_form_cubit/get_form_cubit.dart';
import '../../bloc/get_history_cubit/get_history_cubit.dart';
import '../../data/history_model.dart';
import '../pages/history_page.dart';
import 'delete_dialog.dart';

class ItemHistory extends StatelessWidget {
  const ItemHistory({super.key, required this.item, required this.i});

  final HistoryModel item;
  final int i;

  @override
  Widget build(BuildContext context) {
    return MyCardWidget(
      padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0).r,
      child: Column(
        children: [
          DrawableText(
            text: item.date.formatDuration(),
            matchParent: true,
            color: Colors.grey,
            size: 12.0.sp,
            drawableEnd: DrawableText(
              text: item.date.formatTime,
              size: 12.0.sp,
              color: Colors.grey,
              drawablePadding: 7.0.w,
              drawableEnd: DrawableText(
                text: item.date.formatDate,
                size: 12.0.sp,
                color: Colors.grey,
              ),
            ),
          ),
          Divider(height: 20.0.h, endIndent: 0, indent: 0),
          DrawableText(
            text: item.name ?? '',
            matchParent: true,
          ),
          10.0.verticalSpace,
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    context.read<GetFormCubit>().setQuestionsFromHistory(list: item.list);
                    Navigator.pushNamed(context, RouteName.startForm);
                  },
                  child: Column(
                    children: [
                      const ImageMultiType(
                        url: Icons.edit,
                        color: AppColorManager.ampere,
                      ),
                      DrawableText(
                        text: 'إنشاء وتعديل',
                        size: 14.0.sp,
                        color: AppColorManager.black,
                        textAlign: TextAlign.center,
                        drawablePadding: 5.0.w,
                      ),
                    ],
                  ),
                ),
              ),
              15.0.horizontalSpace,
              Expanded(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const DeleteConfirmationDialog();
                      },
                    ).then((value) {
                      if (value != null && value is bool && value) {
                        context.read<GetHistoryCubit>().deleteItem(i);
                      }
                    });
                  },
                  child: Column(
                    children: [
                      const ImageMultiType(
                        url: Icons.delete,
                        color: Colors.red,
                      ),
                      DrawableText(
                        text: 'حذف',
                        size: 14.0.sp,
                        color: AppColorManager.black,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              15.0.horizontalSpace,
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteName.answers,
                      arguments: item.list.expand((list) => list).toList(),
                    );
                  },
                  child: Column(
                    children: [
                      const ImageMultiType(
                        url: Icons.info_outline,
                      ),
                      DrawableText(
                        text: 'عرض',
                        size: 14.0.sp,
                        color: AppColorManager.black,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
