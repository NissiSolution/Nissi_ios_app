import 'package:flutter/material.dart';
import '/Supports/checkpassword.dart';

import '../Supports/constants.dart';
import '../Supports/preferences_manager.dart';
import '../Supports/supports.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late Supports supports;
  late String staffId, password;
  late PreferencesManager preferencesManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     declareItem();
    CheckPass(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Constants.company,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: Constants.padding1,
          decoration: Constants.backgroundDecoration,
          child: Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: Constants.backgroundContent,
            child: Column(
              children: <Widget>[
                Expanded(child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(Constants.lLogo, width: 300, alignment: Alignment.center,),
                    ),
                  ),
                )),
                TextButton(onPressed: () {

                }, child: const Text(Constants.licence, style: TextStyle(color: Constants.company, fontStyle: FontStyle.italic)),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void declareItem() {
    preferencesManager = PreferencesManager(context);
    supports = Supports(context);
    fetchData();
  }

  Future<void> fetchData() async {
    Future.delayed(const Duration(seconds: 3), () {
      String? staffId = preferencesManager.getString(Constants.staffId);
      String? password = preferencesManager.getString(Constants.password);
      if (staffId != null && password != null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }



}
