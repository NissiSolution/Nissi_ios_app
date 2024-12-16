import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Supports/constants.dart';
import '../../Supports/preferences_manager.dart';
import '../../Supports/supports.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late final TextEditingController _email;
  late final TextEditingController _password;
  late Supports supports;
  late PreferencesManager preferencesManager;
  late bool isClicked = false;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isClicked = false;
    supports = Supports(context);
    preferencesManager = PreferencesManager(context);
    return Scaffold(
      backgroundColor: Constants.company,
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: Constants.company),
          padding: const EdgeInsets.fromLTRB(15.0, 55.0, 15.0, 15.0),
          child: Container(
            decoration: Constants.backgroundContent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0),
                  child: Column(
                    children: [const SizedBox(height: 10),
                    Image.asset('assets/images/logo.png', width: 300,),
                    const SizedBox(height: 20),
                    TextField(
                      style: const TextStyle(color: Constants.company),
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: Constants.inputDecoration1(Constants.enterEmail,
                          const Icon(Icons.email), Constants.company, Constants.company,
                      Constants.company, Constants.signature)
                    ),
                    const SizedBox(height: 15.0,),
                    TextField(
                      style: const TextStyle(color: Constants.company),
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: Constants.inputDecoration1(Constants.enterPassword,
                          const Icon(Icons.lock), Constants.company, Constants.company,
                        Constants.company, Constants.signature
                      ),
                    ),

                    const SizedBox(height: 15),
                    if (!isClicked)
                      TextButton(
                        style: Constants.buttonStyle(Constants.company),
                        onPressed: () {
                          checkCondition();
                        },
                        child: const Text(Constants.login, style: Constants.buttonTextStyle,),
                      ),
                      if (isClicked)
                        const CircularProgressIndicator(color: Constants.signature,)
                    ]
                  ),
                )),

                TextButton(onPressed: () {

                }, child: const Text(Constants.licence, style: TextStyle(color: Constants.company, fontStyle: FontStyle.italic)),)
              ],
            ),
          ),
        ),
    );
  }

  void checkCondition() {
    String? email = _email.text;
    String? password = _password.text;
    if (email.isEmpty) {
      supports.createSnackBar("Email required");
    } else if(password.isEmpty) {
      supports.createSnackBar("Password required");
    } else {
      setState(() {
        isClicked = true;
      });
      sendLogin(email, password);
    }
  }

  void sendLogin(String email, String password) async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.auth,
      Constants.email       : email,
      Constants.password    : password,
    };
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      handlerResponse(response.body, password);
    } else {
      supports.createSnackBar(Constants.errorMessage);
      setState(() {
        isClicked = false;
      });
    }
  }

  void handlerResponse(String response, String password) async {
    List<String> spRes = response.split('-');
    var theRes = spRes[0];
    if (theRes == Constants.empty) {
      supports.createSnackBar(Constants.emailError);
      isClicked = false;
    } else if (theRes.trim() == Constants.error) {
      supports.createSnackBar(Constants.passwordError);
      isClicked = false;
    } else {
      supports.createSnackBar(Constants.loginSuccess);
      preferencesManager.setString(Constants.staffId, theRes);
      preferencesManager.setString(Constants.password, password);
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
    setState(() {

    });
  }

}
