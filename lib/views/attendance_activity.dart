import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '/Supports/checkpassword.dart';

import '../Supports/classes.dart';
import '../Supports/constants.dart';
import '../Supports/preferences_manager.dart';
import '../Supports/supports.dart';
import '../custom/custom_calender_picker.dart';
import '../custom/custom_time.dart';
import 'dialog/dialog.dart';
import 'employee/comp_off_holiday_activity.dart';
import 'employee/night_shift_activity.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage({
    required this.type,
    super.key});

  late int type;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {

  late PreferencesManager preferencesManager;
  late Supports supports;
  late String staffId, selectedType, selectedDate, staffName, employeeId, requestDate, requestType, nightShiftOn, password;
  late bool isLoading = true, isExist = true, canCheck = false, isTimeIn = true, canLoad = true, isNightShift = false, isNightShiftTimeIn = true;
  AttendanceSelectionCharacter? attendanceCharacter = AttendanceSelectionCharacter.punchInOut;
  late List<DateTime?> selectedDateTime = [];
  late List<CheckedData> checkedDataList = [];
  late int year, month, day;
  late final TextEditingController _reason;
  late LatLng currentLatLng;
  late String? reasonError;
  late int type;

  @override
  void initState() {
    // TODO: implement initState
    _reason = TextEditingController();
    reasonError = null;
    type = widget.type;
    declareItem();
    CheckPass(context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _reason.dispose();
    super.dispose();
  }

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _goToMyLocation() async {
    Position position = await getUserCurrentLocation();
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<CameraPosition> myPos() async {
    Position position = await getUserCurrentLocation();
    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
    );
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double contentWidth = width - 60.0;
    double textWidth = contentWidth - 240.0;

    return Scaffold(
      appBar: Constants.appBar(Constants.attendance),
      backgroundColor: Constants.company,
      body: Container(
        alignment: Alignment.center,
        padding: Constants.padding1,
        child: Container(
          alignment: Alignment.center,
          decoration: Constants.backgroundContent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (isLoading)
                Expanded(child:
                Center(
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
                                                      getStaffData();
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
                Column(
                  children: [
                    Container(
                      padding: Constants.padding1,
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(staffName, style: Constants.textStyle3(Constants.company),),
                          const SizedBox(height: 10.0,),
                          Text(employeeId, style: Constants.textStyle3(Constants.company),),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isLoading)
                  Expanded(child: SingleChildScrollView(
                    child: Container(
                      padding: Constants.padding5,
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0,),
                          Container(
                            decoration: Constants.backgroundRecycler,
                            child: Padding(
                              padding: Constants.padding1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Radio<AttendanceSelectionCharacter>(
                                            fillColor: MaterialStateColor.resolveWith((states) => Constants.company),
                                            value: AttendanceSelectionCharacter.punchInOut,
                                            groupValue: attendanceCharacter,
                                            onChanged: (AttendanceSelectionCharacter? value) {
                                              setState(() {
                                                attendanceCharacter = value;
                                                requestType = Constants.key10;
                                                getDate();
                                                checkIsDateExists();
                                              });
                                            },
                                          ),
                                          SizedBox(
                                              width: 100.0,
                                              child: Text(Constants.punchInOut, style: Constants.textStyle2(Constants.company),))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio<AttendanceSelectionCharacter>(
                                            fillColor: MaterialStateColor.resolveWith((states) => Constants.company),
                                            value: AttendanceSelectionCharacter.nightShift,
                                            groupValue: attendanceCharacter,
                                            onChanged: (AttendanceSelectionCharacter? value) {
                                              setState(() {
                                                attendanceCharacter = value;
                                                requestType = Constants.key3;
                                                getDate();
                                                checkIsDateExists();
                                              });
                                            },
                                          ),
                                          SizedBox(
                                              width: 100.0,
                                              child: Text(Constants.nightShift, style: Constants.textStyle2(Constants.company),))
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Radio<AttendanceSelectionCharacter>(
                                            fillColor: MaterialStateColor.resolveWith((states) => Constants.company),
                                            value: AttendanceSelectionCharacter.compOff,
                                            groupValue: attendanceCharacter,
                                            onChanged: (AttendanceSelectionCharacter? value) {
                                              setState(() {
                                                attendanceCharacter = value;
                                                requestType = Constants.key1;
                                                checkIsDateExists();
                                              });
                                            },
                                          ),
                                          SizedBox(
                                              width: 100.0,
                                              child: Text(Constants.compOff, style: Constants.textStyle2(Constants.company),))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio<AttendanceSelectionCharacter>(
                                            fillColor: MaterialStateColor.resolveWith((states) => Constants.company),
                                            value: AttendanceSelectionCharacter.localHoliday,
                                            groupValue: attendanceCharacter,
                                            onChanged: (AttendanceSelectionCharacter? value) {
                                              setState(() {
                                                attendanceCharacter = value;
                                                requestType = Constants.key2;
                                                checkIsDateExists();
                                              });
                                            },
                                          ),
                                          SizedBox(
                                              width: 100.0,
                                              child: Text(Constants.localHoliday, style: Constants.textStyle2(Constants.company),))
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0,),
                                  if (attendanceCharacter == AttendanceSelectionCharacter.punchInOut)
                                    Column(
                                      children: [
                                        Container(
                                          decoration: Constants.backgroundRecycler,
                                          padding: const EdgeInsets.all(5.0),
                                          child: SizedBox(
                                            width: 250.0,
                                            height: 250.0,
                                            child: Stack(
                                              children: [
                                                GoogleMap(
                                                  mapType: MapType.terrain,
                                                  initialCameraPosition: _kGooglePlex,
                                                  myLocationEnabled: true,
                                                  onMapCreated: (GoogleMapController controller) {
                                                    if (!_controller.isCompleted) {
                                                      _controller.complete(controller);
                                                    }
                                                    _goToMyLocation();
                                                    },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Text(selectedDate, style: Constants.textStyle6(Constants.company, 20.0),),
                                        const CustomTime(),
                                          if (canCheck && attendanceCharacter == AttendanceSelectionCharacter.punchInOut)
                                            Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                style: enableButtonStyle(isTimeIn, Constants.green, Constants.lightGreen),
                                                  // style:Constants.buttonStyle4(Constants.green),
                                                  onPressed: (){
                                                    if (isTimeIn) {
                                                      checkInOut(Constants.key1);
                                                    }
                                                  },
                                                  child: const Text(Constants.timeInC)),
                                              const SizedBox(width: 25.0,),
                                              TextButton(
                                                style: enableButtonStyle(!isTimeIn, Constants.red, Constants.lightRed),
                                                  // style:Constants.buttonStyle4(Constants.red),
                                                  onPressed: (){
                                                    if (!isTimeIn) {
                                                      checkInOut(Constants.key2);
                                                    }
                                                  },
                                                  child: const Text(Constants.timeOutC)),
                                            ],
                                          ),
                                        if (canCheck && attendanceCharacter == AttendanceSelectionCharacter.nightShift)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                  style: enableButtonStyle(isNightShiftTimeIn, Constants.green, Constants.lightGreen),
                                                  // style:Constants.buttonStyle4(Constants.green),
                                                  onPressed: (){
                                                    if (isNightShiftTimeIn) {
                                                      checkInOut(Constants.key1);
                                                    }
                                                  },
                                                  child: const Text(Constants.timeInC)),
                                              const SizedBox(width: 25.0,),
                                              TextButton(
                                                  style: enableButtonStyle(!isNightShiftTimeIn, Constants.red, Constants.lightRed),
                                                  // style:Constants.buttonStyle4(Constants.red),
                                                  onPressed: (){
                                                    if (!isNightShiftTimeIn) {
                                                      checkInOut(Constants.key2);
                                                    }
                                                  },
                                                  child: const Text(Constants.timeOutC)),
                                            ],
                                          ),
                                      ],
                                    ),
                                  if (attendanceCharacter == AttendanceSelectionCharacter.compOff ||
                                      attendanceCharacter == AttendanceSelectionCharacter.localHoliday ||
                                      attendanceCharacter == AttendanceSelectionCharacter.nightShift)
                                    Column(
                                      children: [
                                        Container(
                                          decoration: Constants.backgroundRecycler,
                                          child: CustomCalenderPicker(
                                            isOneMonth: true,
                                            onValueChanged: (value){
                                              selectedDateTime = [value];
                                              getDate2();
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            TextField(
                                              style: const TextStyle(color: Constants.company),
                                              controller: _reason,
                                              obscureText: false,
                                              decoration: Constants.inputDecoration1(Constants.reasonC, const Icon(Icons.message), Constants.company, Constants.company, Constants.company, Constants.signature),
                                            ),
                                            if (reasonError != null)
                                              Text(reasonError!, style: Constants.textStyle1(Constants.redText),),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Text(selectedDate, style: Constants.textStyle6(Constants.company, 20.0),),
                                        const SizedBox(height: 10.0,),
                                        TextButton(
                                          style: enableButtonStyle(isExist, Constants.signature, Constants.company),
                                            onPressed: (){
                                             if (isExist) {

                                             } else {
                                               sendHolidayOrCompOff();
                                             }
                                            }, child: const Text(Constants.sendRequestC,))
                                      ],
                                    )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          if (attendanceCharacter == AttendanceSelectionCharacter.punchInOut)
                            for (CheckedData c in checkedDataList)
                              Container(
                              decoration: Constants.checkInStatusDecoration(c.status),
                              child: SizedBox(
                                height: 40.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (c.status == 1)
                                      Text("${Constants.punchedInAt} ${dateTime(c.dateTime)}", style: Constants.textStyle1(Constants.green),),
                                    if (c.status == 2)
                                      Text("${Constants.punchedOutAt} ${dateTime(c.dateTime)}", style: Constants.textStyle1(Constants.redText),),
                                  ],
                                ),
                              ),
                            ),
                        ],
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

  String dateTime(DateTime value) {
    DateFormat dateFormat1 = DateFormat("hh:mm a");
    return dateFormat1.format(value);
  }

  void declareItem() {
    preferencesManager = PreferencesManager(context);
    supports = Supports(context);
    staffId = preferencesManager.getString(Constants.staffId)!;
    setInitial();
    fDelay();
  }

  Future<void> fDelay() {
    return Future<void>.delayed(const Duration(seconds: 10), () => setState(() {
      canLoad=false;
    })
    );
  }

  void setInitial() {
    getDate();
    requestType = Constants.key10;
    selectedDateTime.add(DateTime.now());
    var dateN = DateTime.timestamp();
    year = dateN.year;
    month = dateN.month;
    day = dateN.day;
    getStaffData();
  }

  void getStaffData() async {
    Map<String, String> data = {
      Constants.requestType : Constants.fetchData,
      Constants.staffId     : staffId,
    };
    var response = await http.post(Constants.client, body: data);
    
    if (response.statusCode == 200) {
      handleStaffData(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void handleStaffData(String response) {
    List<String> list1 = response.split("-");
    staffName = list1[0];
    employeeId = list1[1];
    getCheckInOut1();
  }

  void getCheckInOut1() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.getCheckedData,
      Constants.staffId     : staffId,
    };
    var response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      handleCheckedInOut(response.body);
      checkIsDateExists();
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }
  
  void getDate() {
    DateTime dateTime = DateTime.now();
    var dateFormatter1 = DateFormat('dd-MM-yyyy');
    var dateFormatter2 = DateFormat('yyyy-MM-dd');
    selectedDate = dateFormatter1.format(dateTime);
    nightShiftOn = dateFormatter1.format(dateTime);
    requestDate = dateFormatter2.format(dateTime);
  }

  void getDate2() {
    DateTime? dateTime = selectedDateTime[0];
    var dateFormatter1 = DateFormat('dd-MM-yyyy');
    var dateFormatter2 = DateFormat('yyyy-MM-dd');
    setState(() {
      selectedDate = dateFormatter1.format(dateTime!);
      requestDate = dateFormatter2.format(dateTime);
      checkIsDateExists();
    });
  }

  void checkIsDateExists() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.checkIsTheRequestExist,
      Constants.staffId     : staffId,
      Constants.date        : requestDate,
      Constants.type        : requestType,
    };
    var response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      setState(() {
        isExist = (response.body == Constants.exists);
        if (requestType == Constants.key10) {
          canCheck = (response.body != Constants.exists);
          isExist = true;
        }
      });
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void getCheckInOut() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.getCheckedData,
      Constants.staffId     : staffId,
    };
    var response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      handleCheckedInOut(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
    setState(() {

    });
  }

  void handleCheckedInOut(String response) {
    checkedDataList.clear();
    if (response.isNotEmpty) {
      List<String> list1 = response.split("&");
      for (String data in list1) {
        List<String> list2 = data.split("--");
        CheckedData checkedData = CheckedData(DateTime.parse(list2[0]), int.parse(list2[1]));
        checkedDataList.add(checkedData);
        isTimeIn = (checkedData.status != 1);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  ButtonStyle enableButtonStyle(bool condition, Color trueColor, Color falseColor) {
    if (condition) {
      return Constants.buttonStyle4(trueColor);
    } else {
      return Constants.buttonStyle4(falseColor);
    }
  }

  void sendHolidayOrCompOff() async {
    if (_reason.text.isNotEmpty) {
      var url = Uri.parse(Constants.databaseLink);
      Map<String, String> data = {
        Constants.requestType : Constants.holidayOrCompOff,
        Constants.staffId     : staffId,
        Constants.fromDate    : requestDate,
        Constants.reason      : _reason.text,
        Constants.type        : requestType,
        Constants.timestamp   : DateTime.now().millisecondsSinceEpoch.toString(),
        Constants.workHours   : Constants.key10,
        Constants.fromTime    : Constants.fromTime,
        Constants.toTime      : Constants.toTime,
      };
      var response = await http.post(url, body: data);
      if (response.statusCode == 200) {
        handleSuccess();
      } else {
        supports.createSnackBar(Constants.errorMessage);
      }
    } else {
      reasonError = Constants.required;
      setState(() {

      });
    }
  }

  void handleSuccess() {
    supports.createSnackBar(Constants.dataSentSuccessfully);
    if (type == 1) {
      if (requestType == Constants.key1 || requestType == Constants.key2) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CompOffHolidayPage()));
      } else if (requestType == Constants.key3) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NightShiftPage()));
      }
    } else {
      Navigator.pop(context, Constants.success);
    }
  }

  void checkInOut(String key) async {
    Position position = await getUserCurrentLocation();
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType  : Constants.checkInOut,
      Constants.staffId      : staffId,
      Constants.typeCheck    : key,
      Constants.type         : "W",
      Constants.routePointId : Constants.key0,
      Constants.workplaceId  : Constants.key0,
      Constants.latitude     : position.latitude.toString(),
      Constants.longitude    : position.longitude.toString(),
    };

    var response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      getCheckInOut();
      handleCheckedResponse(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }

  }

  void handleCheckedResponse(String response) {
    // todo handle response
    showDialog(context: context, builder: (BuildContext context) => Dialog(
      child: CheckedStatus(response: response,),
    ));
  }

}
