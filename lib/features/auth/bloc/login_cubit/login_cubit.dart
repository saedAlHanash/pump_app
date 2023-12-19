import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/util/shared_preferences.dart';
import 'package:pump_app/features/auth/data/request/login_request.dart';

import '../../../../core/error/error_manager.dart';
import '../../../../core/strings/app_string_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/abstraction.dart';
import '../../../../core/util/pair_class.dart';
import '../../../../generated/l10n.dart';
import '../../../db/models/item_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginInitial> {
  LoginCubit() : super(LoginInitial.initial());

  void login() {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        final pair = await _loginApi();

        if (pair.first == null) {
          emit(state.copyWith(statuses: CubitStatuses.error, error: pair.second));
          showErrorFromApi(state);
        } else {
          emit(state.copyWith(statuses: CubitStatuses.done, result: pair.first));
        }
      },
    );
  }

  Future<Pair<bool?, String?>> _loginApi() async {
    final box = await Hive.openBox<String>(AppStringManager.usersTable);

    for (var e in box.values) {
      final user = ItemModel.fromJson(jsonDecode(e));
      if (user.id != state.request.phoneOrEmail) continue;

      if (user.name == state.request.password) {
        AppSharedPreference.cashMyId(user.fKey);
        return Pair(true, null);
      }
    }
    return Pair(null, S().badCredential);
  }

  set setPhoneOrEmail(String? phoneOrEmail) => state.request.phoneOrEmail = phoneOrEmail;

  set setPassword(String? password) => state.request.password = password;

  String? get validatePhoneOrEmail {
    if (state.request.phoneOrEmail.isBlank) {
      return '${S().email} - ${S().phoneNumber}'
          ' ${S().is_required}';
    }
    return null;
  }

  String? get validatePassword {
    if (state.request.password.isBlank) {
      return '${S().password} ${S().is_required}';
    }
    return null;
  }
}
