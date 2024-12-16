import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../../Supports/checkpassword.dart';
import '../../Supports/classes.dart';
import '../../Supports/constants.dart';
import '../../Supports/preferences_manager.dart';
import '../../Supports/supports.dart';


class MapHistoryPage extends StatefulWidget {
  const MapHistoryPage({super.key});

  @override
  State<MapHistoryPage> createState() => _MapHistoryPageState();
}

class _MapHistoryPageState extends State<MapHistoryPage> {

  late PreferencesManager preferencesManager;
  late Supports supports;
  late String staffId, selectedStaff, selectedId, selectedType, selectedDate;
  bool isLoading = true, canLoad = true;
  late List<String> staffNameList = [], staffIdList = [];
  late List<CheckedInfo> checkedInfoList = [];
  PunchSelectionCharacter? punchCharacter = PunchSelectionCharacter.all;
  Set<Marker> mapMarkersSet = {};

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(12.0, 80.1),
    zoom: 5,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    declareItem();
    CheckPass(context);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double contentWidth = width - 60.0;
    double textWidth = contentWidth - 240.0;

    return Scaffold(
      appBar: Constants.appBar(Constants.punchedInformation),
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
                                                      getDirectEmployee();
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
                ),)
              else
                Expanded(child: Container(
                  padding: Constants.padding1,
                  child: Column(
                    children: [
                      const SizedBox(width: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: selectedStaff,
                            elevation: 16,
                            style: const TextStyle(color: Constants.company),
                            underline: Container(
                              height: 2,
                              color: Constants.signature,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                selectedStaff = value!;
                                selectedId = staffIdList[staffNameList.indexOf(selectedStaff)];
                                getRequestData();
                              });
                            },
                            items: staffNameList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(width: 10.0,),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                            title: Text(Constants.all, style: Constants.textStyle2(Constants.company),),
                            leading: Radio<PunchSelectionCharacter>(
                              fillColor: MaterialStateColor.resolveWith((states) => Constants.company),
                              value: PunchSelectionCharacter.all,
                              groupValue: punchCharacter,
                              onChanged: (PunchSelectionCharacter? value) {
                                setState(() {
                                  punchCharacter = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(Constants.punchedIn, style: Constants.textStyle2(Constants.company),),
                            leading: Radio<PunchSelectionCharacter>(
                              fillColor: MaterialStateColor.resolveWith((states) => Constants.company),
                              value: PunchSelectionCharacter.punchedIn,
                              groupValue: punchCharacter,
                              onChanged: (PunchSelectionCharacter? value) {
                                setState(() {
                                  punchCharacter = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(Constants.punchedOut, style: Constants.textStyle2(Constants.company),),
                            leading: Radio<PunchSelectionCharacter>(
                              fillColor: MaterialStateColor.resolveWith((states) => Constants.company),
                              value: PunchSelectionCharacter.punchedOut,
                              groupValue: punchCharacter,
                              onChanged: (PunchSelectionCharacter? value) {
                                setState(() {
                                  punchCharacter = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Text(selectedDate, style: Constants.textStyle2(Constants.company),),
                          const SizedBox(width: 15.0,),
                          TextButton(
                              style: Constants.buttonStyle4(Constants.signature),
                              onPressed: () {

                              }, child: const Text(Constants.pickDateC)
                          ),
                          const SizedBox(width: 15.0,),
                          TextButton(
                              style: Constants.buttonStyle4(Constants.green),
                              onPressed: () {
                                getRequestData();
                              }, child: const Text(Constants.filterC)
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Expanded(child: GoogleMap(
                        mapType: MapType.terrain,
                        initialCameraPosition: _kGooglePlex,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          getRequestData();
                        },
                        markers: mapMarkersSet,
                      ),
                      )
                    ],
                  ),
                )
                ),
              Constants.licenceButton,
            ],
          ),
        ),
      ),
    );
  }

  void declareItem() {
    preferencesManager = PreferencesManager(context);
    supports = Supports(context);
    staffId = preferencesManager.getString(Constants.staffId)!;
    setInitial();
  }

  void setInitial() {
    selectedDate = getDate();
    getDirectEmployee();
    fDelay();
  }

  void getDirectEmployee() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.getDirectEmployee,
      Constants.staffId     : staffId,
    };
    var response = await post(url, body: data);
    if (response.statusCode == 200) {
      handleDirectEmployee(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void handleDirectEmployee(String response) {
    staffIdList.clear();
    staffNameList.clear();
    staffNameList.add("All Staffs");
    staffIdList.add("0");
    selectedStaff = staffNameList[0];
    selectedId = staffIdList[0];
    selectedType = "0";
    List<String> list1 = response.split(Constants.splitter1);
    for (int i = 1; i < list1.length; i++) {
      List<String> list2 = list1[i].split(Constants.splitter2);
      staffIdList.add(list2[0]);
      staffNameList.add(list2[1]);
    }

    getRequestData();
  }

  Future<void> fDelay() {
    return Future<void>.delayed(const Duration(seconds: 10), () => setState(() {
      canLoad=false;
    })
    );
  }

  void getRequestData() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.getDirectEmployeeInfo,
      Constants.staffId     : staffId,
      Constants.date        : getDate2(),
      Constants.reason      : selectedId,
      Constants.type        : selectedType
    };
    var response = await post(url, body: data);

    if (response.statusCode == 200) {
      handleRequestData(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void handleRequestData(String response) {
    mapMarkersSet.clear();
    List<String> list1 = response.split(Constants.splitter1);

    if (list1.length == 1) {
      supports.createSnackBar("No data found");
    }

    for (int i = 1; i < list1.length; i++) {
      List<String> list2 = list1[i].split(Constants.splitter2);
      setMarker(list2[0], getDate3(list2[3]), double.parse(list2[1]), double.parse(list2[2]), int.parse(list2[4]));
    }
    setState(() {
      isLoading = false;
    });
  }

  void setMarker(String name, String time, double longitude, double latitude, int type) {
    Marker marker;
    if (type == 1) {
      marker = Marker(markerId: MarkerId(name + time),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: name, snippet: "${Constants.punchedInAt} $time")
      );
    } else {
      marker = Marker(markerId: MarkerId(name + time),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: name, snippet: "${Constants.punchedOutAt} $time")
      );
    }
    mapMarkersSet.add(marker);
  }

  String getDate() {
    DateTime dateTime = DateTime.now();
    var dateFormatter = DateFormat('dd-MM-yyyy');
    return dateFormatter.format(dateTime);
  }

  String getDate2() {
    List<String> list1 = selectedDate.split("-");
    return "${list1[2]}-${list1[1]}-${list1[0]}";
  }

  String getDate3(String date) {
    DateTime dateTime1 = DateTime.parse(date);
    DateFormat format1 = DateFormat("dd-MM-yyyy hh:mm a");
    return format1.format(dateTime1);
  }

}
