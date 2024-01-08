import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/util/shared_preferences.dart';
import 'package:pump_app/main.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/strings/app_string_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';
import '../../../../core/util/pair_class.dart';

part 'files_state.dart';

class FilesCubit extends Cubit<FilesInitial> {
  FilesCubit() : super(FilesInitial.initial());

  Future<void> getFiles() async {
    final d = (await getDownloadsDirectory())?.listSync() ?? <FileSystemEntity>[];
    final l = <XFile>[];
    final ls = <FileStat>[];
    for (var e in d) {
      if (e is File) {
        l.add(XFile(e.path));
        ls.add(await FileStat.stat(e.path));
      } else if (e is Directory) {
        print(e.path);
      }
    }
    emit(
      state.copyWith(statuses: CubitStatuses.done, result: l, request: ls),
    );
  }

  Future<void> clearAll() async {
    final d = (await getDownloadsDirectory())?.listSync() ?? <FileSystemEntity>[];
    final l = <XFile>[];
    final ls = <FileStat>[];
    for (var e in d) {
      if (e is File) {
        await File(e.path).delete();
      } else if (e is Directory) {
        print(e.path);
      }
    }
    emit(
      state.copyWith(statuses: CubitStatuses.done, result: l, request: ls),
    );
  }
}
