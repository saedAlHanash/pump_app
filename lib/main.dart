import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'core/app/app_widget.dart';
import 'core/app/bloc/loading_cubit.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/util/shared_preferences.dart';

//adb shell setprop debug.firebase.analytics.app com.slf.pump_app
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  await SharedPreferences.getInstance().then((value) {
    AppSharedPreference.init(value);
  });
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<LoadingCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}