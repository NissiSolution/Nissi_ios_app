import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../Supports/classes.dart';
import '../../Supports/constants.dart';
import '../../Supports/supports.dart';
import '../../custom/custom_calender_picker.dart';

class LeaveDialog extends StatefulWidget {

  LeaveDialog({
    required this.leaveLList,
    required this.leaveList,
    required this.remainLList,
    required this.staffId,
    super.key,
  });

  late List<String> leaveList;
  late List<RemainL> remainLList;
  late String staffId;
  late List<LeaveL> leaveLList;

  @override
  State<LeaveDialog> createState() => _LeaveDialogState();
}

class _LeaveDialogState extends State<LeaveDialog> {

  late TextEditingController purpose, fromDate, toDate, reason;
  late List<String> leaveList;
  late String leaveValue, totalDays = Constants.key0;
  bool isExist = true;
  late String? _purpose, _fromTime, _toTime, _reason, _leaveType;
  late List<DateTime?> startDateTime = [], endDateTime = [];
  late String staffId, requestDate, endDate;
  late Supports supports;
  late List<RemainL> remainLList;
  late List<LeaveL> leaveLList;
  late bool isFirstHalf, isSecondHalf, isFirstHalfActive, isSecondHalfActive;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    purpose = TextEditingController();
    fromDate = TextEditingController();
    toDate = TextEditingController();
    reason = TextEditingController();
    leaveList = widget.leaveList;
    leaveValue = leaveList[0];
    remainLList = widget.remainLList;
    leaveLList = widget.leaveLList;
    staffId = widget.staffId;
    declareItem();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    purpose.dispose();
    fromDate.dispose();
    toDate.dispose();
    reason.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double contentWidth = width - 60.0;
    double textWidth = contentWidth - 240.0;
    
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: Constants.padding1,
                alignment: Alignment.topLeft,
                decoration: Constants.backgroundRecycler,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Constants.leaveType, style: Constants.textStyle2(Constants.company),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DropdownButton<String>(
                            value: leaveValue,
                            elevation: 16,
                            style: const TextStyle(color: Constants.company),
                            underline: Container(
                              height: 2,
                              color: Constants.signature,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                leaveValue = value!;
                                _leaveType = leaveTypeError();
                              });
                            },
                            items: leaveList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          if (_leaveType != null)
                            Text(_leaveType!, style: Constants.textStyle1(Constants.redText),),
                        ],
                      ),
                    ),
                    Text(Constants.leaveInformation, style: Constants.textStyle2(Constants.company),),
                    const SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _purpose = purposeError();
                                  });
                                },
                                controller: purpose,
                                obscureText: false,
                                style: Constants.textStyle1(Constants.company),
                                decoration: Constants.inputDecoration1(Constants.purposeC,
                                    null, Constants.company, Constants.company, Constants.company, Constants.signature),
                              ),
                              if (_purpose != null)
                                Text(_purpose!, style: Constants.textStyle1(Constants.redText),)
                            ],
                          ),
                          const SizedBox(height: 10.0,),
                          Row(children: [
                            Text(Constants.totalLeaveDaysC, style: Constants.textStyle1(Constants.company),),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                              child: Text(Constants.colan, style: Constants.textStyle1(Constants.company),),
                            ),
                            if (leaveList.indexOf(leaveValue) == 0)
                              Text(Constants.key0, style: Constants.textStyle1(Constants.signature),),
                            if (leaveList.indexOf(leaveValue) != 0)
                              Text(remainLList[leaveList.indexOf(leaveValue)-1].totalDays, style: Constants.textStyle1(Constants.signature),),
                          ],),
                          const SizedBox(height: 10.0,),
                          Row(children: [
                            Text(Constants.remainingLeaveDaysC, style: Constants.textStyle1(Constants.company),),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                              child: Text(Constants.colan, style: Constants.textStyle1(Constants.company),),
                            ),
                            if (leaveList.indexOf(leaveValue) == 0)
                              Text(Constants.key0, style: Constants.textStyle1(Constants.signature),),
                            if (leaveList.indexOf(leaveValue) != 0)
                              Text(remainLList[leaveList.indexOf(leaveValue)-1].remainingDays, style: Constants.textStyle1(Constants.signature),),
                          ],),
                          const SizedBox(height: 10.0,),
                          Row(children: [
                            Text(Constants.numberOfDaysC, style: Constants.textStyle1(Constants.company),),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                              child: Text(Constants.colan, style: Constants.textStyle1(Constants.company),),
                            ),
                            Text(totalDays, style: Constants.textStyle1(Constants.signature),),
                          ],),
                          const SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(Constants.fromDateC, style: Constants.textStyle2(Constants.company),),
                                  const SizedBox(height: 5.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 5.0),
                                        decoration: Constants.backgroundRecycler,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 100.0,
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _fromTime = startTimeError();
                                                        _toTime = endDateError();
                                                      });
                                                    },
                                                    controller: fromDate,
                                                    textAlign: TextAlign.center,
                                                    style: Constants.textStyle1(Constants.company),
                                                    decoration: const InputDecoration(hintText: Constants.fromDateC, hintStyle: TextStyle(color: Constants.company),),
                                                  ),
                                                ),
                                                IconButton(onPressed: () async {
                                                  showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext context) => Dialog(
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                                        backgroundColor: Constants.signature,
                                                        child: CustomCalenderPicker(
                                                          startDate: DateTime.utc(DateTime.now().year, (DateTime.now().month - 1), 1),
                                                          onValueChanged: (value) {
                                                            startDateTime = [value];
                                                            getStartDate();
                                                            setState(() {
                                                              _toTime = endDateError();
                                                              _fromTime = startTimeError();
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                      )
                                                  );
                                                }, icon: const Icon(Icons.calendar_month, color: Constants.company,))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_fromTime != null)
                                        Text(_fromTime!, style: Constants.textStyle1(Constants.redText)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(value: isFirstHalf, onChanged: (value) {
                                        setState(() {
                                          isFirstHalf = value!;
                                          _fromTime = startTimeError();
                                          _toTime = endDateError();
                                        });
                                      }, activeColor: Constants.signature,),
                                      Text(Constants.halfDay, style: Constants.textStyle2(Constants.company),)
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(Constants.toDateC, style: Constants.textStyle2(Constants.company),),
                                  const SizedBox(height: 5.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 5.0),
                                        decoration: Constants.backgroundRecycler,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 100.0,
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _toTime = endDateError();
                                                      });
                                                    },
                                                    textAlign: TextAlign.center,
                                                    style: Constants.textStyle1(Constants.company),
                                                    controller: toDate,
                                                    decoration: const InputDecoration(hintText: Constants.toDateC, hintStyle: TextStyle(color: Constants.company),),
                                                  ),
                                                ),
                                                IconButton(onPressed: () async {
                                                  showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext context) => Dialog(
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                                        backgroundColor: Constants.signature,
                                                        child: CustomCalenderPicker(
                                                          startDate: DateTime.utc(DateTime.now().year, (DateTime.now().month - 1), 1),
                                                          onValueChanged: (value) {
                                                            endDateTime = [value];
                                                            getEndDate();
                                                            Navigator.pop(context);
                                                            setState(() {
                                                              _toTime = endDateError();
                                                            });
                                                          },
                                                        )
                                                        // CalendarDatePicker2(
                                                        //   config: CalendarDatePicker2Config(firstDate: DateTime.utc(DateTime.now().year, (DateTime.now().month - 1), 1))
                                                        //   , value: endDateTime,
                                                        //   onValueChanged: (dates) => {
                                                        //     endDateTime = dates,
                                                        //     getEndDate(),
                                                        //     Navigator.pop(context),
                                                        //     setState(() {
                                                        //       _toTime = endDateError();
                                                        //     }),
                                                        //   },
                                                        // ),
                                                      )
                                                  );
                                                }, icon: const Icon(Icons.calendar_month, color: Constants.company,))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_toTime != null)
                                        Text(_toTime!, style: Constants.textStyle1(Constants.redText)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(value: isSecondHalf, onChanged: (value) {
                                        setState(() {
                                          if (isSecondHalfActive) {
                                            isSecondHalf = value!;
                                            _fromTime = startTimeError();
                                            _toTime = endDateError();
                                          }
                                        });
                                      }, activeColor: Constants.signature,),
                                      Text(Constants.halfDay, style: Constants.textStyle2(Constants.company),)
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      _reason = reasonError();
                                    });
                                  },
                                  style: Constants.textStyle1(Constants.company),
                                  controller: reason,
                                  decoration: Constants.inputDecoration1(Constants.reasonC, null, null, Constants.company, Constants.company, Constants.signature),
                                ),
                                if (_reason != null)
                                  Text(_reason!, style: Constants.textStyle1(Constants.redText)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  style: Constants.buttonStyle(Constants.red),
                                  onPressed: () {
                                    Navigator.pop(context
                                    );
                                  },
                                  child: const Text(Constants.cancelC)
                              ),
                              const SizedBox(width: 30.0,),
                              TextButton(
                                  style: enableButtonStyle(isExist, Constants.signature, Constants.company),
                                  onPressed: () {
                                    if (!isExist) {
                                      checkCondition();
                                    }
                                  },
                                  child: const Text(Constants.sendRequestC)
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void declareItem(){
    _purpose = null;
    _fromTime = null;
    _toTime = null;
    _reason = null;
    _leaveType = null;
    supports = Supports(context);
    isFirstHalf = false;
    isSecondHalf = false;
    isFirstHalfActive = true;
    isSecondHalfActive = false;
  }

  void checkCondition() {
    _leaveType = leaveTypeError();
    _purpose = purposeError();
    _fromTime = startTimeError();
    _toTime = endDateError();
    _reason = reasonError();

    if (_leaveType != null || _purpose != null || _fromTime != null || _reason != null || _toTime != null) {
      setState(() {

      });
    } else if (int.parse(remainLList[leaveList.indexOf(leaveValue)-1].remainingDays) < int.parse(totalDays)) {
      showDialog(context: context, builder: (BuildContext context) => Dialog(
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
                      Text(Constants.sendLOPLeaveRequest, style: Constants.textStyle6(Constants.company, 18.0),),
                      Padding(padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
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
                              style: Constants.buttonStyle4(Constants.company),
                              onPressed: () {
                                Navigator.pop(context, Constants.success);
                              },
                              child: const Text(Constants.sendC)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      )).then((value) => {
        if (value == Constants.success) {
          setLeaveRequest()
        }
      });
    } else {
      setLeaveRequest();
    }
  }

  void setLeaveRequest() async {
    String theType = Constants.key0;
    if (leaveList.indexOf(leaveValue) == 1) {
      theType = Constants.key1;
    }
    String halfDay = Constants.key0;
    if (isFirstHalf && isSecondHalf) {
      halfDay = Constants.key3;
    } else if (isSecondHalf) {
      halfDay = Constants.key2;
    } else if (isFirstHalf) {
      halfDay = Constants.key1;
    }

    Map<String, String> data = {
      Constants.requestType        : Constants.sendLeaveRequest,
      Constants.purpose            : purpose.text.trim(),
      Constants.fromDate           : getDateFormat3(fromDate.text.trim()),
      Constants.toDate             : getDateFormat3(toDate.text.trim()),
      Constants.reason             : reason.text.trim(),
      Constants.type               : theType,
      Constants.dateCreated        : getCreatedDate(),
      Constants.numberOfDays       : remainLList[leaveList.indexOf(leaveValue)-1].remainingDays,
      Constants.numberOfLeavingDay : totalDays,
      Constants.typeOfLeaveText    : leaveLList[leaveList.indexOf(leaveValue)-1].slug,
      Constants.staffId            : staffId,
      Constants.fromTime           : halfDay,
      Constants.timestamp          : DateTime.now().millisecondsSinceEpoch.toString(),
      Constants.symbol             : leaveLList[leaveList.indexOf(leaveValue)-1].symbol,
    };

    var response = await post(Constants.client, body: data);

    if (response.statusCode == 200) {
      handleResponse(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void handleResponse(String response) {
    if (response == Constants.success) {
      Navigator.pop(context, Constants.success);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  String getDateFormat3(String date1) {
    DateFormat format1 = DateFormat("dd-MM-yyyy");
    DateFormat format2 = DateFormat("yyyy-MM-dd HH:mm:s");
    return format2.format(format1.parse(date1));
  }
  
  String getCreatedDate() {
    DateFormat format1 = DateFormat('yyyy-MM-dd HH:mm:s');
    return format1.format(DateTime.now());
  }

  void getStartDate() {
    DateTime? dateTime = startDateTime[0];
    var dateFormatter1 = DateFormat('dd-MM-yyyy');
    var dateFormatter2 = DateFormat('yyyy-MM-dd');
    requestDate = dateFormatter2.format(dateTime!);
    setState(() {
      fromDate.text = dateFormatter1.format(dateTime);
    });
    checkIsDateExists();
  }

  void getEndDate() {
    DateTime? dateTime = endDateTime[0];
    var dateFormatter1 = DateFormat('dd-MM-yyyy');
    var dateFormatter2 = DateFormat('yyyy-MM-dd');
    endDate = dateFormatter2.format(dateTime!);
    setState(() {
      toDate.text = dateFormatter1.format(dateTime);
    });
  }

  void checkIsDateExists() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.checkIsTheRequestExist,
      Constants.staffId     : staffId,
      Constants.date        : requestDate,
      Constants.type        : Constants.key0,
    };
    var response = await post(url, body: data);

    if (response.statusCode == 200) {
      setState(() {
        isExist = (response.body == Constants.exists);
      });
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  ButtonStyle enableButtonStyle(bool condition, Color trueColor, Color falseColor) {
    if (condition) {
      return Constants.buttonStyle(trueColor);
    } else {
      return Constants.buttonStyle(falseColor);
    }
  }

  String? leaveTypeError() {
    if (leaveList.indexOf(leaveValue) == 0) {
      return "required";
    }
    return null;
  }

  String? purposeError() {
    if (purpose.text.trim().isEmpty) {
      return "required";
    }
    return null;
  }

  String? startTimeError() {
    if (fromDate.text.trim().isEmpty) {
      return "required";
    } else {
      try {
        DateFormat format = DateFormat("dd-MM-yyyy");
        DateTime dateTime = format.parse(fromDate.text.trim());
        if (dateTime.millisecondsSinceEpoch >= DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 0).millisecondsSinceEpoch) {
          return null;
        } else {
          return "invalid date";
        }
      } on Exception {
        return "invalid date";
      }
    }
  }

  String? endDateError() {
    if (toDate.text.trim().isEmpty) {
      totalDays = Constants.key0;
      return "required";
    } else {
      try {
        DateFormat format = DateFormat("dd-MM-yyyy");
        DateTime dateTime1 = format.parse(fromDate.text.trim());
        DateTime dateTime2 = format.parse(toDate.text.trim());
        if (dateTime2.millisecondsSinceEpoch >= DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 0).millisecondsSinceEpoch) {
          if (dateTime2.millisecondsSinceEpoch > dateTime1.millisecondsSinceEpoch) {
            isSecondHalfActive = true;
            totalDays = formatNoOfDays((dateTime2.difference(dateTime1).inDays + 1 - getHalfDays()).toString());
            return null;
          } else if (dateTime2.millisecondsSinceEpoch == dateTime1.millisecondsSinceEpoch) {
            isSecondHalfActive = false;
            isSecondHalf = false;
            totalDays = formatNoOfDays((dateTime2.difference(dateTime1).inDays + 1 - getHalfDays()).toString());
            return null;
          } else {
            totalDays = Constants.key0;
            isSecondHalfActive = false;
            isSecondHalf = false;
            return "invalid date";
          }
        } else {
          totalDays = Constants.key0;
          isSecondHalfActive = false;
          isSecondHalf = false;
          return "invalid date";
        }
      } on Exception {
        totalDays = Constants.key0;
        isSecondHalfActive = false;
        isSecondHalf = false;
        return "invalid date";
      }
    }
  }

  String? reasonError() {
    if (reason.text.trim().isEmpty) {
      return "required";
    } else {
      return null;
    }
  }

  String formatNoOfDays(String date) {
    List<String> countList = date.split(".");
    if (countList[1] == Constants.key0) {
      return countList[0];
    } else {
      return date;
    }
  }

  double getHalfDays() {
    double count = 0;
    if (isFirstHalf) {
      count = count + 0.5;
    }
    if (isSecondHalf) {
      count = count + 0.5;
    }
    return count;
  }

}

class MissedPunchDialog extends StatefulWidget {
  MissedPunchDialog({
    required this.staffId,
    super.key
  });

  late String staffId;

  @override
  State<MissedPunchDialog> createState() => _MissedPunchDialogState();
}

class _MissedPunchDialogState extends State<MissedPunchDialog> {

  late TextEditingController missedDate, startTime, endTime, reason;
  late String staffId;
  late List<DateTime?> selectedDateTime = [];
  late String requestDate;
  late Supports supports;
  bool isExist = true, isEnabled = true;
  late String? _missedDate, _startTime, _endTime, _reason, _error;
  late TimeOfDay tStartTime = TimeOfDay.now(), tEndTime = TimeOfDay.now();
  late double originalDuration, finalDuration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    missedDate = TextEditingController();
    startTime = TextEditingController();
    endTime = TextEditingController();
    reason = TextEditingController();
    staffId = widget.staffId;
    _missedDate = null;
    _startTime = null;
    _endTime = null;
    _reason = null;
    _error = null;
    declareItem();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    missedDate.dispose();
    startTime.dispose();
    endTime.dispose();
    reason.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: Constants.padding1,
            decoration: Constants.backgroundRecycler,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Constants.missedPunchInformation, style: Constants.textStyle2(Constants.company)),
                Padding(padding: Constants.padding6,
                child: Column(children: [
                  const SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Constants.missedDate, style: Constants.textStyle2(Constants.company),),
                          const SizedBox(height: 5.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 5.0),
                                  decoration: Constants.backgroundRecycler,
                                  child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 100.0,
                                            child: TextField(
                                              style: const TextStyle(color: Constants.company),
                                              onChanged: (value) {
                                                checkIsDate(value);
                                                _missedDate = missedDateError();
                                                },
                                              textAlign: TextAlign.center,
                                              controller: missedDate,
                                              decoration: const InputDecoration(
                                                hintText: Constants.missedDate,
                                                hintStyle: TextStyle(color: Constants.company,),),
                                            ),
                                          ),
                                          IconButton(onPressed: () {
                                            showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) => Dialog(
                                                  backgroundColor: Constants.signature,
                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                  child: CustomCalenderPicker(
                                                    startDate: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
                                                    endDate: DateTime.now(),
                                                    onValueChanged: (value) {
                                                      selectedDateTime = [value];
                                                      getDate2();
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                  // CalendarDatePicker2(
                                                  //   config: CalendarDatePicker2Config(firstDate: DateTime.utc(
                                                  //     DateTime.now().year, DateTime.now().month, 1), lastDate: DateTime.now())
                                                  //   , value: selectedDateTime,
                                                  //     onValueChanged: (dates) => {
                                                  //       selectedDateTime = dates,
                                                  //       getDate2(),
                                                  //       Navigator.pop(context)
                                                  //     },
                                                  // ),
                                                )
                                            );
                                          }, icon: const Icon(Icons.calendar_month, color: Constants.company,))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              if (_missedDate != null)
                                Text(_missedDate!, style: Constants.textStyle1(Constants.redText)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Constants.startTime, style: Constants.textStyle2(Constants.company),),
                          const SizedBox(height: 5.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 5.0),
                                decoration: Constants.backgroundRecycler,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100.0,
                                          child: TextField(
                                            onChanged: (value) {
                                              setState(() {
                                                _startTime = startTimeError();
                                                _endTime = endTimeError();
                                              });
                                            },
                                            controller: startTime,
                                            enabled: isEnabled,
                                            textAlign: TextAlign.center,
                                            style: Constants.textStyle1(Constants.company),
                                            decoration: const InputDecoration(hintText: Constants.startTime, hintStyle: TextStyle(color: Constants.company),),
                                          ),
                                        ),
                                        IconButton(onPressed: () async {
                                          if (isEnabled) {
                                            TimeOfDay? newTime = await showTimePicker(
                                                context: context,
                                                initialTime: tStartTime);
                                            if (newTime == null) return;
                                            setState(() {
                                              tStartTime = newTime;
                                              startTime.text =
                                                  tStartTime.format(context);
                                              _startTime = startTimeError();
                                              _endTime = endTimeError();
                                            });
                                          }
                                        }, icon: const Icon(Icons.more_time, color: Constants.company,))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (_startTime != null)
                                Text(_startTime!, style: Constants.textStyle1(Constants.redText)),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Constants.endTime, style: Constants.textStyle2(Constants.company),),
                          const SizedBox(height: 5.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 5.0),
                                decoration: Constants.backgroundRecycler,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100.0,
                                          child: TextField(
                                            onChanged: (value) {
                                              setState(() {
                                                _endTime = endTimeError();
                                              });
                                            },
                                            textAlign: TextAlign.center,
                                            style: Constants.textStyle1(Constants.company),
                                            controller: endTime,
                                            decoration: const InputDecoration(hintText: Constants.endTime, hintStyle: TextStyle(color: Constants.company),),
                                          ),
                                        ),
                                        IconButton(onPressed: () async {
                                          TimeOfDay? newTime = await showTimePicker(context: context, initialTime: tEndTime);
                                          if (newTime == null) return;
                                          setState(() {
                                            tEndTime = newTime;
                                            endTime.text = tEndTime.format(context);
                                            _endTime = endTimeError();
                                          });
                                        }, icon: const Icon(Icons.more_time, color: Constants.company,))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (_endTime != null)
                                Text(_endTime!, style: Constants.textStyle1(Constants.redText)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height:10.0,),
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _reason = reasonError();
                            });
                          },
                          style: Constants.textStyle1(Constants.company),
                          controller: reason,
                          decoration: Constants.inputDecoration1(Constants.reasonC, null, null, Constants.company, Constants.company, Constants.signature),
                        ),
                        if (_reason != null)
                          Text(_reason!, style: Constants.textStyle1(Constants.redText)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          style: Constants.buttonStyle(Constants.red),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(Constants.cancelC)
                      ),
                      const SizedBox(width: 30.0,),
                      TextButton(
                          style: enableButtonStyle(isExist, Constants.signature, Constants.company),
                          onPressed: () {
                            // if (!isExist) {
                              checkCondition();
                            // }
                          },
                          child: const Text(Constants.sendRequestC)
                      ),
                    ],),
                  if (_error != null)
                    Text(_error!, style: Constants.textStyle1(Constants.redText),),
                ])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void declareItem() {
    supports = Supports(context);
  }

  String? missedDateError() {
    _error = null;
     if (missedDate.text.trim().isEmpty) {
      return "required";
    } else if (isDate()) {
       return "invalid date";
     }
    return null;
  }
  
  String? startTimeError() {
    _error = null;
    TimeOfDay? timeOfDay;
    if (startTime.text.trim().isNotEmpty) {
      timeOfDay = getTimeOfDay(startTime.text.trim());
      if (timeOfDay != null) {
        tStartTime = timeOfDay;
      }
    } else {
      timeOfDay = null;
    }
    if (startTime.text.trim().isEmpty) {
      return "required";
    } else if (timeOfDay == null || isTime(startTime.text.trim(), tStartTime)) {
      return "invalid time";
    }
    return null;
  }

  TimeOfDay? getTimeOfDay (String time) {
    DateFormat format = DateFormat("hh:mm a");
    try {
      DateTime dateTime = format.parse(time);
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } on Exception {
      return null;
    }
  }

  String? endTimeError() {
    _error = null;
    TimeOfDay? timeOfDay;
    if (endTime.text.trim().isNotEmpty) {
      timeOfDay = getTimeOfDay(endTime.text.trim());
      if (timeOfDay != null) {
        tEndTime = timeOfDay;
      }
    } else {
      timeOfDay = null;
    }
    if (endTime.text.trim().isEmpty) {
      return "required";
    } else if (timeOfDay == null || isTime(endTime.text.trim(), tEndTime) ||
        (tStartTime.hour > tEndTime.hour) ||
        (tStartTime.hour == tEndTime.hour && tStartTime.minute >= tEndTime.minute)) {
      return "invalid time";
    }
    return null;
  }

  String? reasonError() {
    _error = null;
    if (reason.text.trim().isEmpty) {
      return "required";
    } else {
      return null;
    }
  }

  bool isTime(String time, TimeOfDay td) {
    try {
      TimeOfDay timeOfDay = fromString(time);
      td = timeOfDay;
      return false;
    } on Exception catch (e) {
      return true;
    }
  }

  TimeOfDay fromString(String time) {
    int hh = 0;
    if (time.endsWith('PM')) {
      hh = 12;
    } else if (time.endsWith("AM")) {
      hh = 0;
    } else {
      time = "a";
    }

    time = time.split(' ')[0];
    return TimeOfDay(
      hour: hh + getHour(time.split(":")[0]), // in case of a bad time format entered manually by the user
      minute: int.parse(time.split(":")[1]) % 60,
    );
  }

  int getHour(String hour) {
    if (int.parse(hour) == 12) {
      hour = Constants.key0;
    }
    return int.parse(hour) % 24;
  }
  
  void getDate2() {
    DateTime? dateTime = selectedDateTime[0];
    var dateFormatter1 = DateFormat('dd-MM-yyyy');
    var dateFormatter2 = DateFormat('yyyy-MM-dd');
    requestDate = dateFormatter2.format(dateTime!);
    setState(() {
      missedDate.text = dateFormatter1.format(dateTime);
    });
    checkIsDateExists();
  }

  void checkIsDateExists() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.checkIsTheRequestExist,
      Constants.staffId     : staffId,
      Constants.date        : requestDate,
      Constants.type        : Constants.key10,
    };
    var response = await post(url, body: data);

    if (response.statusCode == 200) {
      isExist = (response.body == Constants.exists);
      getCheckInOutData();
    } else {
      _error = Constants.errorMessage;
    }
  }

  ButtonStyle enableButtonStyle(bool condition, Color trueColor, Color falseColor) {
    if (condition) {
      return Constants.buttonStyle(trueColor);
    } else {
      return Constants.buttonStyle(falseColor);
    }
  }

  void checkCondition() {
    _missedDate = missedDateError();
    _startTime = startTimeError();
    _endTime = endTimeError();
    _reason = reasonError();
    if (_missedDate != null || _startTime != null || _endTime != null || _reason != null) {
       setState(() {

       });
    } else {
      sendRequestData();
    }
  }

  bool isDate() {
    try {
      DateFormat format1 = DateFormat("dd-MM-yyyy");
      DateTime dateTime = format1.parse(missedDate.text.trim());
      if (dateTime.millisecondsSinceEpoch > DateTime.utc(DateTime.now().year, DateTime.now().month-1, 0).millisecondsSinceEpoch
          && dateTime.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
        return false;
      } else {
        return true;
      }
    } on Exception catch (e) {
      return true;
    }
  }

  void checkIsDate(String value) {
    try {
      DateFormat format1 = DateFormat("dd-MM-yyyy");
      DateTime dateTime = format1.parse(value);
      if (dateTime.millisecondsSinceEpoch > DateTime.utc(DateTime.now().year, DateTime.now().month-1, 0).millisecondsSinceEpoch
      && dateTime.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
        var dateFormatter2 = DateFormat('yyyy-MM-dd');
        requestDate = dateFormatter2.format(dateTime);
        checkIsDateExists();
      } else {
        isExist = true;
      }
    } on Exception catch (e) {
      isExist = true;
    }

    setState(() {

    });

  }

  void sendRequestData() async {
    Map<String, String> data = {
      Constants.requestType : Constants.holidayOrCompOff,
      Constants.staffId     : staffId,
      Constants.fromDate    : requestDate,
      Constants.reason      : reason.text.trim(),
      Constants.type        : Constants.key10,
      Constants.fromTime    : startTime.text.trim(),
      Constants.toTime      : endTime.text.trim(),
      Constants.timestamp   : DateTime.now().millisecondsSinceEpoch.toString(),
      Constants.workHours   : getDuration(),
    };

    var response = await post(Constants.client, body: data);

    if (response.statusCode == 200) {
      handleResponse(response.body);
    } else {
      _error = Constants.errorMessage;
    }
  }

  void handleResponse(String response) {
    if (response == Constants.success) {
      Navigator.pop(context, Constants.success);
    } else {
      _error = Constants.errorMessage;
    }
  }

  String getDuration() {
    return (toDouble(tEndTime) - toDouble(tStartTime)).toStringAsFixed(2);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;

  void getCheckInOutData() async {
    Map<String, String> data = {
      Constants.requestType : Constants.getCheckInOutData,
      Constants.date        : requestDate,
      Constants.staffId     : staffId,
    };
    var response = await post(Constants.client, body: data);

    if (response.statusCode == 200) {
      originalDuration = supports.getLastCheckedTimeValue(response.body);
      String? theStat = supports.getLastCheckedTimeText(response.body);
      if (theStat == null) {
        startTime.clear();
      } else {
        startTime.text = theStat;
        TimeOfDay? timeOfDay = getTimeOfDay(theStat);
        if (timeOfDay == null) {
          setState(() {
            _startTime = "invalid time";
          });
        } else {
          tStartTime = timeOfDay;
        }
      }
      setState(() {
        isEnabled = (theStat == null);
      });
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

}

//todo reject dialog
class RejectDialog extends StatefulWidget {
  RejectDialog({
    required this.data,
    super.key});

  late Map<String, String> data;

  @override
  State<RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<RejectDialog> {

  late TextEditingController reason;
  late Map<String, String> data;
  late String? _reason, _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reason = TextEditingController();
    _reason = null;
    data = widget.data;
    _error = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    reason.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: Constants.backgroundRecycler,
          padding: Constants.padding1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Constants.rejectedReason, style: Constants.textStyle1(Constants.company)),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                        onChanged: (value){
                          setState(() {
                            _reason = reasonError();
                            _error = null;
                          });
                          },
                        style: Constants.textStyle1(Constants.company),
                        controller: reason,
                        obscureText: false,
                        decoration: Constants.inputDecoration1(Constants.reasonC, const Icon(Icons.message), Constants.company, Constants.company, Constants.company, Constants.signature)
                    ),
                    if (_reason != null)
                      Text(_reason!, style: Constants.textStyle1(Constants.redText),)
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      style: Constants.buttonStyle4(Constants.company),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(Constants.cancelC)),
                  const SizedBox(width: 20.0,),
                  TextButton(
                      style: Constants.buttonStyle4(Constants.red),
                      onPressed: () {
                        checkCondition();
                      },
                      child: const Text(Constants.rejectC)),
                ],
              ),
              if (_error != null)
                Text(_error!, style: Constants.textStyle1(Constants.redText),),
            ],
          ),
        )
      ],
    );
  }

  void checkCondition() {
    _reason = reasonError();
    if (_reason != null) {
      setState(() {

      });
    } else {
      approveOrReject();
    }
  }

  void approveOrReject() async {
    Map<String, String> data1 = {
      Constants.type             : Constants.key2,
      Constants.reason           : reason.text,
      Constants.currentTimestamp : DateTime.now().millisecondsSinceEpoch.toString(),
    };
    data.addAll(data1);
    var response = await post(Constants.client, body: data);
    if (response.statusCode == 200) {
      handleResponse(response.body);
    } else {
      _error = Constants.errorMessage;
    }
  }

  void handleResponse(String response) {
    if (response == Constants.failure) {
      _error = Constants.errorMessage;
    } else {
      Navigator.pop(context, response);
    }
  }

  String? reasonError() {
    if (reason.text.trim().isEmpty) {
      return "required";
    } else {
      return null;
    }
  }

}


