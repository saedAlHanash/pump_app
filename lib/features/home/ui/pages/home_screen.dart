import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/core/strings/enum_manager.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_card_widget.dart';

import '../../../../../router/app_router.dart';
import '../../../../generated/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleText: S.of(context).home,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0).r,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: ItemCardWidget(item: HomeCards.loadData)),
                30.0.verticalSpace,
                Expanded(child: ItemCardWidget(item: HomeCards.fileHistory)),
              ],
            ),
            Row(
              children: [
                Expanded(child: ItemCardWidget(item: HomeCards.startForm)),
                30.0.verticalSpace,
                Expanded(child: ItemCardWidget(item: HomeCards.history)),
              ],
            ),
            SizedBox(
              width: 1.0.sw,
              child: ItemCardWidget(
                item: HomeCards.settings,
              ),
            ),
          ],
        ),
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
          case HomeCards.settings:
            {
              Navigator.pushNamed(context, RouteName.settings);
              break;
            }
          case HomeCards.loadData:
            {
              Navigator.pushNamed(context, RouteName.loadData);
              break;
            }
          case HomeCards.fileHistory:
            {
              Navigator.pushNamed(context, RouteName.files);
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
          elevation: 5.0.r,
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
                  color: AppColorManager.black,
                  fontFamily: FontManager.cairoBold.name,
                ),
              ],
            ),
          )),
    );
  }
}
