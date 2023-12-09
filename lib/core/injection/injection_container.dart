import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/bloc/loading_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //region Core
  SharedPreferences.getInstance().then((value) => sl.registerLazySingleton(() => value));


  sl.registerLazySingleton(() => LoadingCubit());

  sl.registerLazySingleton(() => GlobalKey<NavigatorState>());

  //endregion

//! External
}
