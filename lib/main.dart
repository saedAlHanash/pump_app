
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app/app_widget.dart';
import 'core/app/bloc/loading_cubit.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/util/shared_preferences.dart';

//adb shell setprop debug.firebase.analytics.app com.slf.pump_app


final  loggerObject = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    // number of method calls to be displayed
    errorMethodCount: 0,
    // number of method calls if stacktrace is provided
    lineLength: 300,
    // width of the output
    colors: true,
    // Colorful log messages
    printEmojis: false,
    // Print an emoji for each log message
    printTime: false,
  ),
);
late Box<String> memberBox;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();


await Hive.initFlutter();


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

Future<String?> getFilePath(String name) async {
  final Box<String> box = await Hive.openBox('pdf_files');
  return box.get(name);
}