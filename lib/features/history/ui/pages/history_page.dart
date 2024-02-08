import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/core/strings/enum_manager.dart';
import 'package:pump_app/core/util/snack_bar_message.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_button.dart';
import 'package:pump_app/core/widgets/spinner_widget.dart';
import 'package:pump_app/features/form/bloc/get_form_cubit/get_form_cubit.dart';
import 'package:pump_app/features/history/ui/widget/item_history.dart';

import '../../../../core/util/my_style.dart';
import '../../../../core/util/pair_class.dart';
import '../../../../core/widgets/my_card_widget.dart';
import '../../../../core/widgets/not_found_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../splash/bloc/files_cubit/files_cubit.dart';
import '../../bloc/export_report_cubit/export_file_cubit.dart';
import '../../bloc/get_history_cubit/get_history_cubit.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final ExportReportCubit exportCubit;

  @override
  void initState() {
    exportCubit = context.read<ExportReportCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExportReportCubit, ExportReportInitial>(
      listenWhen: (p, c) => c.statuses.done,
      listener: (context, state) {
        context.read<FilesCubit>().getFiles();
        NoteMessage.showSuccessSnackBar(message: S.of(context).done, context: context);
      },
      child: Scaffold(
        appBar: AppBarWidget(titleText: S.of(context).history),
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
                            final pair = await choseExportType(context);

                            if (pair == null || !mounted) return;

                            final list = context
                                .read<GetHistoryCubit>()
                                .state
                                .result
                                .where((e) =>
                                    e.list.firstOrNull?.firstOrNull?.assessmentNu ==
                                    pair.second)
                                .toList();

                            switch (pair.first) {
                              case ExportType.db:
                                exportCubit.exportForDb(list: list);
                                break;
                              case ExportType.review:
                                exportCubit.exportForReview(list: list);
                            }
                          },
                          color: const Color(0xFF107C41),
                          text: S.of(context).exportExcel,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<GetHistoryCubit, GetHistoryInitial>(
          builder: (context, state) {
            if (state.statuses.loading) {
              return MyStyle.loadingWidget();
            }
            if (state.result.isEmpty) {
              return NotFoundWidget(
                  text: S.of(context).noHistory, icon: Assets.iconsHistory);
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

  Future<Pair<ExportType, String>?> choseExportType(BuildContext context) async {
    ExportType? selected;
    String? selectedNum;
    return await NoteMessage.showBottomSheet1(
      context,
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 15.0).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinnerWidget(
              hintText: S.of(context).assessmentType,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0.r),
                boxShadow: MyStyle.lightShadow,
                color: AppColorManager.f1,
              ),
              isRequired: true,
              width: 0.9.sw,
              items: context.read<GetFormCubit>().getAssessmentSpinnerItems,
              onChanged: (spinnerItem) => selectedNum = spinnerItem.id,
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => selected = ExportType.db),
                      child: MyCardWidget(
                          cardColor: selected == ExportType.db
                              ? AppColorManager.mainColor.withOpacity(0.2)
                              : AppColorManager.cardColor,
                          elevation: selected == ExportType.db ? 0 : 5.0.r,
                          padding: EdgeInsets.zero,
                          margin: const EdgeInsets.all(10.0).r,
                          child: SizedBox(
                            height: 152.0.h,
                            width: .9.sw,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageMultiType(
                                  url: Assets.iconsDb,
                                  height: 70.0.r,
                                  width: 70.0.r,
                                ),
                                10.0.verticalSpace,
                                DrawableText(
                                  text: S.of(context).exportForDb,
                                  color: AppColorManager.black,
                                  fontFamily: FontManager.cairoBold.name,
                                ),
                              ],
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => selected = ExportType.review),
                      child: MyCardWidget(
                          cardColor: selected == ExportType.review
                              ? AppColorManager.mainColor.withOpacity(0.2)
                              : AppColorManager.cardColor,
                          elevation: selected == ExportType.review ? 0 : 5.0.r,
                          padding: EdgeInsets.zero,
                          margin: const EdgeInsets.all(10.0).r,
                          child: SizedBox(
                            height: 152.0.h,
                            width: .9.sw,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageMultiType(
                                  url: Assets.iconsReview,
                                  height: 70.0.r,
                                  width: 70.0.r,
                                ),
                                10.0.verticalSpace,
                                DrawableText(
                                  text: S.of(context).exportForReview,
                                  color: AppColorManager.black,
                                  fontFamily: FontManager.cairoBold.name,
                                ),
                              ],
                            ),
                          )),
                    ),
                    MyButton(
                      text: S.of(context).done,
                      onTap: () {
                        if (selected == null) {
                          NoteMessage.showAwesomeError(
                            context: context,
                            message: S.of(context).pleasSelectExportType,
                          );
                          return;
                        }
                        if (selectedNum == null) {
                          NoteMessage.showAwesomeError(
                            context: context,
                            message: S.of(context).pleasSelectAssessmentType,
                          );
                          return;
                        }
                        Navigator.pop(context, Pair(selected!, selectedNum!));
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
