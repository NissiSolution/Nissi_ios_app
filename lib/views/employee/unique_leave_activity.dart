import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';

import '../../Supports/checkpassword.dart';
import '../../Supports/classes.dart';
import '../../Supports/constants.dart';
import '../../Supports/preferences_manager.dart';
import '../../Supports/supports.dart';

class UniqueLeavePage extends StatefulWidget {
  UniqueLeavePage({
    required this.leaveType,
    required this.data,
    super.key});

  late String leaveType, data;

  @override
  State<UniqueLeavePage> createState() => _UniqueLeavePageState();
}

class _UniqueLeavePageState extends State<UniqueLeavePage> {

  late String? leaveType = Constants.leaveType, purpose = Constants.purpose,
      requestedOn = Constants.requestedOn, period = Constants.period, duration = Constants.duration,
      reason = Constants.reasonC, rejectedReason = Constants.rejectedReason, staffId, data, startDate, endDate;
  late PreferencesManager preferencesManager;
  late Supports supports;
  late int status = 0, halfDay = 0;
  late bool isLoading = true, canLoad = true;
  late List<Approval> approvalList = [];
  late List<Department> departmentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    leaveType = widget.leaveType;
    data = widget.data;
    declareItem();
    CheckPass(context);
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
                                                      setInitial();
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
                            child: Text(Constants.leaveType, style: Constants.textStyle2(Constants.company),),
                          ),
                          Container(
                              alignment: Alignment.center,
                              width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                          SizedBox(
                              width: textWidth1,
                              child: Text(leaveType!, style: Constants.textStyle1(Constants.signature),)),
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
                            child: Text(Constants.purpose, style: Constants.textStyle2(Constants.company),),
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
                              child: Text(requestedOn!, style: Constants.textStyle1(Constants.signature),)),
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
                            child: Text(Constants.duration, style: Constants.textStyle2(Constants.company),),
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
                    if (halfDay == 3 || halfDay == 1)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text("${Constants.halfDay} ${Constants.on}", style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(startDate!, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                    if (halfDay == 3 || halfDay == 1)
                      const SizedBox(height: 10.0,),
                    if (halfDay == 3 || halfDay == 2)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: Text("${Constants.halfDay} ${Constants.on}", style: Constants.textStyle2(Constants.company),),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                            SizedBox(
                                width: textWidth1,
                                child: Text(endDate!, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
                    if (halfDay == 3 || halfDay == 2)
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
                                child: Text(rejectedReason!, style: Constants.textStyle1(Constants.signature),)),
                            const SizedBox(width: 10,),
                          ]
                      ),
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
                                                      style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 5,))
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
                                                      style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 5,))
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
                                                      style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 5,))
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
                    )
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
    setInitial();
    fDelay();
  }

  Future<void> fDelay() {
    return Future<void>.delayed(const Duration(seconds: 10), () => setState(() {
      canLoad=false;
    }));
  }

  void setInitial() async {
    List<String>? list1 = data?.split(Constants.splitter4);
    requestedOn = getDate(int.parse(list1![4]));
    getLeaveData(list1[2], list1[3]);
    rejectedReason = list1[10];
    halfDay = int.parse(list1[11]);
  }

  String getDate(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: false);
    var dateFormatter = DateFormat('dd-MM-yyyy hh:mm a');
    return dateFormatter.format(dateTime);
  }

  void getLeaveData(String theData, String theData2) async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> tData = {
      Constants.requestType : Constants.getCurrentLeaveData,
      Constants.type        : theData,
    };
    var response = await post(url, body: tData);
    if (response.statusCode == 200) {
      List<String> list1 = response.body.split(Constants.splitter2);
      purpose = list1[2];
      List<String> listA = list1[0].split(" ");
      List<String> listB = list1[1].split(" ");
      startDate = getDate2(listA[0]);
      endDate = getDate2(listB[0]);
      if (list1[0] == list1[1]) {
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
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
    getStaffInfo(theData2);
  }

  String getDate2(String theData) {
    List<String> list1 = theData.split("-");
    return "${list1[2]}-${list1[1]}-${list1[0]}";
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

}
