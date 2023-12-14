import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../strings/enum_manager.dart';

class AppSharedPreference {
  static const _loadData = '5';
  static const _lang = '14';
  static const _fireToken = '8';
  static const _notificationCount = '9';

  static const _myId = '12';

  static late SharedPreferences _prefs;

  static init(SharedPreferences preferences) async {
    _prefs = preferences;
  }

  static bool get isLoadData => _prefs.getBool(_loadData) ?? false;

  static void loadData() => _prefs.setBool(_loadData, true);

  static void clear() {
    _prefs.clear();
  }

  static void logout() {
    _prefs.clear();
  }

  static void cashFireToken(String token) {
    _prefs.setString(_fireToken, token);
  }

  static String getFireToken() {
    return _prefs.getString(_fireToken) ?? '';
  }

  static void addNotificationCount() {
    var count = getNotificationCount() + 1;
    _prefs.setInt(_notificationCount, count);
  }

  static int getNotificationCount() {
    return _prefs.getInt(_notificationCount) ?? 0;
  }

  static void clearNotificationCount() {
    _prefs.setInt(_notificationCount, 0);
  }

  static void cashMyId(String id) {
    _prefs.setString(_myId, id);
  }

  static String get getMyId => _prefs.getString(_myId) ?? '0';

  static void cashLocal(String langCode) {
    _prefs.setString(_lang, langCode);
  }

  static String get getLocal => _prefs.getString(_lang) ?? 'ar';
}
