import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/core/strings/enum_manager.dart';
import 'package:pump_app/core/util/snack_bar_message.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_button.dart';
import 'package:pump_app/features/history/ui/widget/item_history.dart';

import '../../../../core/util/my_style.dart';
import '../../../../core/widgets/my_text_form_widget.dart';
import '../../../../core/widgets/not_found_widget.dart';
import '../../../../core/widgets/q_header_widget.dart';
import '../../../../generated/assets.dart';
import '../../../db/models/app_specification.dart';
import '../../../splash/bloc/files_cubit/files_cubit.dart';
import '../../bloc/export_report_cubit/export_file_cubit.dart';
import '../../bloc/get_history_cubit/get_history_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExportReportCubit, ExportReportInitial>(
      listenWhen: (p, c) => c.statuses.done,
      listener: (context, state) {
        context.read<FilesCubit>().getFiles();
        NoteMessage.showSuccessSnackBar(message: 'تم بنجاح', context: context);
      },
      child: Scaffold(
        appBar: const AppBarWidget(titleText: 'السجل'),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0).r,
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<ExportReportCubit, ExportReportInitial>(
                  builder: (context, state) {
                    if (state.statuses.loading) {
                      return SizedBox(height: 50.0.h, child: MyStyle.loadingWidget());
                    }
                    return BlocBuilder<GetHistoryCubit, GetHistoryInitial>(
                      builder: (context, state) {
                        if (state.result.isEmpty || state.statuses.loading) {
                          return 0.0.verticalSpace;
                        }

                        return MyButton(
                          onTap: () async {
                            final list = context.read<GetHistoryCubit>().state.result;
                            final m = context.read<GetHistoryCubit>().getQIds();

                            var name = '';
                            name = await NoteMessage.showMyDialog(
                              context,
                              child: Builder(builder: (context) {
                                final c = TextEditingController();
                                return Padding(
                                  padding: const EdgeInsets.all(20.0).r,
                                  child: Column(
                                    children: [
                                      QHeaderWidget(
                                        q: Questions.fromJson(
                                          {
                                            '6': 'هل ترغب في تعيين اسم للملف؟',
                                            '11': true
                                          },
                                        ),
                                      ),
                                      5.0.verticalSpace,
                                      MyTextFormOutLineWidget(
                                        controller: c,
                                        label: 'اسم الملف',
                                      ),
                                      MyButton(
                                        text: 'تم',
                                        onTap: () {
                                          Navigator.pop(context, c.text);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            );

                            if (context.mounted) {
                              context.read<ExportReportCubit>().saveExcelFile(
                                    list: list,
                                    m: m,
                                    name: name,
                                  );
                            }
                          },
                          color: const Color(0xFF107C41),
                          text: 'تصدير الإكسل',
                        );
                      },
                    );
                  },
                ),
              ),
              // 15.0.horizontalSpace,
              // Expanded(
              //   child: MyButton(
              //     onTap: () {},
              //     color: AppColorManager.red,
              //     text: 'مسح السجل',
              //   ),
              // ),
            ],
          ),
        ),
        body: BlocBuilder<GetHistoryCubit, GetHistoryInitial>(
          builder: (context, state) {
            if (state.statuses.loading) {
              return MyStyle.loadingWidget();
            }
            if (state.result.isEmpty) {
              return const NotFoundWidget(text: 'لا يوجد سجل', icon: Assets.iconsHistory);
            }
            return ListView.separated(
              separatorBuilder: (_, i) => 10.0.verticalSpace,
              itemCount: state.result.length,
              padding: const EdgeInsets.all(15.0).r,
              itemBuilder: (_, i) {
                return ItemHistory(item: state.result[i], i: i);
              },
            );
          },
        ),
      ),
    );
  }
}