class MassRejectDialog extends StatefulWidget {
  MassRejectDialog({
    required this.data,
    super.key});

  late Map<String, String> data;

  @override
  State<MassRejectDialog> createState() => _MassRejectDialogState();
}

class _MassRejectDialogState extends State<MassRejectDialog> {
  late TextEditingController reason;
  late Map<String, String> data;
  late String? _reason, _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reason = TextEditingController();
    _reason = null;
    data = widget.data;
    _error = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    reason.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: Constants.backgroundRecycler,
          padding: Constants.padding1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Constants.rejectedReason, style: Constants.textStyle1(Constants.company)),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                        onChanged: (value){
                          setState(() {
                            _reason = reasonError();
                            _error = null;
                          });
                        },
                        style: Constants.textStyle1(Constants.company),
                        controller: reason,
                        obscureText: false,
                        decoration: Constants.inputDecoration1(Constants.reasonC, const Icon(Icons.message), Constants.company, Constants.company, Constants.company, Constants.signature)
                    ),
                    if (_reason != null)
                      Text(_reason!, style: Constants.textStyle1(Constants.redText),)
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      style: Constants.buttonStyle4(Constants.company),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(Constants.cancelC)),
                  const SizedBox(width: 20.0,),
                  TextButton(
                      style: Constants.buttonStyle4(Constants.red),
                      onPressed: () {
                        checkCondition();
                      },
                      child: const Text(Constants.rejectC)),
                ],
              ),
              if (_error != null)
                Text(_error!, style: Constants.textStyle1(Constants.redText),),
            ],
          ),
        )
      ],
    );
  }

  void checkCondition() {
    _reason = reasonError();
    if (_reason != null) {
      setState(() {

      });
    } else {
      approveOrReject();
    }
  }

  void approveOrReject() async {
    Map<String, String> data1 = {
      Constants.type             : Constants.key2,
      Constants.reason           : reason.text,
      Constants.currentTimestamp : DateTime.now().millisecondsSinceEpoch.toString(),
    };
    data.addAll(data1);
    var response = await post(Constants.client, body: data);
    if (response.statusCode == 200) {
      handleResponse(response.body);
    } else {
      _error = Constants.errorMessage;
    }
  }

  void handleResponse(String response) {
    if (response == Constants.failure) {
      _error = Constants.errorMessage;
    } else {
      Navigator.pop(context, response);
    }
  }

  String? reasonError() {
    if (reason.text.trim().isEmpty) {
      return "required";
    } else {
      return null;
    }
  }
}

