import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'preferences_manager.dart';

import '../../Supports/constants.dart';

class CheckPass{
  late BuildContext? context;
  late String staffId, password;
  late PreferencesManager preferencesManager;

  CheckPass(this.context) {
    preferencesManager = PreferencesManager(context!);
    staffId = preferencesManager.getString(Constants.staffId)!;
    password = preferencesManager.getString(Constants.password)!;
    checkPassword();
  }

  void checkPassword() async {
    Map<String, String> data = {
      Constants.requestType : Constants.checkPassword,
      Constants.staffId     : staffId,
      Constants.password    : password,
    };

    var client = http.Client();
    var response;

    try {
      response = await client.post(Constants.client, body: data);
    } finally {
      if (response.statusCode == 200) {
        if (response.body == Constants.success) {

        } else {
          preferencesManager.clear();
          Navigator.of(context!).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      }
    }

  }
}