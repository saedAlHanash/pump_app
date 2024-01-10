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
import 'package:pump_app/features/history/ui/widget/item_history.dart';

import '../../../../core/util/my_style.dart';
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
                            final list = context.read<GetHistoryCubit>().state.result;

                            final type = await choseExportType(context);

                            if (type == null) return;
                            switch (type) {
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

  Future<ExportType?> choseExportType(BuildContext context) async {
    return await NoteMessage.showBottomSheet1(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          20.0.verticalSpace,
          InkWell(
            onTap: () => Navigator.pop(context, ExportType.db),
            child: MyCardWidget(
                cardColor: AppColorManager.cardColor,
                elevation: 5.0.r,
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
          InkWell(
            onTap: () => Navigator.pop(context, ExportType.review),
            child: MyCardWidget(
                cardColor: AppColorManager.cardColor,
                elevation: 5.0.r,
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
          20.0.verticalSpace,
        ],
      ),
    );
  }
}