class CheckedDialog extends StatefulWidget {
  CheckedDialog({
    required this.responseList,
    super.key});

  late List<String> responseList;

  @override
  State<CheckedDialog> createState() => _CheckedDialogState();
}

class _CheckedDialogState extends State<CheckedDialog> {

  late List<String> responseList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    responseList = widget.responseList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: Constants.padding1,
          decoration: Constants.backgroundRecycler,
          child: Column(
            children: <Widget>[
              for (String response in responseList)
                responseContainer(response),
              const SizedBox(height: 10.0,),
              TextButton(
                style: Constants.buttonStyle4(Constants.company),
                  onPressed: () {Navigator.pop(context);},
                  child: const Text(Constants.ok),
              ),
            ],
          ),
        )
      ],
    );
  }

  Container responseContainer(String response) {
    List<String> list1 = response.split('--');
    return Container(
      width: double.maxFinite,
      decoration: Constants.checkInStatusDecoration(int.parse(list1[1])),
      padding: Constants.padding1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (list1[1] == Constants.key1)
            Text("${Constants.punchedInAt}  ${dataTime(list1[0])}", style: Constants.textStyle1(Constants.green),),
          if (list1[1] == Constants.key2)
            Text("${Constants.punchedOutAt} ${dataTime(list1[0])}", style: Constants.textStyle1(Constants.redText),),
        ],
      ),
    );
  }

  String dataTime(String date) {
    DateFormat format1 = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat format2 = DateFormat("dd-MM-yyyy hh:mm a");
    try {
      DateTime dateTime = format1.parse(date);
      return format2.format(dateTime);
    } on Exception {
      return "error";
    }
  }

}

