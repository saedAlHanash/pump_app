import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_app/core/strings/enum_manager.dart';
import 'package:pump_app/features/auth/bloc/login_cubit/login_cubit.dart';
import 'package:pump_app/features/auth/ui/pages/login_page.dart';
import 'package:pump_app/features/form/ui/pages/chose_form_page.dart';

import '../core/injection/injection_container.dart' as di;
import '../features/form/bloc/get_form_cubit/get_form_cubit.dart';
import '../features/form/ui/pages/form_page.dart';
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
            builder: (_) => const StartForm());
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
}
