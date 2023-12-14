import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_button.dart';

import '../../../../router/app_router.dart';

class ChoseFormePage extends StatelessWidget {
  const ChoseFormePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: SizedBox(
        width: 1.0.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyButton(
              onTap: () {
                Navigator.pushNamed(context, RouteName.startForm);
              },
              text: 'start Form1',
            ),
            Spacer(),
            MyButton(
              onTap: () {
                Navigator.pushNamed(context, RouteName.loadData);
              },
              text: 'reload Data',
            ),
            20.0.verticalSpace,
          ],
        ),
      ),
    );
  }
}
