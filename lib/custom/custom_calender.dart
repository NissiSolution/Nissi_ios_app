import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Supports/supports.dart';
import '../views/dialog/dialog.dart';

import '../Supports/constants.dart';

class CustomCalender extends StatefulWidget {
  CustomCalender({
    required this.month,
    required this.year,
    required this.dateTypeList,
    required this.staffId,
    super.key,
  });

  late int month, year;
  late String staffId;
  late List<DateType> dateTypeList;

  @override
  State<CustomCalender> createState() => _CustomCalenderState();
}

class _CustomCalenderState extends State<CustomCalender> {
  late int month, year;
  late List<DateType> dateTypeList = [];
  final List<String> weekList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  late List<String> dayList = [];
  late List<CustomCalenderDecoration> decorationList = [];
  late bool show5 = false, show6 = false;
  late String staffId;
  late Supports supports;

  @override
  Widget build(BuildContext context) {

    dateTypeList = widget.dateTypeList;

    return Column(
      children: [
        Container(
          width: 332.5,
          color: Constants.company,
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {
                    if (month == 1) {
                      month = 12;
                      year = year - 1;
                    } else {
                      month = month - 1;
                    }
                    if (DateTime(year, month, 1).millisecondsSinceEpoch < DateTime(DateTime.now().year, DateTime.now().month, 1).millisecondsSinceEpoch) {
                      getMyDetailsInfo(year, month);
                    }
                    displayDates(month, year);
                  }, icon: const Icon(Icons.arrow_left, color: Colors.white,)),
                  TextButton(
                      style: monthButtonStyle,
                      onPressed: () {
                        displayDates(month, year);
                      },
                      child: Text("${currentMonth()} $year")),
                  IconButton(onPressed: () {
                    if (month == 12) {
                      month = 1;
                      year = year + 1;
                    } else {
                      month = month + 1;
                    }
                    if (DateTime(year, month, 1).millisecondsSinceEpoch < DateTime(DateTime.now().year, DateTime.now().month, 1).millisecondsSinceEpoch) {
                      getMyDetailsInfo(year, month);
                    }
                    displayDates(month, year);
                  }, icon: const Icon(Icons.arrow_right, color: Colors.white,)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  weekSizeBox(Constants.red, weekList[0]),
                  weekSizeBox(Colors.white, weekList[1]),
                  weekSizeBox(Colors.white, weekList[2]),
                  weekSizeBox(Colors.white, weekList[3]),
                  weekSizeBox(Colors.white, weekList[4]),
                  weekSizeBox(Colors.white, weekList[5]),
                  weekSizeBox(Colors.black, weekList[6]),
                ],
              ),
            ],
          ),

        ),
        Container(
          color: const Color(0xFFD4F2FF),
          width: 332.5,
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 7; i++)
                    daySizedBox(decorationList[i])
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 7; i < 14; i++)
                    daySizedBox(decorationList[i])
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 14; i < 21; i++)
                    daySizedBox(decorationList[i])
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 21; i < 28; i++)
                    daySizedBox(decorationList[i])
                ],
              ),
              if (show5)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 28; i < 35; i++)
                      daySizedBox(decorationList[i])
                  ],
                ),
              if (show6)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 35; i < 42; i++)
                      daySizedBox(decorationList[i])
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    month = widget.month;
    year = widget.year;
    dateTypeList = widget.dateTypeList;
    staffId = widget.staffId;
    displayDates(month, year);
    supports = Supports(context);
  }

  void displayDates(int month, int year) {
    DateTime firstDate = DateTime(year, month, 1);
    DateTime lastDate = DateTime(year, month+1, 0);
    int firstDay = firstDate.weekday;
    switch (lastDate.day) {
      case 31:
        show5 = true;
        show6 =  (firstDay == 6 || firstDay == 5);
      case 30:
        show5 = true;
        show6 = (firstDay == 6);
      case 28:
        show5 = (firstDay != 7);
        show6 = false;
      default:
        show5 = true;
        show6 = false;
    }

    if (firstDay == 7) {
      firstDay = 0;
    }

    setDisplay(firstDay, lastDate.day, month, year);
  }

  void setDisplay(int day, int endDate, int month, int year) {
    decorationList.clear();
    int previousDate = 0;
    for (int i = 0; i < 42; i++) {
      if (i < day) {
        CustomCalenderDecoration decoration = CustomCalenderDecoration(" ", null, Colors.transparent, Colors.transparent, rectangleBorder, normalTextStyle, false);
        decorationList.add(decoration);
      } else if (i == 0) {
        previousDate++;
        DateTime dateTime = DateTime(year, month, previousDate);
        late Color foregroundColor, backgroundColor = Colors.transparent;
        late TextStyle textStyle = normalTextStyle;
        late OutlinedBorder border = rectangleBorder;
        if (dateTime.weekday == 7) {
          foregroundColor = Colors.red;
        } else if (dateTime.weekday == 6) {
          foregroundColor = Colors.black;
        } else {
          foregroundColor = Constants.company;
        }
        late String? type;

        try {
          if (dateTime.millisecondsSinceEpoch < DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .millisecondsSinceEpoch) {
            for (DateType dateType in dateTypeList) {
              if (dateTime.day == dateType.dateTime.day && dateType.dateTime == getDateTime(dateType.dateTime.day)) {
                type = dateType.type;
                if (type == "0") {
                  if (dateTime.weekday == 7) {
                    foregroundColor = Colors.white;
                    backgroundColor = const Color(0xFF02AAF1);
                    border = roundBorder;
                    textStyle = boldTextStyle;
                  } else {
                    foregroundColor = Colors.white;
                    backgroundColor = const Color(0xFFFD0002);
                    border = roundBorder;
                    textStyle = boldTextStyle;
                  }
                }
                else {
                  if (type == "W" || type == "CO" || type == "LH") {
                    foregroundColor = const Color(0xFF016DB5);
                    backgroundColor = const Color(0xFF00FE06);
                    border = roundBorder;
                    textStyle = boldTextStyle;
                  } else if (type == "HO") {
                    foregroundColor = Colors.white;
                    backgroundColor = const Color(0xFF02AAF1);
                    border = roundBorder;
                    textStyle = boldTextStyle;
                  } else if (type == "LOP") {
                    foregroundColor = Colors.white;
                    backgroundColor = const Color(0xFFFD0002);
                    border = roundBorder;
                    textStyle = boldTextStyle;
                  } else {
                    foregroundColor = const Color(0xFF016DB5);
                    backgroundColor = const Color(0xFFFCFFFF);
                    border = roundBorder;
                    textStyle = boldTextStyle;
                  }
                }
              }
            }
          } else if (dateTime.day == DateTime.now().day  && DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) == getDateTime(dateTime.day)) {
            for (DateType dateType in dateTypeList) {
              if (dateTime.day == dateType.dateTime.day  && dateType.dateTime == getDateTime(dateType.dateTime.day)) {
                type = dateType.type;
                if (type == "0") {
                  if (dateTime.weekday == 7) {
                    foregroundColor = Colors.white;
                    backgroundColor = const Color(0xFF02AAF1);
                    border = rectangleBorder;
                    textStyle = boldTextStyle;
                  } else {
                    foregroundColor = Colors.white;
                    backgroundColor = const Color(0xFF00CEBC);
                    border = rectangleBorder;
                    textStyle = boldTextStyle;
                  }
                } else {
                  if (type == "W" || type == "CO" || type == "LH") {
                    foregroundColor = const Color(0xFF016DB5);
                    backgroundColor = const Color(0xFF00FE06);
                    border = rectangleBorder;
                    textStyle = boldTextStyle;
                  } else if (type == "HO") {
                    foregroundColor = Colors.white;
                    backgroundColor = const Color(0xFF02AAF1);
                    border = rectangleBorder;
                    textStyle = boldTextStyle;
                  } else if (type == "LOP") {
                    foregroundColor = Colors.white;
                    backgroundColor = const Color(0xFFFD0002);
                    border = rectangleBorder;
                    textStyle = boldTextStyle;
                  } else {
                    foregroundColor = const Color(0xFF016DB5);
                    backgroundColor = const Color(0xFFFCFFFF);
                    border = rectangleBorder;
                    textStyle = boldTextStyle;
                  }
                }
              }
            }
          }
        } on Exception catch (e) {
          print(e);
    }

        CustomCalenderDecoration decoration = CustomCalenderDecoration(twoDigit(previousDate), dateTime, foregroundColor, backgroundColor, border, textStyle, true);
        decorationList.add(decoration);
      } else {
        int currentDate = previousDate + 1;
        if (currentDate <= endDate) {
          DateTime dateTime = DateTime(year, month, currentDate);
          late Color foregroundColor, backgroundColor = Colors.transparent;
          late TextStyle textStyle = normalTextStyle;
          late OutlinedBorder border = rectangleBorder;
          if (dateTime.weekday == 7) {
            foregroundColor = Colors.red;
          } else if (dateTime.weekday == 6) {
            foregroundColor = Colors.black;
          } else {
            foregroundColor = Constants.company;
          }

          late String? type;

          try {
            if (dateTime.millisecondsSinceEpoch < DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .millisecondsSinceEpoch) {
              for (DateType dateType in dateTypeList) {
                if (dateTime.day == dateType.dateTime.day  && dateType.dateTime == getDateTime(dateType.dateTime.day)) {
                  type = dateType.type;
                  if (type == "0") {
                    if (dateTime.weekday == 7) {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFF02AAF1);
                      border = roundBorder;
                      textStyle = boldTextStyle;
                    } else {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFFFD0002);
                      border = roundBorder;
                      textStyle = boldTextStyle;
                    }
                  } else {
                    if (type == "W" || type == "CO" || type == "LH") {
                      foregroundColor = const Color(0xFF016DB5);
                      backgroundColor = const Color(0xFF00FE06);
                      border = roundBorder;
                      textStyle = boldTextStyle;
                    } else if (type == "HO") {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFF02AAF1);
                      border = roundBorder;
                      textStyle = boldTextStyle;
                    } else if (type == "LOP") {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFFFD0002);
                      border = roundBorder;
                      textStyle = boldTextStyle;
                    } else {
                      foregroundColor = const Color(0xFF016DB5);
                      backgroundColor = const Color(0xFFFCFFFF);
                      border = roundBorder;
                      textStyle = boldTextStyle;
                    }
                  }
                }
              }
            } else if (dateTime.day == DateTime.now().day && DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) == getDateTime(dateTime.day)) {
              for (DateType dateType in dateTypeList) {
                if (dateTime.day == dateType.dateTime.day  && dateType.dateTime == getDateTime(dateType.dateTime.day)) {
                  type = dateType.type;
                  if (type == "0") {
                    if (dateTime.weekday == 7) {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFF02AAF1);
                      border = rectangleBorder;
                      textStyle = boldTextStyle;
                    } else {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFF00CEBC);
                      border = rectangleBorder;
                      textStyle = boldTextStyle;
                    }
                  } else {
                    if (type == "W" || type == "CO" || type == "LH") {
                      foregroundColor = const Color(0xFF016DB5);
                      backgroundColor = const Color(0xFF00FE06);
                      border = rectangleBorder;
                      textStyle = boldTextStyle;
                    } else if (type == "HO") {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFF02AAF1);
                      border = rectangleBorder;
                      textStyle = boldTextStyle;
                    } else if (type == "LOP") {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFFFD0002);
                      border = rectangleBorder;
                      textStyle = boldTextStyle;
                    } else {
                      foregroundColor = const Color(0xFF016DB5);
                      backgroundColor = const Color(0xFFFCFFFF);
                      border = rectangleBorder;
                      textStyle = boldTextStyle;
                    }
                  }
                }
              }

              // foregroundColor = const Color(0xFF016DB5);
              // backgroundColor = Colors.white;
              // border = rectangleBorder;
              // textStyle = boldTextStyle;
            }
          } on Exception catch (e) {
            print(e);
          }

          CustomCalenderDecoration decoration = CustomCalenderDecoration(twoDigit(currentDate), dateTime, foregroundColor, backgroundColor, border, textStyle, true);
          decorationList.add(decoration);
        } else {
          CustomCalenderDecoration decoration = CustomCalenderDecoration(" ", null, Colors.transparent, Colors.transparent, rectangleBorder, normalTextStyle, false);
          decorationList.add(decoration);
        }
        previousDate++;
      }
    }
    setState(() {

    });
  }

  DateTime getDateTime(int day) {
    return DateTime(year, month, day);
  }

  ButtonStyle monthButtonStyle = TextButton.styleFrom(
    alignment: Alignment.center,
    backgroundColor: Constants.company,
    foregroundColor:  Colors.white,
    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
    minimumSize: const Size(120.0, 30.0),
    maximumSize: const Size(120.0, 30.0),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))
  );

  TextStyle weekTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle boldTextStyle = const TextStyle(fontWeight: FontWeight.bold);

  TextStyle normalTextStyle = const TextStyle(fontStyle: FontStyle.normal);

  SizedBox weekSizeBox(Color color, String text) {
    return SizedBox(
      width: 47.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: weekTextStyle(color),),
        ],
      ),
    );
  }
  
  ButtonStyle weekButtonStyle(Color color) {
    return TextButton.styleFrom(
      alignment: Alignment.center,
      minimumSize: const Size(40.0, 20.0),
      // maximumSize: const Size(40.0, 20.0),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      foregroundColor: Constants.signature,
    );
  }

  SizedBox daySizedBox(CustomCalenderDecoration decoration) {
    return SizedBox(
      width: 47.5,
      height: 48.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (decoration.isActive)
            TextButton(
                style: dayButtonStyle(decoration.foregroundColor, decoration.backgroundColor, decoration.shape),
                onPressed: (){
                  displayContent(decoration.dateTime!);
                }, child: Text(decoration.day, style: decoration.textStyle,)),
          if (!decoration.isActive)
            const SizedBox(width: 44.0, height: 44.0,),
        ],
      ),
    );
  }

  ButtonStyle dayButtonStyle(Color foregroundColor, Color backgroundColor, OutlinedBorder shape) {
    return TextButton.styleFrom(
      alignment: Alignment.center,
      minimumSize: const Size(44.0, 44.0),
      maximumSize: const Size(44.0, 44.0),
      shape: shape,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }

  BoxDecoration dayContainerDecorationStyle(Color foregroundColor, Color backgroundColor, BoxShape shape) {
    return BoxDecoration(
      color: foregroundColor,
      shape: shape,
    );
  }

  String currentMonth() {
    List<String> monthList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return monthList[month-1];
  }
  
  void getDayList() {
    dayList.clear();
    decorationList.clear();
    for (int i = 0; i < 42; i++) {
      dayList.add(twoDigit(i));
      CustomCalenderDecoration decoration = CustomCalenderDecoration(twoDigit(i), DateTime.now(), Constants.red, Constants.green, roundBorder, normalTextStyle, true);
      decorationList.add(decoration);
    }
  }

  OutlinedBorder rectangleBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)));
  OutlinedBorder roundBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.25)));
  OutlinedBorder rectangleBorder2 = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)),);

  String twoDigit(int value) {
    if (value < 10) {
      return "0$value";
    } else {
      return"$value";
    }
  }

  void displayContent(DateTime dateTime) async {
    if (dateTime.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
      Map<String, String> data = {
        Constants.requestType : Constants.theInformation,
        Constants.staffId     : staffId,
        Constants.date        : "${dateTime.year}-${twoDigit(dateTime.month)}-${twoDigit(dateTime.day)}",
      };
      var response = await post(Constants.client, body: data);
      if (response.statusCode == 200) {
        handleResponse(response.body);
      } else {
        supports.createSnackBar(Constants.errorMessage);
      }
    }
  }

  void handleResponse(String response) {
    List<String> list1 = response.split("&");
    List<String> list2 = response.split(Constants.splitter1);
    if (list1[0] == "Checked") {
      List<String> list3 = [];
      for (int i = 1; i < list1.length; i++) {
        list3.add(list1[i]);
      }
      showDialog(context: context, builder: (BuildContext context) => Dialog(
        child: CheckedDialog(responseList: list3,),
      ));
    } else if (list2[0] == "Timesheet") {
      List<String> list3 = [];
      for (int i = 1; i < list2.length; i++) {
        list3.add(list2[i]);
      }
      showDialog(context: context, builder: (BuildContext context) => Dialog(
        child: TimesheetDialog(responseList: list3,),
      ));
    } else {
      supports.createSnackBar("No data found");
    }
  }

  void getMyDetailsInfo(int year, int month) async {
    Map<String, String> data = {
      Constants.requestType : Constants.getMyDetailsInfo,
      Constants.staffId     : staffId,
      Constants.date        : "$year-${supports.twoDigit(month)}",
    };
    var client = Client();
    var response;
    try {
      response = await post(Constants.client, body: data);
    } finally {
      if (response.statusCode == 200) {
        handleMyDetails(response.body, year, month);
      } else {
        supports.createSnackBar(Constants.errorMessage);
      }
      client.close();
    }
  }

  void handleMyDetails(String response, int year, int month) {
    List<String> list1 = response.split(Constants.splitter1);
    for (int i = 1; i <= DateTime(year, month+1, 0).day; i++) {
      try {
        List<String> list2 = list1[i].split(Constants.splitter2);
        DateType dateType = DateType(list2[0], DateTime.parse(list2[1]));
        dateTypeList.add(dateType);
      } on Exception {
        supports.createSnackBar(Constants.errorMessage);
      }
    }
    setState(() {
      displayDates(month, year);
    });
  }

}

class CustomCalenderDecoration{
  late String day;
  late DateTime? dateTime;
  late Color foregroundColor, backgroundColor;
  late OutlinedBorder shape;
  late bool isActive;
  late TextStyle textStyle;

  CustomCalenderDecoration(this.day, this.dateTime, this.foregroundColor,
      this.backgroundColor, this.shape, this.textStyle, this.isActive);
}

class DateType {
  late String type;
  late DateTime dateTime;

  DateType(this.type, this.dateTime);
}
