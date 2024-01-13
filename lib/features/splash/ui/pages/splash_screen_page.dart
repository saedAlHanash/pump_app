import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/util/shared_preferences.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../generated/assets.dart';
import '../../../../router/app_router.dart';
import '../../bloc/load_data_cubit/load_data_cubit.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (!AppSharedPreference.isLoadData) {
          Navigator.pushReplacementNamed(context, RouteName.loadData);
          return;
        }
        if (AppSharedPreference.getMyId == null) {
          Navigator.pushReplacementNamed(context, RouteName.login);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, RouteName.home, (route) => false);
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadDataCubit, LoadDataInitial>(
      listenWhen: (p, c) => c.statuses.done,
      listener: (context, state) {
        Navigator.pushReplacementNamed(context, RouteName.splash);
      },
      child: Scaffold(
        backgroundColor: AppColorManager.mainColor,
        body: Center(
          child: ImageMultiType(
            url: Assets.iconsMainLogo,
            height: 250.0.r,
            width: 250.0.r,
            // color: Colors.white,
          ),
        ),
      ),
    );
  }
}
