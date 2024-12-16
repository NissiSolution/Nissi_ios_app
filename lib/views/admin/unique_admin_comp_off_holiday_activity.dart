import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../Supports/checkpassword.dart';
import '../../Supports/constants.dart';
import '../../Supports/preferences_manager.dart';
import '../../Supports/supports.dart';
import '../../Supports/classes.dart';
import '../dialog/dialog.dart';

class UniqueAdminCompOffHolidayPage extends StatefulWidget {
  UniqueAdminCompOffHolidayPage({
    required this.data,
    required this.requestType,
    super.key});

  late String data, requestType;

  @override
  State<UniqueAdminCompOffHolidayPage> createState() => _UniqueAdminCompOffHolidayPageState();
}

class _UniqueAdminCompOffHolidayPageState extends State<UniqueAdminCompOffHolidayPage> {

  late TextEditingController rejReason;
  late PreferencesManager preferencesManager;
  late Supports supports;
  late List<Department> departmentList = [];
  late List<Approval> approvalList = [];
  late int status = 0;
  late bool isLoading = true;
  late String staffId, data, staffName, position, requestedOn, empId, timestamp, rejectedReason, reason, workedHour, requestDate;
  late String title = "", requestType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rejReason = TextEditingController();
    data = widget.data;
    requestType = widget.requestType;
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
      appBar: Constants.appBar(title),
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
                              child: Text(Constants.position, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(position, style: Constants.textStyle1(Constants.signature),)),
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
                              child: Text(Constants.requestDate, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(requestDate, style: Constants.textStyle1(Constants.signature),)),
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
                              child: Text(Constants.reasonC, style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(reason, style: Constants.textStyle1(Constants.signature),)),
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
                                  approveOrReject(Constants.key1);
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

  String getDate(int timestamp) {
    DateFormat format1 = DateFormat("dd-MM-yyyy hh:mm a");
    return format1.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  void declareItem() {
    preferencesManager = PreferencesManager(context);
    supports = Supports(context);
    staffId = preferencesManager.getString(Constants.staffId)!;

    switch (int.parse(requestType)) {
      case 1:
        title = Constants.compOff;
      case 2:
        title = Constants.localHoliday;
      case 3:
        title = Constants.nightShift;
    }

    List<String> list1 = data.split(Constants.splitter4);
    requestDate = list1[0];
    staffName = list1[5];
    timestamp = list1[3];
    requestedOn = getDate(int.parse(list1[3]));
    reason = list1[4];
    position = list1[7];
    empId = list1[8];
    rejectedReason = list1[9];

    getStaffInfo(list1[2]);

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



  void approveOrReject(String theType) async {
    Map<String, String> data = {
      Constants.requestType      : Constants.approveOrReject,
      Constants.type             : theType,
      Constants.staffId          : empId,
      Constants.id               : requestType,
      Constants.timestamp        : timestamp,
      Constants.approverId       : staffId,
      Constants.reason           : rejReason.text.trim(),
      Constants.currentTimestamp : DateTime.now().millisecondsSinceEpoch.toString(),
    };

    try {
      var response = await post(Constants.client, body: data);
      if (response.statusCode == 200) {
        if (response.body == Constants.failure) {
          supports.createSnackBar(Constants.errorMessage);
        } else {
          approvalList.clear();
          List<String> list1 = response.body.split(Constants.splitter1);
          for (int i = 1; i < list1.length; i++) {
            List<String> list4 = list1[i].split(Constants.splitter2);
            Approval approval = Approval(int.parse(list4[0]), int.parse(list4[1]), int.parse(list4[2]));
            approvalList.add(approval);
            status = approval.status;
          }
          setState(() {
            print(response.body);
          });
        }
      } else {
        supports.createSnackBar(Constants.errorMessage);
      }
    } on Exception catch (e) {
      supports.createSnackBar(Constants.errorMessage);
    }

  }

  Map<String, String> mapData() {
    return {
      Constants.requestType      : Constants.approveOrReject,
      Constants.staffId          : empId,
      Constants.id               : requestType,
      Constants.timestamp        : timestamp,
      Constants.approverId       : staffId,
    };
  }

}
