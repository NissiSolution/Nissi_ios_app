import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '/views/admin/unique_admin_comp_off_holiday_activity.dart';

import '../../Supports/checkpassword.dart';
import '../../Supports/classes.dart';
import '../../Supports/constants.dart';
import '../../Supports/filter.dart';
import '../../Supports/preferences_manager.dart';
import '../../Supports/supports.dart';
import 'mass_approve_night_shift_activity.dart';

class AdminNightShiftPage extends StatefulWidget {
  const AdminNightShiftPage({super.key});

  @override
  State<AdminNightShiftPage> createState() => _AdminNightShiftPageState();
}

class _AdminNightShiftPageState extends State<AdminNightShiftPage> {

  late String monthValue;
  late String yearValue;
  late String typeValue;
  late int type;
  late PreferencesManager preferencesManager;
  late Supports supports;
  late String staffId, selectedMonth, selectedYear;
  late bool isActive = true, canLoad = true;
  late List<AdminCompOffHoliday> adminCompOffHolidayList = [];

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
    double textWidth = contentWidth - 150.0;
    double textWidth1 = contentWidth - 150.0;
    double textWidth2 = contentWidth - 230.0 + 30;

    return Scaffold(
      appBar: Constants.appBar(Constants.nightShiftRequest),
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
                      const SizedBox(height: 10.0,),
                      Expanded(
                        child: ListView.builder(
                            itemCount: Filter().filterAdminCompOffHoliday(adminCompOffHolidayList, type).length,
                            itemBuilder: (BuildContext context, int index) {
                              return TextButton(
                                  style: Constants.buttonStyle2(Constants.company),
                                  onPressed: () {
                                    uniqueApprove(context, Filter().filterAdminCompOffHoliday(adminCompOffHolidayList, type)[index].theData, Filter().filterAdminCompOffHoliday(adminCompOffHolidayList, type)[index].requestType);
                                  },
                                  onLongPress: () {
                                    if (Filter().filterAdminCompOffHoliday(adminCompOffHolidayList, type)[index].status == 0) {
                                      massApprove(context);
                                    }
                                  },
                                  child: Container(
                                    decoration: Constants.statusDecoration(Filter().filterAdminCompOffHoliday(adminCompOffHolidayList, type)[index].status),
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
                                                          Filter().filterAdminCompOffHoliday(adminCompOffHolidayList, type)[index].staffName,
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
                                                        child: Text(Constants.requestTypeC, style: Constants.textStyle2(Constants.company),)),
                                                    Container(
                                                        alignment: Alignment.center,
                                                        width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),
                                                    if (int.parse(Filter().filterAdminCompOffHoliday(adminCompOffHolidayList, type)[index].requestType) == 3)
                                                      SizedBox(
                                                          width: textWidth2,
                                                          child: Text(
                                                            Constants.nightShift,
                                                            style: Constants.textStyle1(Constants.signature), overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                                    if (int.parse(Filter().filterAdminCompOffHoliday(adminCompOffHolidayList, type)[index].requestType) == 2)
                                                      SizedBox(
                                                          width: textWidth2,
                                                          child: Text(
                                                            Constants.holidayC,
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
                                                        child: Text(Constants.dateC, style: Constants.textStyle2(Constants.company),)),

                                                    Container(
                                                        alignment: Alignment.center,
                                                        width: 20.0,child: Text(Constants.colan, style: Constants.textStyle2(Constants.company),)),

                                                    SizedBox(
                                                        width: textWidth2,
                                                        child: Text(
                                                          Filter().filterAdminCompOffHoliday(adminCompOffHolidayList, type)[index].date,
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
                                                          supports.getStatus(Filter().filterAdminCompOffHoliday(adminCompOffHolidayList, type)[index].status),
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
    type = 0;
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
      Constants.requestType : Constants.getNightShiftApprovalRequest,
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
    adminCompOffHolidayList.clear();
    List<String> list1 = response.split(Constants.splitter3);

    for (int i = 1; i < list1.length; i++) {
      List<String> list2 = list1[i].split(Constants.splitter4);
      AdminCompOffHoliday compOffHoliday = AdminCompOffHoliday(list2[0], list2[5],
          list2[6], list1[i], supports.getCurrentStatus(list2[2]), int.parse(list2[3]), true);
      adminCompOffHolidayList.add(compOffHoliday);
    }

    setState(() {
      isActive = false;
    });
  }

  Future<void> uniqueApprove(BuildContext context, String theData, String requestType) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(builder: (context) => UniqueAdminCompOffHolidayPage(
          data: theData,
          requestType: requestType,),
        )
    );

    getRequestData();

  }

  Future<void> massApprove(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(builder: (context) => const MassApproveNightShiftPage()
        )
    );

    getRequestData();

  }

  void updateViewed() async {
    Map<String, String> data = {
      Constants.requestType : Constants.updateViewed,
      Constants.staffId     : staffId,
      Constants.type        : Constants.key103,
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
