import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';

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
