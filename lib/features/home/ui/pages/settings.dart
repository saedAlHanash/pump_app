import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:pump_app/core/strings/app_color_manager.dart';
import 'package:pump_app/core/strings/app_string_manager.dart';
import 'package:pump_app/core/strings/app_string_manager.dart';
import 'package:pump_app/core/strings/app_string_manager.dart';
import 'package:pump_app/core/strings/app_string_manager.dart';
import 'package:pump_app/core/util/snack_bar_message.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_button.dart';

import '../../../../core/app/app_widget.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../router/app_router.dart';
import '../../../splash/bloc/files_cubit/files_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleText: S.of(context).settings,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LanWidget(),
            30.0.verticalSpace,
            MyButton(
              onTap: () async {
                final result = await NoteMessage.showCheckDialog(context,
                    text: S.of(context).confirmDelete,
                    textButton: S.of(context).confirm,
                    image: Icons.delete);

                if (result && context.mounted) {
                  AppSharedPreference.logout();

                  clearAppData();

                  context.read<FilesCubit>().clearAll();

                  await Hive.deleteBoxFromDisk('pdf_files');
                  await Hive.deleteBoxFromDisk(AppStringManager.usersTable);
                  await Hive.deleteBoxFromDisk(AppStringManager.formTable);
                  await Hive.deleteBoxFromDisk(AppStringManager.answerBox);
                  await Hive.deleteBoxFromDisk(AppStringManager.filePathsBox);

                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteName.splash, (route) => false);
                }
              },
              color: Colors.red,
              text: S.of(context).clearAllData,
            ),
          ],
        ),
      ),
    );
  }
}

class LanWidget extends StatefulWidget {
  const LanWidget({super.key});

  @override
  State<LanWidget> createState() => _LanWidgetState();
}

class _LanWidgetState extends State<LanWidget> {
  var select = 0;

  @override
  void initState() {
    select = AppSharedPreference.getLocal != 'ar' ? 0 : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DrawableText(
            color: const Color(0xFF333333),
            size: 18.0.sp,
            padding: const EdgeInsets.symmetric(vertical: 30.0).h,
            fontFamily: FontManager.cairoBold.name,
            text: S.of(context).language,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  MyApp.setLocale(context, Locale('en'));
                  setState(() => select = 0);
                },
                child: Container(
                  height: .4.sw,
                  width: .4.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0.r),
                    border:
                        select == 0 ? null : Border.all(color: const Color(0xFFE8F3F1)),
                    color: select == 0 ? AppColorManager.mainColorDark : Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 70.0.r,
                        width: 70.0.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: DrawableText(
                          text: 'EN',
                          size: 20.0.sp,
                          fontFamily: FontManager.cairoBold.name,
                        ),
                      ),
                      6.0.verticalSpace,
                      DrawableText(
                        text: 'English',
                        color:
                            select == 0 ? AppColorManager.whit : const Color(0xFF333333),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  MyApp.setLocale(context, Locale('ar'));
                  setState(() => select = 1);
                },
                child: Container(
                  height: .4.sw,
                  width: .4.sw,
                  decoration: BoxDecoration(
                    border:
                        select == 1 ? null : Border.all(color: const Color(0xFFE8F3F1)),
                    borderRadius: BorderRadius.circular(20.0.r),
                    color: select != 0 ? AppColorManager.mainColorDark : Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 70.0.r,
                        width: 70.0.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColorManager.lightGray,
                        ),
                        child: DrawableText(
                          text: 'ع',
                          size: 20.0.sp,
                          fontFamily: FontManager.cairoBold.name,
                        ),
                      ),
                      DrawableText(
                        text: 'العربية',
                        color:
                            select == 1 ? AppColorManager.whit : const Color(0xFF333333),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

void clearAppData() async {
  final secureStorage = FlutterSecureStorage();

  // Delete all data stored by the app
  await secureStorage.deleteAll();
}
