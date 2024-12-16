import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'classes.dart';
import 'constants.dart';


class Supports {

  BuildContext? context;

  Supports(BuildContext this.context);

  void createSnackBar(String message) {
    var snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Constants.signature, fontStyle: FontStyle.italic)),
      backgroundColor: Colors.white,
    );
    ScaffoldMessenger.of(context!).showSnackBar(snackBar);
  }

  void navigateFinish(String path) {
    Navigator.of(context!).pushNamedAndRemoveUntil(path, (route) => false);
  }
  
  int getCurrentStatus(String theData) {
    try {
      List<String> list1 = theData.split(Constants.splitter1);
      int theStatus = 0;
      for (int i = 1; i < list1.length; i++) {
        List<String> list2 = list1[i].split(Constants.splitter2);
        if (list2[1] == Constants.key1) {
          return 1;
        } else if (list2[1] == Constants.key2) {
          theStatus = 2;
        }
      }
      return theStatus;
    } on Exception catch (e) {
      return 0;
    }
  }

  String twoDigit(int value) {
    if (value < 10) {
      return "0$value";
    } else {
      return "$value";
    }
  }

  String threeDigit(int value) {
    if (value < 10) {
      return "00$value.";
    } else if (value < 100) {
      return "0$value.";
    } else {
      return "$value.";
    }
  }

  String getPeriod(String startDate, String endDate) {
    List<String> list1 = startDate.split(" ");
    List<String> list2 = endDate.split(" ");
    if (list1[0] == list2[0]) {
      return "On ${list1[0]}";
    } else {
      return "From ${list1[0]} to ${list2[0]}";
    }
  }

  String getDuration(int duration) {
    if (duration == 1) {
      return "$duration day";
    } else {
      return "$duration days";
    }
  }

  String getStatus(int status) {
    if (status == 0) {
      return "Request On process";
    } else if (status == 1) {
      return "Request Approved";
    } else {
      return "Request Rejected";
    }
  }

  String getStatus2(int status, String date) {
    if (status == 0) {
      return "Request On process";
    } else if (status == 1) {
      return "Request Approved on $date";
    } else {
      return "Request Rejected $date";
    }
  }

  String getApproverName(int staffId, List<Department> departmentList) {
    for (Department d in departmentList) {
      if (d.staffId == staffId) {
        return d.manageName;
      }
    }
    return "Unknown";
  }

  String getApproverPosition(int staffId, List<Department> departmentList) {
    for (Department d in departmentList) {
      if (d.staffId == staffId) {
        return d.position;
      }
    }
    return "Unknown";
  }

  double getLastCheckedTimeValue(String theValue) {
    List<String> list1 = theValue.split(Constants.splitter1);
    String? date1, date2, date1type, date2type;
    double theDuration = 0.0;
    for (int i = 1; i < list1.length; i++) {
      List<String> list2 = list1[i].split(Constants.splitter2);
      if (date1 == null) {
        if (list2[1] == Constants.key1) {
          date1 = list1[i];
          date1type = list2[1];
        } else {
          date2 = list1[i];
          date2type = list2[1];
          if (date1type == Constants.key1) {
            if (date2type != date1type) {
              theDuration = theDuration + getDate(date1!, date2);
              date1 = date2;
              date1type = date2type;
            }
          } else {
            date1 = date2;
            date1type = date2type;
          }
        }
      }
    }

    return theDuration / (60 * 60 * 1000);

  }

  double getDate(String date1, String date2) {
    List<String> list1 = date1.split(Constants.splitter2);
    List<String> list2 = date2.split(Constants.splitter2);

    if (list2[1] == list2[1]) {
      return 0;
    } else {
      if (list1[1] == Constants.key1) {
        return getDurationPeriod(date1, date2);
      } else {
        return 0;
      }
    }

  }

  double getDurationPeriod(String date1, String date2) {
    DateFormat format1 = DateFormat("yyyy-MM-dd HH:mm:ss");
    try {
      double timestamp1 = format1.parse(date1).millisecondsSinceEpoch.toDouble();
      double timestamp2 = format1.parse(date2).millisecondsSinceEpoch.toDouble();
      return timestamp2 - timestamp1;
    } on Exception {
      return 0;
    }
  }

  String? getLastCheckedTimeText(String theValue) {
    List<String> list1 = theValue.split(Constants.splitter1);
    if (list1.length > 1) {
      List<String> list2 = list1[list1.length-1].split(Constants.splitter2);
      DateFormat format1 = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateFormat format2 = DateFormat("hh:mm a");
      try {
        if (list2[1] == Constants.key1) {
          return format2.format(format1.parse(list2[0]));
        } else {
          return null;
        }
      } on Exception {
        return null;
      }
    } else {
      return null;
    }
  }



}