class TimesheetDialog extends StatefulWidget {
  TimesheetDialog({
    required this.responseList,
    super.key});

  late List<String> responseList;

  @override
  State<TimesheetDialog> createState() => _TimesheetDialogState();
}

class _TimesheetDialogState extends State<TimesheetDialog> {

  late List<String> responseList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    responseList = widget.responseList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: Constants.padding1,
          decoration: Constants.backgroundRecycler,
          child: Column(
            children: <Widget>[
              for (String response in responseList)
                responseContainer(response),
              const SizedBox(height: 10.0,),
              TextButton(
                style: Constants.buttonStyle4(Constants.company),
                onPressed: () {Navigator.pop(context);},
                child: const Text(Constants.ok),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container responseContainer(String response) {
    List<String> list1 = response.split(Constants.splitter2);
    Color borderColor, decorationColor, textColor;
    String text;

    switch (list1[1]) {
      case "W":
        text = "Worked on ${list1[0]}";
        borderColor = const Color(0xFF00FE06);
        decorationColor = const Color(0xFF00FE06);
        textColor = const Color(0xFF016DB5);
      case "CO":
        text = "Compensation Off on ${list1[0]}";
        borderColor = const Color(0xFF00FE06);
        decorationColor = const Color(0xFF00FE06);
        textColor = const Color(0xFF016DB5);
      case "LH":
        text = "Local Holiday on ${list1[0]}";
        borderColor = const Color(0xFF00FE06);
        decorationColor = const Color(0xFF00FE06);
        textColor = const Color(0xFF016DB5);
      case "HO":
        text = "Holiday on ${list1[0]}";
        borderColor = const Color(0xFF02AAF1);
        decorationColor = const Color(0xFF02AAF1);
        textColor = Colors.white;
      case "SL":
        text = "Sick Leave on ${list1[0]}";
        borderColor = Constants.company;
        decorationColor = Colors.white;
        textColor = Constants.signature;
      case "CL":
        text = "Casual Leave on ${list1[0]}";
        borderColor = Constants.company;
        decorationColor = Colors.white;
        textColor = Constants.signature;
      case "EL":
        text = "Earned Leave on ${list1[0]}";
        borderColor = Constants.company;
        decorationColor = Colors.white;
        textColor = Constants.signature;
      case "PL":
        text = "Paternity Leave on ${list1[0]}";
        borderColor = Constants.company;
        decorationColor = Colors.white;
        textColor = Constants.signature;
      case "ML":
        text = "Marriage Leave on ${list1[0]}";
        borderColor = Constants.company;
        decorationColor = Colors.white;
        textColor = Constants.signature;
      case "LOP":
        text = "Loss of Pay on ${list1[0]}";
        borderColor = const Color(0xFFFD0002);
        decorationColor = const Color(0xFFFD0002);
        textColor = Colors.white;
      default:
        text = "Leave on ${list1[0]}";
        borderColor = Constants.company;
        decorationColor = Colors.white;
        textColor = Constants.signature;
    }

    return Container(
      decoration: Constants.backgroundR(borderColor, decorationColor),
      padding: Constants.padding1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(text, style: Constants.textStyle2(textColor),),
        ],
      ),
    );
  }

}

class CheckedStatus extends StatefulWidget {
  CheckedStatus({
    required this.response,
    super.key});

  late String response;

  @override
  State<CheckedStatus> createState() => _CheckedStatusState();
}

class _CheckedStatusState extends State<CheckedStatus> {

  late String response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    response = widget.response;
  }

  @override
  Widget build(BuildContext context) {
    return responseContainer();
  }

  Container responseContainer() {
    if (response == Constants.key1) {
      return customContainer("PUNCHED IN SUCCESSFULLY", Constants.green, Constants.green, Constants.lightGreen);
    } else if (response == Constants.key2) {
      return customContainer("PUNCHED OUT SUCCESSFULLY", Constants.red, Constants.red, Constants.lightRed);
    } else {
      return customContainer("Something went wrong", Constants.red, Constants.red, Constants.lightRed);
    }
  }

  Container customContainer(String text, Color textColor, Color buttonColor, Color backgroundColor) {
    return Container(
      decoration: Constants.backgroundR(buttonColor, backgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: Constants.padding1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: Constants.textStyle2(textColor),),
                const SizedBox(height: 20.0,),
                TextButton(
                    style: Constants.buttonStyle4(buttonColor),
                    onPressed: () {
                      Navigator.pop(context);
                      },
                    child: const Text(Constants.ok))
              ],
            ),
          ),
        ],
      ),
    );
  }

}

