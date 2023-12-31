import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/core/util/my_style.dart';

import '../../../generated/assets.dart';
import '../../app/bloc/loading_cubit.dart';
import '../../strings/app_color_manager.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    Key? key,
    this.titleText,
    this.elevation,
    this.leading,
    this.zeroHeight,
    this.actions,
    this.title,
  }) : super(key: key);

  final String? titleText;
  final Widget? title;
  final Widget? leading;

  final bool? zeroHeight;
  final double? elevation;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColorManager.whit,
      toolbarHeight: (zeroHeight ?? false) ? 0 : 80.0.h,
      title: title ??
          DrawableText(
            text: titleText ?? '',
            size: 20.0.spMin,
            fontFamily: FontManager.cairoBold.name,
          ),
      leading: Navigator.canPop(context) ? const BackBtnWidget() : leading,
      actions: (actions == null && title == null) ? [const ActionLeading()] : actions,
      elevation: elevation ?? 5.0,
      shadowColor: AppColorManager.black.withOpacity(0.28),
      iconTheme: const IconThemeData(color: AppColorManager.mainColor),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(1.0.sw, (zeroHeight ?? false) ? 0 : 80.0.h);
}

class ActionLeading extends StatelessWidget {
  const ActionLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0).w,
      child: const ImageMultiType(url: Assets.iconsNoTextLogo),
    );
  }
}
