import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/Supports/checkpassword.dart';
import '/views/admin/permission_manager.dart';

import '../Supports/constants.dart';
import '../Supports/preferences_manager.dart';
import '../Supports/supports.dart';
import 'admin/admin_comp_off_holiday_activity.dart';
import 'admin/admin_leave_activity.dart';
import 'admin/admin_missed_punch_activity.dart';
import 'admin/admin_night_shift_activity.dart';
import 'employee/comp_off_holiday_activity.dart';
import 'employee/leave_activity.dart';
import 'employee/missed_punch_activity.dart';
import 'employee/night_shift_activity.dart';
import 'location/map_history_activity.dart';
import 'location/punched_history_activity.dart';

class HrPage extends StatefulWidget {
  const HrPage({super.key});

  @override
  State<HrPage> createState() => _HrPageState();
}

class _HrPageState extends State<HrPage> {
  late PreferencesManager preferencesManager;
  late Supports supports;
  late String staffId, password;
  late bool isLoading = true, canLoad = true, isAdmin = false;
  late int leaveCount,
      leaveRequestCount,
      missedPunchCount,
      missedPunchRequestCount,
      compOffHolidayCount,
      compOffHolidayRequestCount,
      nightShiftCount,
      nightShiftRequestCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    declareItem();
    CheckPass(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.appBar(Constants.humanResources),
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
                Expanded(
                    child: Center(
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
                                    child: const CircularProgressIndicator(
                                      color: Constants.company,
                                      strokeWidth: 4.0,
                                    )),
                              ),
                            ])),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            Constants.unableMessage,
                                            style: Constants.textStyle3(
                                                Constants.company),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                  style: Constants.buttonStyle4(
                                                      Constants.red),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                      Constants.cancelC)),
                                              const SizedBox(
                                                width: 20.0,
                                              ),
                                              TextButton(
                                                  style: Constants.buttonStyle4(
                                                      Constants.company),
                                                  onPressed: () {
                                                    setState(() {
                                                      canLoad = true;
                                                      fDelay();
                                                      getAdmin();
                                                    });
                                                  },
                                                  child: const Text(
                                                      Constants.retryC)),
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
                ))
              else if (!isLoading)
                Expanded(
                    child: Container(
                  padding: Constants.padding2,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      if (isAdmin)
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const LeavePage()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lLeave,
                                        Constants.leaveRequest,
                                        leaveCount)),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const AdminLeavePage()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lApprove,
                                        Constants.approveLeave,
                                        leaveRequestCount)),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const MissedPunchPage()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lMissedPunch,
                                        Constants.missedPunchRequest,
                                        missedPunchCount)),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const AdminMissedPunchPage()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lApprove,
                                        Constants.approveMissedPunch,
                                        missedPunchRequestCount)),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const CompOffHolidayPage()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lCompOff,
                                        Constants.compOffHolidayRequest,
                                        compOffHolidayCount)),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const AdminCompOffHolidayPage()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lApprove,
                                        Constants.approveCompOffHoliday,
                                        compOffHolidayRequestCount)),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const NightShiftPage()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lNightShift,
                                        Constants.nightShiftRequest,
                                        nightShiftCount)),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const AdminNightShiftPage()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lApprove,
                                        Constants.approveNightShift,
                                        nightShiftRequestCount)),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const MapHistoryPage()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lLocation,
                                        Constants.punchedLocation,
                                        0)),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const PunchedHistoryPage()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lChecked,
                                        Constants.punchedHistory,
                                        0)),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const PermissionManager()))
                                          .then((value) => checkNotification());
                                    },
                                    style: Constants.buttonStyle3(),
                                    child: Constants.imageColumn3(
                                        Constants.lPermission,
                                        Constants.permissionManagement,
                                        0)),
                              ],
                            )
                          ],
                        ),
                      if (!isAdmin)
                        Column(children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const LeavePage()))
                                        .then((value) => checkNotification());
                                  },
                                  style: Constants.buttonStyle3(),
                                  child: Constants.imageColumn3(
                                      Constants.lLeave,
                                      Constants.leaveRequest,
                                      leaveCount)),
                              const SizedBox(
                                width: 20.0,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const MissedPunchPage()))
                                        .then((value) => checkNotification());
                                  },
                                  style: Constants.buttonStyle3(),
                                  child: Constants.imageColumn3(
                                      Constants.lMissedPunch,
                                      Constants.missedPunchRequest,
                                      missedPunchCount)),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const CompOffHolidayPage()))
                                        .then((value) => checkNotification());
                                  },
                                  style: Constants.buttonStyle3(),
                                  child: Constants.imageColumn3(
                                      Constants.lCompOff,
                                      Constants.compOffHolidayRequest,
                                      compOffHolidayCount)),
                              const SizedBox(
                                width: 20.0,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const NightShiftPage()))
                                        .then((value) => checkNotification());
                                  },
                                  style: Constants.buttonStyle3(),
                                  child: Constants.imageColumn3(
                                      Constants.lNightShift,
                                      Constants.nightShiftRequest,
                                      nightShiftCount)),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ]),
                    ]),
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
    leaveCount = 0;
    leaveRequestCount = 0;
    missedPunchCount = 0;
    missedPunchRequestCount = 0;
    compOffHolidayCount = 0;
    compOffHolidayRequestCount = 0;
    nightShiftCount = 0;
    nightShiftRequestCount = 0;
    getAdmin();
    fDelay();
  }

  Future<void> fDelay() {
    return Future<void>.delayed(
        const Duration(seconds: 10),
        () => setState(() {
              canLoad = false;
            }));
  }

  void getAdmin() async {
    Map<String, String> data = {
      Constants.requestType: Constants.isAdmin,
      Constants.staffId: staffId,
    };
    var client = http.Client();
    var response;
    try {
      response = await client.post(Constants.client, body: data);
    } finally {
      if (response.statusCode == 200) {
        setState(() {
          isAdmin = (response.body == Constants.admin);
          isLoading = false;
          checkNotification();
        });
      } else {
        supports.createSnackBar(response.statusCode.toString());
      }
      client.close();
    }
  }

  void checkNotification() async {
    Map<String, String> data = {
      Constants.requestType: Constants.getNotification,
      Constants.staffId: staffId,
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
    leaveCount = 0;
    leaveRequestCount = 0;
    missedPunchCount = 0;
    missedPunchRequestCount = 0;
    compOffHolidayCount = 0;
    compOffHolidayRequestCount = 0;
    nightShiftCount = 0;
    nightShiftRequestCount = 0;

    for (int i = 1; i < list1.length; i++) {
      List<String> list2 = list1[i].split(Constants.splitter2);
      if (int.parse(list2[5]) == 0) {
        switch (int.parse(list2[2])) {
          case 0:
            leaveCount++;
          case 100:
            leaveRequestCount++;
          case 1:
            compOffHolidayCount++;
          case 2:
            compOffHolidayCount++;
          case 101:
            compOffHolidayRequestCount++;
          case 102:
            compOffHolidayRequestCount++;
          case 3:
            nightShiftCount++;
          case 103:
            nightShiftRequestCount++;
          case 10:
            missedPunchCount++;
          case 110:
            missedPunchRequestCount++;
          default:
            break;
        }
      }
    }
    setState(() {});
  }
}
