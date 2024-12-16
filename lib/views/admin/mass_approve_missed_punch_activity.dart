import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../Supports/checkpassword.dart';
import '../../Supports/classes.dart';
import '../../Supports/filter.dart';
import '../dialog/dialog.dart';
import '../../Supports/constants.dart';
import '../../Supports/preferences_manager.dart';
import '../../Supports/supports.dart';

class MassApproveMissedPunchPage extends StatefulWidget {
  const MassApproveMissedPunchPage({super.key});

  @override
  State<MassApproveMissedPunchPage> createState() => _MassApproveMissedPunchPageState();
}

class _MassApproveMissedPunchPageState extends State<MassApproveMissedPunchPage> {

  late String monthValue;
  late String yearValue;
  late String typeValue;
  late int type;
  late PreferencesManager preferencesManager;
  late Supports supports;
  late String staffId, selectedMonth, selectedYear;
  late bool isActive = true, canLoad = true;
  late List<AdminMissedPunch> adminMissedPunchList = [];
  late String select = Constants.selectAll;
  late IconData selectIcon = Icons.select_all;

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
    double textWidth = contentWidth - 150.0;
    double textWidth1 = contentWidth - 150.0;
    double textWidth2 = contentWidth - 230.0 + 30;

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.missedPunchRequest),
        foregroundColor: Colors.white,
        backgroundColor: Constants.company,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case Constants.selectAll:
                  for (int i = 0; i < adminMissedPunchList.length; i++) {
                    adminMissedPunchList[i].isChecked = true;
                  }
                  select = Constants.deSelectAll;
                  selectIcon = Icons.deselect;
                case Constants.deSelectAll:
                  for (int i = 0; i < adminMissedPunchList.length; i++) {
                    adminMissedPunchList[i].isChecked = false;
                  }
                  select = Constants.selectAll;
                  selectIcon = Icons.select_all;
              }
              setState(() {

              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: select,
                child: Row(
                  children: [
                    Icon(selectIcon, color: Constants.company,),
                    const SizedBox(width: 10.0,),
                    Text(select, style: const TextStyle(color: Constants.company),),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
              if (isActive)
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
                                                      getRequestData();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              style: Constants.buttonStyle4(Constants.green),
                              onPressed: () {
                                approveRequest(Constants.key1);
                              },
                              child: const Text(Constants.approveC)),
                          const SizedBox(width: 20.0,),
                          TextButton(
                              style: Constants.buttonStyle4(Constants.red),
                              onPressed: () {
                                approveRequest(Constants.key2);
                              },
                              child: const Text(Constants.rejectC)),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: ListView.builder(
                            itemCount: adminMissedPunchList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TextButton(
                                  style: Constants.buttonStyle2(Constants.company),
                                  onPressed: () {
                                    adminMissedPunchList[index].isChecked = !adminMissedPunchList[index].isChecked;
                                    setState(() {

                                    });
                                  },
                                  child: Container(
                                    decoration: Constants.checkedDecoration(adminMissedPunchList[index].isChecked),
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
                                          mainAxisAlignment: MainAxisAlignment.start,
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
                                                        child: Text(Constants.staffName, style: Constants.textStyle2(Constants.company),)),
                                                    Container(
                                                        alignment: Alignment.center,
                                                        width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                                    SizedBox(
                                                        width: textWidth2,
                                                        child: Text(
                                                          adminMissedPunchList[index].staffName,
                                                          style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,))
                                                  ],
                                                ),
                                                const SizedBox(height: 5.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        width: 90.0,
                                                        child: Text(Constants.workedHour, style: Constants.textStyle2(Constants.company),)),
                                                    Container(
                                                        alignment: Alignment.center,
                                                        width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                                    SizedBox(
                                                        width: textWidth2,
                                                        child: Text(
                                                          adminMissedPunchList[index].period,
                                                          style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,))
                                                  ],
                                                ),
                                                const SizedBox(height: 5.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        width: 90.0,
                                                        child: Text(Constants.dateC, style: Constants.textStyle2(Constants.company),)),

                                                    Container(
                                                        alignment: Alignment.center,
                                                        width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),

                                                    SizedBox(
                                                        width: textWidth2,
                                                        child: Text(
                                                          adminMissedPunchList[index].date,
                                                          style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                                  ],
                                                ),
                                                const SizedBox(height: 5.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        width: 90.0,
                                                        child: Text(Constants.status, style: Constants.textStyle2(Constants.company),)),
                                                    Container(
                                                        alignment: Alignment.center,
                                                        width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                                    SizedBox(
                                                        width: textWidth2,
                                                        child: Text(
                                                          supports.getStatus(adminMissedPunchList[index].status),
                                                          style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(width: 10.0,),
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
    type = 1;
    getRequestData();
    fDelay();
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
      Constants.requestType : Constants.getMissedPunchApprovalRequest,
      Constants.staffId     : staffId,
      Constants.month       : selectedMonth,
      Constants.year        : selectedYear,
    };

    var response = await post(url, body: data);

    if (response.statusCode == 200) {
      handleRequestData(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void handleRequestData(String response) {
    adminMissedPunchList.clear();
    List<String> list1 = response.split(Constants.splitter3);

    for (int i = 1; i < list1.length; i++) {
      List<String> list2 = list1[i].split(Constants.splitter4);
      AdminMissedPunch missedPunch = AdminMissedPunch(list2[0], list2[5],
          "From ${list2[9]} to ${list2[10]}", list1[i], supports.getCurrentStatus(list2[2]),
          int.parse(list2[3]), false);
      adminMissedPunchList.add(missedPunch);
    }

    adminMissedPunchList = Filter().filterAdminMissedPunch(adminMissedPunchList, type);

    setState(() {
      isActive = false;
    });
  }

  void approveRequest(String type) {
    bool ch = false;
    for (int i = 0; i < adminMissedPunchList.length; i++) {
      if (adminMissedPunchList[i].isChecked) {
        ch = true;
        break;
      }
    }
    if (ch) {
      if (type == Constants.key1) {
        approveOrReject(Constants.key1);
      } else {
        showDialog(context: context, builder: (BuildContext context) => Dialog(
          child: MassRejectDialog(data: mapData()),
        )).then((value){
          if (value != null) {
            Navigator.pop(context);
          }
        });
      }
    } else {
      supports.createSnackBar("No item selected");
    }
  }

  void approveOrReject(String type) async {
    Map<String, String> data = {
      Constants.requestType      : Constants.massApproveOrReject,
      Constants.type             : type,
      Constants.staffId          : getStaffId(),
      Constants.id               : getRequestType(),
      Constants.timestamp        : getTimestamp(),
      Constants.approverId       : staffId,
      Constants.reason           : "empty",
      Constants.currentTimestamp : DateTime.now().millisecondsSinceEpoch.toString(),
    };

    var client = Client();
    var response;
    try {
      response = await post(Constants.client, body: data);
    } finally {
      if (response.statusCode == 200) {
        if (response.body == Constants.success) {
          Navigator.pop(context);
        } else {
          supports.createSnackBar(response.body);
          supports.createSnackBar(Constants.errorMessage);
        }
      }
    }
  }

  Map<String, String> mapData() {
    return {
      Constants.requestType      : Constants.massApproveOrReject,
      Constants.staffId          : getStaffId(),
      Constants.id               : getRequestType(),
      Constants.timestamp        : getTimestamp(),
      Constants.approverId       : staffId,
    };
  }

  String getStaffId() {
    String theData = "The data";
    for (int i = 0; i < adminMissedPunchList.length; i++) {
      List<String> list1 = adminMissedPunchList[i].theData.split(Constants.splitter4);
      if (adminMissedPunchList[i].isChecked) {
        theData = "$theData-${list1[8]}";
      }
    }
    return theData;
  }

  String getRequestType() {
    String theData = "The data";
    for (int i = 0; i < adminMissedPunchList.length; i++) {
      List<String> list1 = adminMissedPunchList[i].theData.split(Constants.splitter4);
      if (adminMissedPunchList[i].isChecked) {
        theData = "$theData-10";
      }
    }
    return theData;
  }

  String getTimestamp() {
    String theData = "The data";
    for (int i = 0; i < adminMissedPunchList.length; i++) {
      List<String> list1 = adminMissedPunchList[i].theData.split(Constants.splitter4);
      if (adminMissedPunchList[i].isChecked) {
        theData = "$theData-${list1[3]}";
      }
    }
    return theData;
  }

}
