import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/core/extensions/extensions.dart';

import 'package:pump_app/core/util/shared_preferences.dart';
import 'package:excel/excel.dart';
import 'package:pump_app/core/util/snack_bar_message.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_button.dart';
import 'package:pump_app/features/db/models/abstract_model.dart';
import 'package:pump_app/features/form/ui/pages/pdf_viewer_page.dart';
import 'package:pump_app/generated/assets.dart';
import 'package:pump_app/main.dart';
import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/my_style.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/widgets/my_card_widget.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/app_router.dart';
import '../../../form/bloc/get_form_cubit/get_form_cubit.dart';
import '../../bloc/load_data_cubit/load_data_cubit.dart';

class LoadData extends StatelessWidget {
  const LoadData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadDataCubit, LoadDataInitial>(
      listenWhen: (p, c) => c.statuses.done,
      listener: (context, state) {
        context.read<GetFormCubit>().getAllForm();
        if (AppSharedPreference.getMyId != null) {
          NoteMessage.showSuccessSnackBar(message: S.of(context).done, context: context);
          return;
        }
        Navigator.pushReplacementNamed(context, RouteName.splash);
      },
      child: Scaffold(
        appBar:  AppBarWidget(titleText: S.of(context).loadData),
        body: Padding(
          padding: MyStyle.authPagesPadding,
          child: BlocBuilder<LoadDataCubit, LoadDataInitial>(
            builder: (context, state) {
              if (state.statuses.loading) {
                return MyStyle.loadingWidget();
              }
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<LoadDataCubit>().setDBData();
                    },
                    child: MyCardWidget(
                        cardColor: AppColorManager.cardColor,
                        elevation: 5.0.r,
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.all(10.0).r,
                        child: SizedBox(
                          height: 152.0.h,
                          width: 1.0.sw,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageMultiType(
                                url: Assets.iconsExcel,
                                height: 70.0.r,
                                width: 70.0.r,
                              ),
                              10.0.verticalSpace,
                              DrawableText(
                                text: S.of(context).loadMainData,
                                color: AppColorManager.black,
                                fontFamily: FontManager.cairoBold.name,
                              ),
                            ],
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      context.read<LoadDataCubit>().setPdfFiles();
                    },
                    child: MyCardWidget(
                        cardColor: AppColorManager.cardColor,
                        elevation: 5.0.r,
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.all(10.0).r,
                        child: SizedBox(
                          height: 152.0.h,
                          width: 1.0.sw,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageMultiType(
                                url: Assets.iconsPdf,
                                height: 70.0.r,
                                width: 70.0.r,
                              ),
                              10.0.verticalSpace,
                              DrawableText(
                                text: S.of(context).uploadHelperData,
                                color: AppColorManager.black,
                                fontFamily: FontManager.cairoBold.name,
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
