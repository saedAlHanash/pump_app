import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/core/strings/enum_manager.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_card_widget.dart';
import 'package:pump_app/generated/assets.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../../router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(zeroHeight: true),
      body: Column(
        children: [
          50.0.verticalSpace,
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10.0).w,
            children: const [
              ItemCardWidget(item: HomeCards.loadData),
              ItemCardWidget(item: HomeCards.updateData),
              ItemCardWidget(item: HomeCards.startForm),
              ItemCardWidget(item: HomeCards.history),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemCardWidget extends StatefulWidget {
  const ItemCardWidget({super.key, required this.item});

  final HomeCards item;

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (widget.item) {
          case HomeCards.loadData:
            {
              Navigator.pushNamed(context, RouteName.loadData);
              break;
            }
          case HomeCards.updateData:
            {
              Navigator.pushNamed(context, RouteName.loadData);
              break;
            }
          case HomeCards.startForm:
            {
              Navigator.pushNamed(context, RouteName.choseForm);
              break;
            }
          case HomeCards.history:
            {
              Navigator.pushNamed(context, RouteName.history);
              break;
            }
        }
      },
      child: MyCardWidget(
          cardColor: AppColorManager.cardColor,
          elevation: 0.0,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.all(10.0).r,
          child: SizedBox(
            height: 152.0.h,
            width: 170.0.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageMultiType(
                  url: widget.item.icon,
                  height: 70.0.r,
                  width: 70.0.r,
                ),
                10.0.verticalSpace,
                DrawableText(
                  text: widget.item.arabicName,
                  color: AppColorManager.mainColorDark,
                  fontFamily: FontManager.cairoBold,
                ),
              ],
            ),
          )),
    );
  }
}
