import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:nissi/Supports/checkpassword.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Supports/constants.dart';
import '../../Supports/preferences_manager.dart';
import '../../Supports/supports.dart';
import '../custom/custom_calender.dart';
import '../custom/custom_calender_1.dart';
//import 'attendance_activity.dart';
import 'attendance_activity.dart';
import 'hr_activity.dart';
import 'location/guest_house_activity.dart';
//import 'location/guest_house_activity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late PreferencesManager preferencesManager;
  late Supports supports;
  late String staffId, password;
  late int notificationCount = 0;
  late bool isLoading = true, loadName = false, loadMyDetails = false, canLoad = true;
  late List<DateType> dateTypeList = [];
  late List<DateType2> dateTypeList2 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    declareItem();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(Constants.nissi),
          foregroundColor: Colors.white,
          backgroundColor: Constants.company,
          actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: (String result) {
                  switch (result) {
                    case Constants.logOut:
                      preferencesManager.clear();
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: Constants.logOut,
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Constants.company,),
                        SizedBox(width: 10.0,),
                        Text(Constants.logOut, style: TextStyle(color: Constants.company),),
                      ],
                    ),
                  ),
                ],
              ),
          ],),
        backgroundColor: Constants.company,
        body: Container(
          alignment: Alignment.center,
          padding: Constants.padding1,
          child: Container(
            alignment: Alignment.center,
            decoration: Constants.backgroundContent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (isLoading)
                  Expanded(child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (canLoad)
                          Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                          padding: Constants.padding1,
                                          child: const CircularProgressIndicator(color: Constants.company, strokeWidth: 4.0,)
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        if (!canLoad)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: Constants.backgroundRecycler,
                                        padding: Constants.padding1,
                                        width: 340.0,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(Constants.unableMessage, style: Constants.textStyle3(Constants.company),),
                                            const SizedBox(height: 10.0,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                    style: Constants.buttonStyle4(Constants.red),
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(Constants.cancelC)
                                                ),
                                                const SizedBox(width: 20.0,),
                                                TextButton(
                                                    style: Constants.buttonStyle4(Constants.company),
                                                    onPressed: (){
                                                      setState(() {
                                                        canLoad = true;
                                                        fDelay();
                                                        checkPassword();
                                                      });
                                                    },
                                                    child: const Text(Constants.retryC)
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  )
                  )
                else
                  Expanded(child: Container(
                    padding: Constants.padding2,
                    child: SingleChildScrollView(
                      child: Column(
                          children: [const SizedBox(height: 10),
                            Container(
                                decoration: Constants.backgroundRecycler,
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: CustomCalender2(
                                    month: DateTime.now().month,
                                    year: DateTime.now().year,
                                    dateTypeList: dateTypeList2,
                                    staffId: staffId,),
                                )),

                            Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        style: Constants.buttonStyle3(),
                                        onPressed: () async {
                                          if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
                                            navigatePage(context);
                                          } else {
                                              Map<Permission, PermissionStatus> status = await [
                                                Permission.locationWhenInUse,
                                                Permission.storage,
                                              ].request();
                                            }
                                          },
                                          child: Constants.imageColumn(Constants.lChecked, Constants.attendance)
                                      ),
                                      const SizedBox(width: 20.0,),
                                      TextButton(
                                          style: Constants.buttonStyle3(),
                                          onPressed: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GuestHousePage())).then((value) => getCurrentDateInfo());
                                            },
                                          child: Constants.imageColumn(Constants.lGuestHouse, Constants.guestHouseLocation)
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextButton(
                                          style: Constants.buttonStyle3(),
                                          onPressed: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HrPage())).then((value) => getCurrentDateInfo());
                                          }, child: Constants.imageColumn4(Constants.lHr, Constants.humanResources, notificationCount)
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextButton(
                                          style: Constants.buttonStyle3(),
                                          onPressed: (){

                                          }, child: Constants.imageColumn(Constants.lDimSupport, Constants.support)
                                      ),
                                      const SizedBox(width: 20.0,),
                                      TextButton(
                                          style: Constants.buttonStyle3(),
                                          onPressed: (){

                                      }, child: Constants.imageColumn(Constants.lDimSos, Constants.sos)
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            )
                          ]
                      ),
                    ),
                  )),

                Constants.licenceButton,
              ],
            ),
          ),
        ),
      );
  }

  void declareItem() async {
    preferencesManager = PreferencesManager(context);
    supports = Supports(context);
    staffId = preferencesManager.getString(Constants.staffId)!;
    password = preferencesManager.getString(Constants.password)!;
    // CheckPass(context, staffId, password);
    checkPassword();
    fDelay();
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
          loadDetails();
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      }
    }

  }

  Future<void> fDelay() {
    return Future<void>.delayed(const Duration(seconds: 10), () => setState(() {
      canLoad=false;
    }));
  }

  void loadDetails() async {
    Map<String, String> data = {
      Constants.requestType : Constants.fetchData,
      Constants.staffId     : staffId,
    };

    var client = http.Client();
    var response;
    try {
      response = await client.post(Constants.client, body: data);
    } finally {
      loadName = true;
      if (response.statusCode == 200) {
        List<String> theList = response.body.split('-');
        supports.createSnackBar("Welcomes ${theList[0]}");
        client.close();
        getMyDetailsInfo();
      } else {
        supports.createSnackBar(response.statusCode as String);
      }
    }
  }

  void getMyDetailsInfo() async {
    Map<String, String> data = {
      Constants.requestType : Constants.getMyDetailsInfo,
      Constants.staffId     : staffId,
      Constants.date        : "${DateTime.now().year}-${supports.twoDigit(DateTime.now().month)}",
    };
    var client = http.Client();
    var response;
    try {
      response = await http.post(Constants.client, body: data);
    } finally {
      if (response.statusCode == 200) {
        loadMyDetails = true;
        handleMyDetails(response.body);
      } else {
        supports.createSnackBar(Constants.errorMessage);
      }
      client.close();
    }
  }

  void handleMyDetails(String response) {
    dateTypeList.clear();
    dateTypeList2.clear();
    List<String> list1 = response.split(Constants.splitter1);
    for (int i = 1; i < list1.length; i++) {
      try {
        List<String> list2 = list1[i].split(Constants.splitter2);
        DateType dateType = DateType(list2[0], DateTime.parse(list2[1]));
        dateTypeList.add(dateType);
        DateType2 dateType2 = DateType2(list2[0], DateTime.parse(list2[1]));
        dateTypeList2.add(dateType2);
      } on Exception {
        supports.createSnackBar(Constants.errorMessage);
      }
    }
    setState(() {
      isLoading = false;
      getCurrentDateInfo();
    });
  }

  void getCurrentDateInfo() async {
    if (DateTime.now().weekday != 7) {
      Map<String, String> data = {
        Constants.requestType : Constants.currentDateCheck,
        Constants.staffId     : staffId,
      };

      var client = http.Client();
      var response;
      try {
        response = await http.post(Constants.client, body: data);
      } finally {
        if (response.statusCode == 200) {
          loadMyDetails = true;
          handleCurrentDate(response.body);
        } else {
          supports.createSnackBar(Constants.errorMessage);
        }
        client.close();
      }

    } else {
      checkNotification();
    }
  }

  void handleCurrentDate(String response) {
    List<String> list1 = response.split(Constants.splitter2);
    DateType dateType = DateType(list1[0], DateTime.now());
    dateTypeList.add(dateType);
    DateType2 dateType2 = DateType2(list1[0], DateTime.now());
    dateTypeList2.add(dateType2);
    setState(() {
      checkNotification();
    });
  }

  Future<void> navigatePage(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AttendancePage(type: 1))
    ).then((value) => getCurrentDateInfo());

    getCurrentDateInfo();
  }

  void checkNotification() async {
    Map<String, String> data = {
      Constants.requestType : Constants.getNotification,
      Constants.staffId     : staffId,
    };
    var client = http.Client();
    var response;
    try {
      response = await client.post(Constants.client, body: data);
    } finally {
      if (response.statusCode == 200) {
        setState(() {
          handleNotification(response.body);
        });
      } else {
        supports.createSnackBar(response.stausCode.toString());
      }
    }
  }

  void handleNotification(String response) {
    List<String> list1 = response.split(Constants.splitter1);
    notificationCount = 0;

    for (int i = 1; i < list1.length; i++) {
      List<String> list2 = list1[i].split(Constants.splitter2);
      if (int.parse(list2[5]) == 0) {
        notificationCount++;
      }
    }
    setState(() {

    });
  }

  void checkPermission() async {


    if (Platform.isIOS) {
      var status = await Permission.locationWhenInUse.status;

      if (!status.isGranted) {
        await [
          Permission.locationWhenInUse,
          Permission.storage,
        ].request();
      }

    } else {
      if (await Permission.locationWhenInUse.serviceStatus.isDisabled) {
        await [
          Permission.locationWhenInUse,
          Permission.storage,
        ].request();
      }
    }
  }

}
