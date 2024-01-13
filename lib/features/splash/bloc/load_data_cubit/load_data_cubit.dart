import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/util/shared_preferences.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';

part 'load_data_state.dart';

class LoadDataCubit extends Cubit<LoadDataInitial> {
  LoadDataCubit() : super(LoadDataInitial.initial());

  void setDBData() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    Future.delayed(
      const Duration(seconds: 1),
      () async {
        final exlFile = await FilePicker.platform.pickFiles(
          allowedExtensions: ['xlsx'],
          type: FileType.custom,
        );
        if (exlFile != null) {
          File file = File(exlFile.files.single.path!);

          var bytes = file.readAsBytesSync();
          var excel = Excel.decodeBytes(bytes);

          for (var e in excel.sheets.values) {
            await e.saveInHive();
          }
          AppSharedPreference.loadData();

          emit(state.copyWith(statuses: CubitStatuses.done));
        } else {
          emit(state.copyWith(statuses: CubitStatuses.error, error: 'File Error'));
          // User canceled the picker
        }
      },
    );
  }

  void setPdfFiles() async {
    final pdfFiles = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (pdfFiles != null) {
      final Box<String> box = await Hive.openBox('pdf_files');
      for (var e in pdfFiles.files) {
        box.put(e.name, e.path ?? '');
      }

      await  box.close();
    } else {
      emit(state.copyWith(statuses: CubitStatuses.error, error: 'File Error'));
      // User canceled the picker
    }
  }


  void updateDBData() async {
    final exlFile = await FilePicker.platform.pickFiles(
      allowedExtensions: ['xlsx'],
      type: FileType.custom,
    );

    if (exlFile != null) {
      File file = File(exlFile.files.single.path!);

      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      emit(state.copyWith(statuses: CubitStatuses.loading));
      for (var e in excel.sheets.values) {
        e.updateInHive();
      }
      AppSharedPreference.loadData();
      emit(state.copyWith(statuses: CubitStatuses.done));
    } else {
      emit(state.copyWith(statuses: CubitStatuses.error, error: 'File Error'));
      // User canceled the picker
    }
  }
}
