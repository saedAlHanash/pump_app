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
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/app_router.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class ChoseFormePage extends StatelessWidget {
  const ChoseFormePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleText: S.of(context).forms,
      ),
      body: BlocBuilder<GetFormCubit, GetFormInitial>(
        builder: (context, state) {
          if (state.statuses.loading) {
            return MyStyle.loadingWidget();
          }
          return ListView(
            padding: const EdgeInsets.all( 15.0).r,
            children: state.allFormes.values
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      context.read<GetFormCubit>().getQuestionsForm(
                          assessmentId: e.firstOrNull?.assessmentNu ?? '0');
                      Navigator.pushNamed(context, RouteName.startForm);
                    },
                    child: MyCardWidget(
                      cardColor: AppColorManager.ee,
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(vertical: 10.0).r,
                      padding: const EdgeInsets.all(10.0).r,
                      child: Center(
                        child: DrawableText(
                          matchParent: true,
                          text: e.firstOrNull?.assessmentName ?? '',
                          color: AppColorManager.black.withOpacity(0.7),
                          drawableEnd: const ImageMultiType(
                            url: Icons.keyboard_arrow_left_outlined,
                            color: AppColorManager.mainColor,
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
