import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../Supports/checkpassword.dart';
import '../../Supports/classes.dart';
import '../../Supports/constants.dart';
import '../../Supports/preferences_manager.dart';
import '../../Supports/supports.dart';
import '../dialog/dialog.dart';

class AdminUniqueLeavePage extends StatefulWidget {
  AdminUniqueLeavePage({
    required this.data,
    required this.leaveType,
    super.key});

  late String data, leaveType;

  @override
  State<AdminUniqueLeavePage> createState() => _AdminUniqueLeavePageState();
}

class _AdminUniqueLeavePageState extends State<AdminUniqueLeavePage> {

  late bool isLoading = true;
  late String staffId, data, leaveType, staffName, department, requestedOn, empId, timestamp, id, key, asOnDate, rejectedReason;
  late int status = 0, availableDays, appliedDays, halfDay = 0;
  late PreferencesManager preferencesManager;
  late Supports supports;
  late String? purpose, period, duration, reason;
  late List<Approval> approvalList = [];
  late List<Department> departmentList = [];
  late TextEditingController rejReason;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.data;
    leaveType = widget.leaveType;
    rejReason = TextEditingController();
    declareItem();
    CheckPass(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    rejReason.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double contentWidth = width - 60.0;
    double textWidth1 = contentWidth - 150.0;
    double textWidth2 = contentWidth - 230.0 + 30;

    return Scaffold(
      appBar: Constants.appBar(Constants.leaveRequest),
      body: Container(
        decoration: const BoxDecoration(color: Constants.company),
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
                  child: Container(
                      padding: Constants.padding1,
                      child: const CircularProgressIndicator(color: Constants.company, strokeWidth: 4.0,)),
                ),)
              else
                Expanded(child: Container(
                  padding: Constants.padding1,
                  child:
                  Column(
                    children: [
                      const SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(Constants.informationC, style: Constants.textStyle6(Constants.company, 18.0),)],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text(Constants.staffName, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(staffName, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text(Constants.departmentC, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(department, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text(Constants.leaveType, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(leaveType, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text(Constants.purposeC, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(purpose!, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text(Constants.requestedOn, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(requestedOn, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text(Constants.period, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(period!, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text(Constants.availableDays, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(asOnDate, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text(Constants.appliedDays, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(duration!, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text(Constants.reasonC, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(reason!, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      if (status == 2)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120.0,
                                child: Text(Constants.rejectedReason, style: Constants.textStyle2(Constants.company),),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                              SizedBox(
                                  width: textWidth1,
                                  child: Text(rejectedReason, style: Constants.textStyle1(Constants.signature),)),
                              const SizedBox(width: 10,),
                            ]
                        ),
                      if (status == 2)
                        const SizedBox(height: 10.0,),
                      Expanded(child: ListView.builder(
                          itemCount: approvalList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TextButton(
                                style: Constants.buttonStyle2(Constants.company),
                                onPressed: () {

                                },
                                child: Container(
                                  decoration: Constants.statusDecoration(approvalList[index].status),
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
                                                      width: 80.0,
                                                      child: Text(Constants.approver, style: Constants.textStyle2(Constants.company),)),

                                                  Container(
                                                      alignment: Alignment.center,
                                                      width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                                  SizedBox(
                                                      width: textWidth2,
                                                      child: Text(
                                                        supports.getApproverName(approvalList[index].staffId, departmentList),
                                                        style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,))
                                                ],
                                              ),
                                              const SizedBox(height: 5.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 80.0,
                                                      child: Text(Constants.position, style: Constants.textStyle2(Constants.company),)),
                                                  Container(
                                                      alignment: Alignment.center,
                                                      width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                                  SizedBox(
                                                      width: textWidth2,
                                                      child: Text(
                                                        supports.getApproverPosition(approvalList[index].staffId, departmentList),
                                                        style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,))
                                                ],
                                              ),
                                              const SizedBox(height: 5.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 80.0,
                                                      child: Text(Constants.status, style: Constants.textStyle2(Constants.company),)),
                                                  Container(
                                                      alignment: Alignment.center,
                                                      width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                                  SizedBox(
                                                      width: textWidth2,
                                                      child: Text(
                                                        supports.getStatus2(approvalList[index].status, getDate(approvalList[index].timestamp)),
                                                        style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,))
                                                ],
                                              ),
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
                      ),
                      if (status == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                style: Constants.buttonStyle4(Constants.green),
                                onPressed: () {
                                  if (appliedDays <= availableDays) {
                                    approveOrReject(Constants.key1);
                                  } else {
                                    showDialog(context: context,
                                        builder: (BuildContext context) =>
                                           Dialog(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    decoration: Constants.backgroundRecycler,
                                                    child: Padding(
                                                      padding: Constants.padding1,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(Constants.sendLOPLeaveRequest,
                                                            style: Constants.textStyle6(Constants.company, 18.0),),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
                                                            child: Text(Constants.insufficientLeave, style: Constants.textStyle1(Constants.company),),),
                                                          const SizedBox(height: 5.0,),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              TextButton(
                                                                  style: Constants.buttonStyle4(Constants.red),
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                    },
                                                                  child: const Text(Constants.cancelC)),
                                                              const SizedBox(width: 20.0,),
                                                              TextButton(
                                                                  style: Constants.buttonStyle4(Constants.green),
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                    approveOrReject(Constants.key1);
                                                                  },
                                                                  child: const Text(Constants.approveC)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                          )
                                        );
                                  }
                                },
                                child: const Text(Constants.approveC)),
                            const SizedBox(width: 20.0,),
                            TextButton(
                                style: Constants.buttonStyle4(Constants.red),
                                onPressed: () {
                                  showDialog(context: context, builder: (BuildContext context) => Dialog(
                                    child: RejectDialog(data: mapData()),
                                  )).then((value){
                                    if (value != null) {
                                      getStaffInfo(value);
                                    }
                                  });
                                },
                                child: const Text(Constants.rejectC)),
                            ],
                        ),
                    ],
                  ),
                )),
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

    List<String> list1 = data.split(Constants.splitter4);
    staffName = list1[0];
    department = list1[9];
    requestedOn = getDate(int.parse(list1[7]));
    availableDays = int.parse(list1[11]);
    empId = list1[10];
    timestamp = list1[7];
    id = list1[6];
    key = list1[4];
    halfDay = int.parse(list1[13]);

    if (int.parse(list1[11]) == 1 || int.parse(list1[11]) == 0) {
      asOnDate = "${list1[11]} day";
    } else {
      asOnDate = "${list1[11]} days";
    }
    rejectedReason = list1[12];

    getLeaveData(list1[4], list1[5]);
  }

  void getLeaveData(String value1, String value2) async {
    Map<String, String> data = {
      Constants.requestType : Constants.getCurrentLeaveData,
      Constants.type        : value1,
    };
    var response = await post(Constants.client, body: data);
    if (response.statusCode == 200) {
      List<String> list1 = response.body.split(Constants.splitter2);
      purpose = list1[2];
      List<String> listA = list1[0].split(" ");
      List<String> listB = list1[1].split(" ");
      appliedDays = int.parse(list1[6]);
      if (listA[0] == listB[0]) {
        period = "On ${getDate2(listA[0])}";
        duration = "${list1[6]} day";
      } else {
        period = "From ${getDate2(listA[0])} to ${getDate2(listB[0])}";
        if (list1[6] == Constants.key1) {
          duration = "${list1[6]} day";
        } else {
          duration = "${list1[6]} days";
        }
      }
      reason = list1[3];
      getStaffInfo(value2);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void getStaffInfo(String theData) async {
    departmentList.clear();
    approvalList.clear();
    List<String> list1 = theData.split(Constants.splitter1);
    List<String> list2 = list1[1].split(Constants.splitter2);

    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> tData = {
      Constants.requestType : Constants.getAllDepartmentInfo,
      Constants.staffId     : list2[0],
    };
    var response = await post(url, body: tData);
    if (response.statusCode == 200) {
      for (int i = 1; i < list1.length; i++) {
        List<String> list4 = list1[i].split(Constants.splitter2);
        Approval approval = Approval(int.parse(list4[0]), int.parse(list4[1]), int.parse(list4[2]));
        approvalList.add(approval);
        status = approval.status;
      }
      List<String> list3 = response.body.split(Constants.splitter1);
      for (int i = 1; i < list3.length; i++) {
        List<String> list4 = list3[i].split(Constants.splitter2);
        Department department = Department(int.parse(list4[0]), int.parse(list4[1]), list4[2], list4[3]);
        departmentList.add(department);
      }
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  String getDate(int timestamp) {
    DateFormat format1 = DateFormat("dd-MM-yyyy hh:mm a");
    return format1.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  String getDate2(String theData) {
    List<String> list1 = theData.split("-");
    return "${list1[2]}-${list1[1]}-${list1[0]}";
  }

  void approveOrReject(String theType) async {
    Map<String, String> data = {
      Constants.requestType      : Constants.approveOrRejectLeave,
      Constants.type             : theType,
      Constants.staffId          : empId,
      Constants.id               : id,
      Constants.data             : key,
      Constants.timestamp        : timestamp,
      Constants.approverId       : '2',
      Constants.reason           : rejReason.text,
      Constants.currentTimestamp : DateTime.now().millisecondsSinceEpoch.toString(),
    };

    var response = await post(Constants.client, body: data);
    if (response.statusCode == 200) {
      handleResponse(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void handleResponse(String response) {
    if (response == Constants.failure) {
      supports.createSnackBar(Constants.errorMessage);
    } else {
      // Navigator.pop(context, response);
      getStaffInfo(response);
    }
  }

  Map<String, String> mapData() {
    return {
      Constants.requestType      : Constants.approveOrRejectLeave,
      Constants.staffId          : empId,
      Constants.id               : id,
      Constants.data             : key,
      Constants.timestamp        : timestamp,
      Constants.approverId       : '2',
    };
  }

}
