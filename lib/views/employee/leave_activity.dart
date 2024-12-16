import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '/views/employee/unique_leave_activity.dart';

import '../../Supports/checkpassword.dart';
import '../../Supports/classes.dart';
import '../../Supports/preferences_manager.dart';
import '../../Supports/supports.dart';
import '../../Supports/constants.dart';
import '../../Supports/filter.dart';
import '../dialog/dialog.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {

  late String monthValue;
  late String yearValue;
  late String typeValue;
  late int type;

  late List<String> leaveList = [];
  late List<LeaveL> leaveLList = [];
  late List<LeaveData> leaveDataList = [];
  late List<RemainL> remainLList = [];
  late PreferencesManager preferencesManager;
  late Supports supports;
  late String staffId, selectedMonth, selectedYear;
  bool isLoading = true, canLoad = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    declareItem();
    updateViewed();
    CheckPass(context);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double contentWidth = width - 60.0;
    double textWidth = contentWidth - 225.0;

    return Scaffold(
      appBar: Constants.appBar(Constants.leaveInformation),
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
                                                      getLeaveType();
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
                  padding: Constants.padding1,
                  child: Column(
                    children: [
                      const SizedBox(width: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 50.0,
                              child: Text(Constants.period, style: Constants.textStyle2(Constants.company),)),
                          const SizedBox(width: 5.0,),
                          Text(Constants.colan, style: Constants.textStyle2(Constants.company),),
                          const SizedBox(width: 10.0,),
                          DropdownButton<String>(
                            value: monthValue,
                            elevation: 16,
                            style: const TextStyle(color: Constants.company),
                            underline: Container(
                              height: 2,
                              color: Constants.signature,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                monthValue = value!;
                                selectedMonth = supports.twoDigit(Constants.monthList.indexOf(monthValue));
                                getRequestData();
                              });
                              },
                            items: Constants.monthList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(width: 10.0,),
                          DropdownButton<String>(
                            value: yearValue,
                            elevation: 16,
                            style: const TextStyle(color: Constants.company),
                            underline: Container(
                              height: 2,
                              color: Constants.signature,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                yearValue = value!;
                                selectedYear = yearValue;
                                getRequestData();
                              });
                            },
                            items: Constants.yearList().map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 50.0,
                              child: Text(Constants.typeC, style: Constants.textStyle2(Constants.company),)),
                          const SizedBox(width: 5.0,),
                          Text(Constants.colan, style: Constants.textStyle2(Constants.company),),
                          const SizedBox(width: 10.0,),
                          DropdownButton<String>(
                            value: typeValue,
                            elevation: 16,
                            style: const TextStyle(color: Constants.company),
                            underline: Container(
                              height: 2,
                              color: Constants.signature,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                typeValue = value!;
                                type = Constants.typeList.indexOf(typeValue);
                              });
                            },
                            items: Constants.typeList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                                style: Constants.buttonStyle(Constants.company),
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Dialog.fullscreen(
                                      child:
                                      LeaveDialog(leaveLList: leaveLList, leaveList: leaveList, remainLList: remainLList, staffId: staffId,),
                                    )
                                  ).then((value) => {
                                    if (value == Constants.success) {
                                      getRequestData()
                                    }
                                  });
                                }, child: const Text(Constants.applyForLeave)
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text(Constants.yourBalanceLeaveDays, style: Constants.textStyle2(Constants.company),)],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (RemainL remainL in remainLList)
                            SizedBox(
                              width: 60.0,
                              height: 70.0,
                              child: Container(
                                padding: Constants.padding4,
                                child: Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: Constants.backgroundDecoration2,
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 10.0,),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(width: 15.0,),
                                              Column(
                                                children: [
                                                  Text(remainL.leaveType, style: Constants.textStyle2(Colors.white),),
                                                  const SizedBox(height: 2.0,),
                                                  Text(remainL.remainingDays, style: Constants.textStyle2(Colors.white),),
                                                ],
                                              ),
                                              const SizedBox(width: 15.0,),],
                                          ),
                                          const SizedBox(height: 10.0,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Expanded(
                        flex: 7,
                        child: ListView.builder(
                          itemCount: Filter().filterLeaveData(leaveDataList, type).length,
                          itemBuilder: (BuildContext context, int index) {
                            return TextButton(
                                style: Constants.buttonStyle2(Constants.company),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => UniqueLeavePage(data: Filter().filterLeaveData(leaveDataList, type)[index].theData,
                                      leaveType: Filter().filterLeaveData(leaveDataList, type)[index].type,))
                                  );
                                  },
                                child: Container(
                                  decoration: Constants.statusDecoration(Filter().filterLeaveData(leaveDataList, type)[index].status),
                                  padding: Constants.padding3,
                                  width: contentWidth,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 30.0,
                                            child: Text(supports.threeDigit(index + 1), style: Constants.textStyle2(Constants.company),),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10.0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 90.0,
                                                child: Text(Constants.period, style: Constants.textStyle2(Constants.company),)),

                                              Container(
                                                alignment: Alignment.center,
                                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                              SizedBox(
                                                width: textWidth,
                                                child: Text(
                                                  supports.getPeriod(Filter().filterLeaveData(leaveDataList, type)[index].startDate, Filter().filterLeaveData(leaveDataList, type)[index].endDate),
                                                  style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,))
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 85.0,
                                                  child: Text(Constants.duration, style: Constants.textStyle2(Constants.company),)),
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                              SizedBox(
                                                  width: textWidth,
                                                  child: Text(
                                                    supports.getDuration(Filter().filterLeaveData(leaveDataList, type)[index].duration),
                                                    style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,))
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 85.0,
                                                  child: Text(Constants.leaveType, style: Constants.textStyle2(Constants.company),)),
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                              SizedBox(
                                                  width: textWidth,
                                                  child: Text(
                                                    Filter().filterLeaveData(leaveDataList, type)[index].type,
                                                    style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,))
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 85.0,
                                                  child: Text(Constants.status, style: Constants.textStyle2(Constants.company),)),
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                              SizedBox(
                                                  width: textWidth,
                                                  child: Text(
                                                    supports.getStatus(Filter().filterLeaveData(leaveDataList, type)[index].status),
                                                    style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,)),

                                            ],
                                          )
                                        ],
                                      ),
                                          if (Filter().filterLeaveData(leaveDataList, type)[index].status == 0)
                                            IconButton(
                                                onPressed: () {
                                                  deleteData(Filter().filterLeaveData(leaveDataList, type)[index].id, index);
                                                  }, icon: const Icon(Icons.delete, color: Colors.red,)),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            );
                          }
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
    var date = DateTime.timestamp();
    var mon = date.month;
    var yea = date.year;

    monthValue = Constants.monthList[mon];
    selectedMonth = supports.twoDigit(mon);
    yearValue = yea.toString();
    selectedYear = yea.toString();
    typeValue = Constants.typeList[0];
    type = 0;
    getLeaveType();
    fDelay();
  }

  Future<void> fDelay() {
    return Future<void>.delayed(const Duration(seconds: 10), () => setState(() {
      canLoad=false;
    })
    );
  }

  void getLeaveType() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.getLeaveType,
    };
    var response = await post(url, body: data);
    if (response.statusCode == 200) {
      handleLeaveResponse(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void handleLeaveResponse(String response) {
    leaveList.clear();
    leaveLList.clear();
    leaveList.add(Constants.select);
    List<String> list1 = response.split(Constants.splitter1);
    for (var i = 1; i < list1.length; i++) {
      List<String> list2 = list1[i].split(Constants.splitter2);
      LeaveL leaveL = LeaveL(list2[0], list2[1], list2[2]);
      leaveList.add(list2[0]);
      leaveLList.add(leaveL);
    }

    getAllLeaveData();
  }

  void getAllLeaveData() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.getAllLeaveBalance,
      Constants.staffId     : staffId,
      Constants.date        : DateTime.now().year.toString(),
    };
    var response = await post(url, body: data);
    if (response.statusCode == 200) {
      handleAllLeaveResponse(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void handleAllLeaveResponse(String response) {
    remainLList.clear();
    List<String> list1 = response.split(Constants.splitter1);
    for (int i = 1; i < list1.length; i++) {
      List<String> list2 = list1[i].split(Constants.splitter2);
      RemainL remainL = RemainL(list2[0], list2[1], list2[2]);
      remainLList.add(remainL);
    }
    getRequestData();
  }

  void getRequestData() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.getLeaveRequestData,
      Constants.staffId     : staffId,
      Constants.month       : selectedMonth,
      Constants.year        : selectedYear,
    };
    var response = await post(url, body: data);
    if (response.statusCode == 200) {
      handleRequestData(response.body);
    }
  }

  void handleRequestData(String response) {
    leaveDataList = [];
    List<String> list1 = response.split(Constants.splitter3);
    for (int i = 1; i < list1.length; i++) {
      List<String> list2 = list1[i].split(Constants.splitter4);
      String theType = getLeaveTypes(list2[5]);
      LeaveData theData = LeaveData(list2[0], list2[1], theType, supports.getCurrentStatus(list2[3]), int.parse(list2[8]), list1[i], int.parse(list2[9]), int.parse(list2[4]));
      leaveDataList.add(theData);
    }

    setState(() {
      isLoading = false;
    });
  }

  String getLeaveTypes(String theType) {
    for (int i = 0;  i < leaveLList.length; i++) {
      if (leaveLList[i].slug == theType) {
        return leaveLList[i].typeName;
      }
    }
    return "Unknown";
  }

  void deleteData(int id, int index) async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.deleteData,
      Constants.id          : id.toString(),
      Constants.type        : Constants.key1,
    };
    var response = await post(url, body: data);
    if (response.statusCode == 200) {
      if (response.body == Constants.success) {
        setState(() {
          leaveDataList.removeAt(index);
        });
      } else {
        supports.createSnackBar(Constants.errorMessage);
      }
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void updateViewed() async {
    Map<String, String> data = {
      Constants.requestType : Constants.updateViewed,
      Constants.staffId     : staffId,
      Constants.type        : Constants.key0,
    };
    var client = Client();
    var response;
    try {
      response = await post(Constants.client, body: data);
    } finally {
      if (response.statusCode == 200) {

      }
    }
  }

}
