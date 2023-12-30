import 'dart:io';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/not_found_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/util/my_style.dart';
import '../../../../core/widgets/my_card_widget.dart';
import '../../../../generated/assets.dart';
import '../../../history/ui/widget/delete_dialog.dart';
import '../../bloc/files_cubit/files_cubit.dart';

class FilesPage extends StatelessWidget {
  const FilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titleText: 'سجل الملفات'),
      body: Padding(
        padding: MyStyle.authPagesPadding,
        child: BlocBuilder<FilesCubit, FilesInitial>(
          builder: (context, state) {
            if (state.statuses.loading) {
              return MyStyle.loadingWidget();
            }
            if (state.result.isEmpty) {
              return const NotFoundWidget(text: 'لا يوجد ملفات', icon: Assets.iconsExcel);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(15.0).r,
              itemCount: state.result.length,
              itemBuilder: (_, i) {
                final file = state.result[i];
                final fileState = state.request[i];
                return MyCardWidget(
                  cardColor: AppColorManager.ee,
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0).r,
                  padding: const EdgeInsets.all(10.0).r,
                  child: Column(
                    children: [
                      DrawableText(
                        text: fileState.modified.formatDuration(),
                        matchParent: true,
                        color: Colors.grey,
                        size: 12.0.sp,
                        drawableEnd: DrawableText(
                          text: fileState.modified.formatTime,
                          size: 12.0.sp,
                          color: Colors.grey,
                          drawablePadding: 7.0.w,
                          drawableEnd: DrawableText(
                            text: fileState.modified.formatDate,
                            size: 12.0.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Divider(height: 20.0.h, endIndent: 0, indent: 0),
                      DrawableText(
                        text: file.name ?? '',
                        matchParent: true,
                        size: 14.0.sp,
                        drawablePadding: 10.0.w,
                        drawableStart: ImageMultiType(
                          url: Assets.iconsExcelMs,
                          height: 25.0.r,
                          width: 25.0.r,
                        ),
                      ),
                      10.0.verticalSpace,
                      Row(
                        children: [
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
                                    File(file.path).deleteSync();
                                    context.read<FilesCubit>().getFiles();
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
                                Share.shareXFiles([file]);
                              },
                              child: Column(
                                children: [
                                  const ImageMultiType(
                                    url: Icons.share,
                                  ),
                                  DrawableText(
                                    text: 'مشاركة',
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
              },
              // state.result.keys
              //     .map(
              //       (e) =>
              //     )
              //     .toList(),
            );
          },
        ),
      ),
    );
  }
}
