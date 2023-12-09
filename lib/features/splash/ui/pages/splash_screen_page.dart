import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import 'package:pump_app/core/util/shared_preferences.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/my_style.dart';

import '../../../../router/app_router.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    Future.delayed(
      const Duration(seconds: 2),
      () {

      },
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: 1.0.sw,
        height: 1.0.sh,
        padding: MyStyle.authPagesPadding,
        child: const Center(
          child: ImageMultiType(
            url: Icons.water_drop,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

StartPage get getStartPage {
  if (AppSharedPreference.isLogin) {
    return StartPage.home;
  }
  if (AppSharedPreference.getPhoneOrEmail.isNotEmpty) {
    return StartPage.otp;
  }
  if (AppSharedPreference.getPhoneOrEmailPassword.isNotEmpty) {
    return StartPage.passwordOtp;
  }
  if (AppSharedPreference.getOtpPassword.isNotEmpty) return StartPage.resetPassword;
  return StartPage.login;
}
