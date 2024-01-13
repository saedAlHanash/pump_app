import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/main.dart';

import '../../features/form/bloc/get_form_cubit/get_form_cubit.dart';
import '../../features/form/bloc/update_r_list_cubit/update_r_list_cubit.dart';
import '../../features/history/bloc/export_report_cubit/export_file_cubit.dart';
import '../../features/splash/bloc/files_cubit/files_cubit.dart';
import '../../features/splash/bloc/load_data_cubit/load_data_cubit.dart';
import '../../generated/l10n.dart';
import '../../router/app_router.dart';
import '../app_theme.dart';
import '../injection/injection_container.dart';
import '../strings/app_color_manager.dart';
import '../util/shared_preferences.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
    loggerObject.w(MediaQuery.of(context).size);
    return ScreenUtilInit(
      designSize: const Size(800.0, 1232.0),
      minTextAdapt: true,
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
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          builder: (context, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<LoadDataCubit>()),
                BlocProvider(create: (_) => sl<ExportReportCubit>()),
                BlocProvider(create: (_) => sl<UpdateRListCubit>()),
                BlocProvider(create: (_) => sl<FilesCubit>()..getFiles()),
                BlocProvider(create: (_) => sl<GetFormCubit>()..getAllForm()),
              ],
              child: child!,
            );
          },
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
