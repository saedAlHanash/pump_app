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
import 'package:pump_app/core/widgets/my_button.dart';
import 'package:pump_app/features/db/models/abstract_model.dart';
import 'package:pump_app/main.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/my_style.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../generated/l10n.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if(!AppSharedPreference.isLoadData){
          Navigator.pushReplacementNamed(context, RouteName.loadData);
          return ;
        }
        if (AppSharedPreference.getMyId == '0') {
          Navigator.pushReplacementNamed(context, RouteName.login);
        }else{
          Navigator.pushNamedAndRemoveUntil(context, RouteName.choseForm, (route) => false);
        }
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
    return BlocListener<LoadDataCubit, LoadDataInitial>(
      listenWhen: (p, c) => c.statuses.done,
      listener: (context, state) {
        Navigator.pushReplacementNamed(context, RouteName.splash);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          width: 1.0.sw,
          height: 1.0.sh,
          padding: MyStyle.authPagesPadding,
        ),
      ),
    );
  }
}

class LoadData extends StatelessWidget {
  const LoadData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadDataCubit, LoadDataInitial>(
      listenWhen: (p, c) => c.statuses.done,
      listener: (context, state) {
        Navigator.pushReplacementNamed(context, RouteName.splash);
      },
      child: Scaffold(
        body: Container(
          width: 1.0.sw,
          padding: MyStyle.authPagesPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<LoadDataCubit, LoadDataInitial>(
                builder: (context, state) {
                  return MyButton(
                    onTap: () {
                      context.read<LoadDataCubit>().setDBData();
                    },
                    child: DrawableText(
                      text: S.of(context).loadData,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
