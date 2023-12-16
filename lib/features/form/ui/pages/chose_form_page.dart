import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_button.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/util/my_style.dart';
import '../../../../core/widgets/my_card_widget.dart';
import '../../../../router/app_router.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class ChoseFormePage extends StatelessWidget {
  const ChoseFormePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: BlocBuilder<GetFormCubit, GetFormInitial>(
        builder: (context, state) {
          if (state.statuses.loading) {
            return MyStyle.loadingWidget();
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0).w,
            children: state.allFormes.values
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      context.read<GetFormCubit>().getQuestionsForm(
                          assessmentId: e.firstOrNull?.assessmentNu ?? '0');
                      Navigator.pushNamed(context, RouteName.startForm);
                    },
                    child: MyCardWidget(
                      cardColor: AppColorManager.cardColor,
                      elevation: 0.0,
                      padding: EdgeInsets.zero,
                      margin: const EdgeInsets.all(10.0).r,
                      child: SizedBox(
                        height: 152.0.h,
                        width: 170.0.w,
                        child: Center(
                          child: DrawableText(
                            textAlign: TextAlign.center,
                            text: e.firstOrNull?.assessmentName ?? '',
                            color: AppColorManager.mainColorDark,
                            fontFamily: FontManager.cairoBold,
                            matchParent: true,
                            size: 12.0.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
