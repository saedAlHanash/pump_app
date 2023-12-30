import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/bloc/login_cubit/login_cubit.dart';
import '../../features/form/bloc/get_form_cubit/get_form_cubit.dart';
import '../../features/form/bloc/update_r_list_cubit/update_r_list_cubit.dart';
import '../../features/history/bloc/export_report_cubit/export_file_cubit.dart';
import '../../features/history/bloc/get_history_cubit/get_history_cubit.dart';
import '../../features/splash/bloc/files_cubit/files_cubit.dart';
import '../../features/splash/bloc/load_data_cubit/load_data_cubit.dart';
import '../app/bloc/loading_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //region Core
  SharedPreferences.getInstance().then((value) => sl.registerLazySingleton(() => value));


  sl.registerFactory(() => LoadingCubit());
  sl.registerFactory(() => LoadDataCubit());
  sl.registerFactory(() => LoginCubit());
  sl.registerFactory(() => GetFormCubit());
  sl.registerFactory(() => UpdateRListCubit());
  sl.registerFactory(() => GetHistoryCubit());
  sl.registerFactory(() => ExportReportCubit());
  sl.registerFactory(() => FilesCubit());

  sl.registerLazySingleton(() => GlobalKey<NavigatorState>());

  //endregion

//! External
}
