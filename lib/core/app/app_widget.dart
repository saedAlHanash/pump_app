import 'package:drawable_text/drawable_text.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';
import '../../router/app_router.dart';
import '../app_theme.dart';
import '../injection/injection_container.dart' as di;
import '../injection/injection_container.dart';
import '../strings/app_color_manager.dart';
import '../util/shared_preferences.dart';
import 'bloc/loading_cubit.dart';
import 'package:image_multi_type/image_multi_type.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static Future<void> setLocale(BuildContext context, Locale newLocale) async {
    final state = context.findAncestorStateOfType<_MyAppState>();
    await state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {

    setImageMultiTypeErrorImage(
      const Opacity(
        opacity: 0.3,
        child: ImageMultiType(
          url: Icons.error_outlined,
          height: 30.0,
          width: 30.0,
        ),
      ),
    );
    super.initState();
  }

  Future<void> setLocale(Locale locale) async {
    AppSharedPreference.cashLocal(locale.languageCode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final loading = Builder(builder: (_) {
      return Visibility(
        visible: context.watch<LoadingCubit>().state.isLoading,
        child: SafeArea(
          child: Column(
            children: [
              const LinearProgressIndicator(),
              Expanded(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      );
    });

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      // designSize: const Size(14440, 972),
      minTextAdapt: true,
      // splitScreenMode: true,
      builder: (context, child) {
        DrawableText.initial(
          headerSizeText: 28.0.sp,
          initialHeightText: 1.5.sp,
          titleSizeText: 20.0.sp,
          initialSize: 16.0.sp,
          renderHtml: false,
          selectable: false,
          initialColor: AppColorManager.black,
        );

        return MaterialApp(
          navigatorKey: sl<GlobalKey<NavigatorState>>(),
          locale: Locale(AppSharedPreference.getLocal),
          scrollBehavior: MyCustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          onGenerateRoute: AppRoutes.routes,
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

BuildContext? get ctx => sl<GlobalKey<NavigatorState>>().currentContext;
