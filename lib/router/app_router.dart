import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_app/features/auth/bloc/login_cubit/login_cubit.dart';
import 'package:pump_app/features/auth/ui/pages/login_page.dart';
import 'package:pump_app/features/form/ui/pages/chose_form_page.dart';
import 'package:pump_app/features/history/ui/pages/answers_page.dart';
import 'package:pump_app/features/home/ui/pages/home_screen.dart';
import 'package:pump_app/features/home/ui/pages/settings.dart';

import '../core/injection/injection_container.dart' as di;
import '../features/db/models/app_specification.dart';
import '../features/form/ui/pages/form_page.dart';
import '../features/history/bloc/get_history_cubit/get_history_cubit.dart';
import '../features/history/ui/pages/history_page.dart';
import '../features/splash/ui/pages/files_page.dart';
import '../features/splash/ui/pages/load_data_page.dart';
import '../features/splash/ui/pages/splash_screen_page.dart';

class AppRoutes {
  static Route<dynamic> routes(RouteSettings settings) {
    var screenName = settings.name;

    switch (screenName) {
      //region auth

      case RouteName.splash:
        //region
        return MaterialPageRoute(builder: (_) => const SplashScreenPage());
      //endregion
      case RouteName.loadData:
        //region
        return MaterialPageRoute(builder: (_) => const LoadData());
      //endregion

      case RouteName.login:
        //region
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => di.sl<LoginCubit>(),
                    ),
                  ],
                  child: const LoginPage(),
                ));
      //endregion

      //endregion

      //region form

      case RouteName.choseForm:
        //region
        return MaterialPageRoute(builder: (_) => const ChoseFormePage());
      //endregion
      case RouteName.startForm:
        //region
        return MaterialPageRoute(
          builder: (_) => const StartForm(),
        );
      //endregion

      //endregion

      //region home

      case RouteName.home:
        //region
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      //endregion

      case RouteName.settings:
        //region
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      //endregion

      //endregion

      //region Files

      case RouteName.files:
        //region
        return MaterialPageRoute(builder: (_) => const FilesPage());
      //endregion

      //endregion

      //region history

      case RouteName.history:
        //region
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => di.sl<GetHistoryCubit>()..getAllHistory()),
                  ],
                  child: const HistoryPage(),
                ));

      //endregion
      case RouteName.answers:
        //region
        return MaterialPageRoute(
          builder: (_) =>
              AnswersPage(list: (settings.arguments ?? <Questions>[]) as List<Questions>),
        );
      //endregion

      //endregion
    }

    return MaterialPageRoute(builder: (_) => const Scaffold(backgroundColor: Colors.red));
  }
}

class RouteName {
  static const splash = '/';
  static const loadData = '/1';
  static const login = '/2';
  static const choseForm = '/3';
  static const startForm = '/4';
  static const history = '/5';
  static const home = '/6';
  static const answers = '/7';
  static const files = '/8';
  static const settings = '/9';
}
