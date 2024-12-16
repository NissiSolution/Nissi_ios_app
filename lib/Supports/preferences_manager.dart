import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

class PreferencesManager {
  BuildContext? context;
  LocalStorage? storage;

  PreferencesManager(BuildContext this.context) {
    storage = LocalStorage('nissi_attendance');
  }

  void setString(String key, String value) {
    storage?.setItem(key, value);
  }

  String? getString(String key) {
    return storage?.getItem(key);
  }

  void setJson(String key, dynamic value) {
    final info = json.encode(value);
    storage?.setItem(key, info);
  }

  dynamic getJson(String head, String key) {
    Map<String, dynamic> info = json.decode(storage?.getItem(head));
    return info[key];
  }

  void deleteItem(String key) {
    storage?.deleteItem(key);
  }

  void clear() {
    storage?.clear();
  }
}

// class PreManager {
//
//   BuildContext? context;
//
//   PreManager(BuildContext this.context) {
//
//   }
//
// }