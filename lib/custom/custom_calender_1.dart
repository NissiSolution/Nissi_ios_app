import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Supports/constants.dart';
import '../Supports/supports.dart';
import '../views/dialog/dialog.dart';

class CustomCalender2 extends StatefulWidget {
  CustomCalender2({
    required this.month,
    required this.year,
    required this.dateTypeList,
    required this.staffId,
    super.key,
  });

  late int month, year;
  late String staffId;
  late List<DateType2> dateTypeList;

  @override
  State<CustomCalender2> createState() => _CustomCalender2State();
}

class _CustomCalender2State extends State<CustomCalender2> {

  late int month, year;
  late List<DateType2> dateTypeList = [];
  final List<String> weekList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  late List<String> dayList = [];
  late List<CustomCalenderDecoration2> decorationList = [];
  late bool show5 = false, show6 = false;
  late String staffId;
  late Supports supports;

  @override
  Widget build(BuildContext context) {
    dateTypeList = widget.dateTypeList;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
          width: 269.5,
          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0),), color: Constants.company),
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
          margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
          decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0),), color: Color(0xFFD4F2FF)),
          width: 269.5,
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
    DateTime lastDate = DateTime(year, month + 1, 0);
    int firstDay = firstDate.weekday;
    switch (lastDate.day) {
      case 31:
        show5 = true;
        show6 = (firstDay == 6 || firstDay == 5);
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

  BoxDecoration rectangleBorder(Color backgroundColor) {
    return BoxDecoration(color: backgroundColor, shape: BoxShape.rectangle);
  }
  BoxDecoration roundBorder(Color backgroundColor) {
    return BoxDecoration(color: backgroundColor, shape: BoxShape.circle);
  }
  BoxDecoration currentDayBorder = BoxDecoration(shape: BoxShape.rectangle, gradient: const LinearGradient(colors: [Constants.signature, Constants.green, Constants.redText], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: const BorderRadius.all(Radius.circular(5.0)), border: Border.all(color: Constants.company,));

  BoxDecoration roundBorder2 (Color backgroundcolor2,backgroundcolor3, ){
    return  BoxDecoration(gradient: LinearGradient(colors: [backgroundcolor2,backgroundcolor3],begin: Alignment.topLeft, end: Alignment.bottomRight,),shape: BoxShape.circle,);

  }
  BoxDecoration rectangleBorder2 (Color backgroundcolor2, backgroundcolor3){
    return BoxDecoration( gradient:  LinearGradient(colors: [backgroundcolor2,backgroundcolor3], begin: Alignment.topLeft, end:  Alignment.bottomRight), shape: BoxShape.rectangle);
  }
  TextStyle boldTextStyle (Color fontColor) {
    return TextStyle(fontWeight: FontWeight.bold, color: fontColor);
  }
  TextStyle normalTextStyle (Color fontColor) {
    return TextStyle(fontStyle: FontStyle.normal, color: fontColor);
  }


    void setDisplay(int day, int endDate, int month, int year) {
      decorationList.clear();
      int previousDate = 0;
      for (int i = 0; i < 42; i++) {
        if (i < day) {
          CustomCalenderDecoration2 decoration2 = CustomCalenderDecoration2(' ', null, rectangleBorder(Colors.transparent), normalTextStyle(Colors.transparent), false);
          decorationList.add(decoration2);
        } else if (i == 0) {
          previousDate++;
          DateTime dateTime = DateTime(year, month, previousDate);
          late Color foregroundColor, backgroundColor = Colors.transparent;
          late TextStyle textStyle = normalTextStyle(foregroundColor);
          late BoxDecoration border = rectangleBorder(backgroundColor);
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
              for (DateType2 dateType in dateTypeList) {
                if (dateTime.day == dateType.dateTime.day && dateType.dateTime == getDateTime(dateType.dateTime.day)) {
                  type = dateType.type;
                  if (type == "0") {
                    if (dateTime.weekday == 7) {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFF02AAF1);
                      border = roundBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);
                    } else {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFFFD0002);
                      border = roundBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);
                    }
                  }
                  else {
                    if (type == "W" || type == "CO" || type == "LH") {
                     foregroundColor = const Color(0xFF016DB5);
                      backgroundColor = const Color(0xFF00FE06);
                      border = roundBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);
                    } else if (type == "HO") {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFF02AAF1);
                      border = roundBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);
                    } else if (type == "LOP" || type == '0LOP' || type == 'LOP0') {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFFFD0002);
                      border = roundBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if(type == "SLHD" || type == "SIHD" || type == "CLHD" || type == "ELHD" || type == "PLHD" || type == "MLHD"){
                      foregroundColor = const Color(0xFF016DB5);
                      border = roundBorder2(Colors.white, const Color(0xFF00FE06));
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if( type == 'HDSL' || type == "HDSI" || type == "HDCL" || type == "HDEL" || type == "HDPL" || type == "HDML"){
                      foregroundColor = const Color(0xFF016DB5);
                      border = roundBorder2(const Color(0xFF00FE06), Colors.white);
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if(type == 'LOPHD'){
                      foregroundColor = Colors.white;
                      border = roundBorder2(const Color(0xFFFD0002),const Color(0xFF00FE06));
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if(type == 'HDLOP' || type == "HD"){
                      foregroundColor = Colors.white;
                      border = roundBorder2(const Color(0xFF00FE06), const Color(0xFFFD0002));
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if(type == '0SL'|| type == '0SI' || type == '0CL' || type == '0EL' || type == '0PL' || type == '0ML'){
                      foregroundColor = const Color(0xFF016DB5);
                      border = roundBorder2(const Color(0xFFFD0002), Colors.white);
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if(type == 'SL0' || type == 'SI0' || type == 'CL0' || type == 'EL0' || type == 'PL0' || type == 'ML0'){
                      foregroundColor = const Color(0xFF016DB5);
                      border = roundBorder2(Colors.white, const Color(0xFFFD0002));
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else {
                      foregroundColor = const Color(0xFF016DB5);
                      backgroundColor = const Color(0xFFFCFFFF);
                      border = roundBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);
                    }
                  }
                }
              }
            } else if (dateTime.day == DateTime.now().day  && DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) == getDateTime(dateTime.day)) {
              for (DateType2 dateType in dateTypeList) {
                if (dateTime.day == dateType.dateTime.day  && dateType.dateTime == getDateTime(dateType.dateTime.day)) {
                  type = dateType.type;
                  if (type == "0") {
                    if (dateTime.weekday == 7) {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFF02AAF1);
                      border = rectangleBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);
                    } else {
                      foregroundColor = Colors.white;
                      border = currentDayBorder;
                      textStyle = boldTextStyle(foregroundColor);
                    }
                  } else {
                    if (type == "W" || type == "CO" || type == "LH") {
                      foregroundColor = const Color(0xFF016DB5);
                     backgroundColor = const Color(0xFF00FE06);
                     border = rectangleBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);

                    } else if (type == "HO") {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFF02AAF1);
                      border = rectangleBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if (type == "LOP" || type == '0LOP' || type == 'LOP0') {
                      foregroundColor = Colors.white;
                      backgroundColor = const Color(0xFFFD0002);
                      border = rectangleBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if(type == "SLHD" || type == "SIHD" || type == "CLHD" || type == "ELHD" || type == "PLHD" || type == "MLHD"){
                      foregroundColor = const Color(0xFF016DB5);
                      border = rectangleBorder2(Colors.white, const Color(0xFF00FE06));
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if( type == 'HDSL' || type == "HDSI" || type == "HDCL" || type == "HDEL" || type == "HDPL" || type == "HDML"){
                      foregroundColor = const Color(0xFF016DB5);
                      border = rectangleBorder2(const Color(0xFF00FE06), Colors.white);
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if(type == 'LOPHD'){
                      foregroundColor = Colors.white;
                      border = rectangleBorder2(const Color(0xFFFD0002),const Color(0xFF00FE06));
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if(type == 'HDLOP' || type == "HD"){
                      foregroundColor = Colors.white;
                      border = rectangleBorder2(const Color(0xFF00FE06), const Color(0xFFFD0002));
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if(type == '0SL'|| type == '0SI' || type == '0CL' || type == '0EL' || type == '0PL' || type == '0ML'){
                      foregroundColor = const Color(0xFF016DB5);
                      border = rectangleBorder2(const Color(0xFFFD0002), Colors.white);
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else if(type == 'SL0' || type == 'SI0' || type == 'CL0' || type == 'EL0' || type == 'PL0' || type == 'ML0'){
                      foregroundColor = const Color(0xFF016DB5);
                      border = rectangleBorder2(Colors.white, const Color(0xFFFD0002));
                      textStyle = boldTextStyle(foregroundColor);
                    }
                    else {
                      foregroundColor = const Color(0xFF016DB5);
                      backgroundColor = const Color(0xFFFCFFFF);
                      border = rectangleBorder(backgroundColor);
                      textStyle = boldTextStyle(foregroundColor);
                    }
                  }
                }
              }
            }
          } on Exception catch (e) {
            print(e);
          }

          CustomCalenderDecoration2 decoration = CustomCalenderDecoration2(twoDigit(previousDate), dateTime, border, textStyle, true);
          decorationList.add(decoration);
        } else {
          int currentDate = previousDate + 1;
          if (currentDate <= endDate) {
            DateTime dateTime = DateTime(year, month, currentDate);
            late Color foregroundColor, backgroundColor = Colors.transparent;
            late TextStyle textStyle = normalTextStyle(foregroundColor);
            late BoxDecoration border = rectangleBorder(backgroundColor);
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
                for (DateType2 dateType in dateTypeList) {
                  if (dateTime.day == dateType.dateTime.day  && dateType.dateTime == getDateTime(dateType.dateTime.day)) {
                    type = dateType.type;
                    if (type == "0") {
                      if (dateTime.weekday == 7) {
                        foregroundColor = Colors.white;
                        backgroundColor = const Color(0xFF02AAF1);
                        border = roundBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);
                      } else {
                        foregroundColor = Colors.white;
                        backgroundColor = const Color(0xFFFD0002);
                        border = roundBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);
                      }
                    } else {
                      if (type == "W" || type == "CO" || type == "LH") {
                        foregroundColor = const Color(0xFF016DB5);
                        backgroundColor = const Color(0xFF00FE06);
                        border = roundBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);

                      } else if (type == "HO") {
                        foregroundColor = Colors.white;
                        backgroundColor = const Color(0xFF02AAF1);
                        border = roundBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);
                      } else if (type == "LOP" || type == '0LOP' || type == 'LOP0') {
                        foregroundColor = Colors.white;
                        backgroundColor = const Color(0xFFFD0002);
                        border = roundBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if(type == 'SIHD' || type == 'SLHD' || type == 'CLHD' || type == 'ELHD' || type == 'PLHD' || type == 'MLHD'){
                        foregroundColor = const Color(0xFF016DB5);
                        border = roundBorder2(Colors.white, const Color(0xFF00FE06));
                        textStyle = boldTextStyle(foregroundColor);

                      }
                      else if( type == 'HDSL' || type == 'HDSI' || type == 'HDCL' || type == 'HDEL' || type == 'HDPL' || type == 'HDML'){
                        foregroundColor = const Color(0xFF016DB5);
                        border = roundBorder2(const Color(0xFF00FE06), Colors.white);
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if( type == 'LOPHD'){
                        foregroundColor = Colors.white;
                        border = roundBorder2(const Color(0xFFFD0002), const Color(0xFF00FE06));
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if( type == 'HDLOP' || type == 'HD'){
                        foregroundColor = Colors.white;
                        border = roundBorder2(const Color(0xFF00FE06), const Color(0xFFFD0002));
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if(type == '0SL'|| type == '0SI' || type == '0CL' || type == '0EL' || type == '0PL' || type == '0ML'){
                        foregroundColor = const Color(0xFF016DB5);
                        border = roundBorder2(const Color(0xFFFD0002), Colors.white);
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if(type == 'SL0' || type == 'SI0' || type == 'CL0' || type == 'EL0' || type == 'PL0' || type == 'ML0'){
                        foregroundColor = const Color(0xFF016DB5);
                        border = roundBorder2(Colors.white, const Color(0xFFFD0002));
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else {
                        foregroundColor = const Color(0xFF016DB5);
                        backgroundColor = const Color(0xFFFCFFFF);
                        border = roundBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);
                      }
                    }
                  }
                }
              } else if (dateTime.day == DateTime.now().day && DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) == getDateTime(dateTime.day)) {
                for (DateType2 dateType in dateTypeList) {
                  if (dateTime.day == dateType.dateTime.day  && dateType.dateTime == getDateTime(dateType.dateTime.day)) {
                    type = dateType.type;
                    if (type == "0") {
                      if (dateTime.weekday == 7) {
                        foregroundColor = Colors.white;
                        backgroundColor = const Color(0xFF02AAF1);
                        border = rectangleBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);
                      } else {
                        foregroundColor = Colors.white;
                        border = currentDayBorder;
                        textStyle = boldTextStyle(foregroundColor);
                      }
                    } else {
                      if (type == "W" || type == "CO" || type == "LH") {
                        foregroundColor = const Color(0xFF016DB5);
                        backgroundColor = const Color(0xFF00FE06);
                        border = roundBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);

                      } else if (type == "HO") {
                        foregroundColor = Colors.white;
                        backgroundColor = const Color(0xFF02AAF1);
                        border = rectangleBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);
                      } else if (type == "LOP" || type == '0LOP' || type == 'LOP0') {
                        foregroundColor = Colors.white;
                        backgroundColor = const Color(0xFFFD0002);
                        border = rectangleBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if(type == 'SIHD' || type == 'SLHD' || type == 'CLHD' || type == 'ELHD' || type == 'PLHD' || type == 'MLHD'){
                        foregroundColor = const Color(0xFF016DB5);
                        border = roundBorder2(Colors.white, const Color(0xFF00FE06));
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if( type == 'HDSL' || type == 'HDSI' || type == 'HDCL' || type == 'HDEL' || type == 'HDPL' || type == 'HDML'){
                        foregroundColor = const Color(0xFF016DB5);
                        border = roundBorder2(const Color(0xFF00FE06), Colors.white);
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if( type == 'LOPHD'){
                        foregroundColor = Colors.white;
                        border = roundBorder2(const Color(0xFFFD0002), const Color(0xFF00FE06));
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if( type == 'HDLOP' || type == 'HD'){
                        foregroundColor = Colors.white;
                        border = roundBorder2(const Color(0xFF00FE06), const Color(0xFFFD0002));
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if(type == '0SL'|| type == '0SI' || type == '0CL' || type == '0EL' || type == '0PL' || type == '0ML'){
                        foregroundColor = const Color(0xFF016DB5);
                        border = roundBorder2(const Color(0xFFFD0002), Colors.white);
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else if(type == 'SL0' || type == 'SI0' || type == 'CL0' || type == 'EL0' || type == 'PL0' || type == 'ML0'){
                        foregroundColor = const Color(0xFF016DB5);
                        border = roundBorder2(Colors.white, const Color(0xFFFD0002));
                        textStyle = boldTextStyle(foregroundColor);
                      }
                      else {
                        foregroundColor = const Color(0xFF016DB5);
                        backgroundColor = const Color(0xFFFCFFFF);
                        border = rectangleBorder(backgroundColor);
                        textStyle = boldTextStyle(foregroundColor);
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

            CustomCalenderDecoration2 decoration = CustomCalenderDecoration2(twoDigit(currentDate), dateTime, border, textStyle, true);
            decorationList.add(decoration);
          } else {
            CustomCalenderDecoration2 decoration = CustomCalenderDecoration2(" ", null, rectangleBorder(Colors.transparent), normalTextStyle(Colors.transparent), false);
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
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))
    );

    TextStyle weekTextStyle(Color color) {
      return TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
      );
    }

    SizedBox weekSizeBox(Color color, String text) {
      return SizedBox(
        width: 38.5,
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

    Container daySizedBox(CustomCalenderDecoration2 decoration) {
      return Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.all(4.25),
        decoration: decoration.boxDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (decoration.isActive)
              InkWell(
                  splashColor: Constants.signature,
                  onTap: (){
                    displayContent(decoration.dateTime!);
                  }, child: Text(decoration.day, style: decoration.textStyle,)),
          ],
        ),
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
        CustomCalenderDecoration2 decoration = CustomCalenderDecoration2(twoDigit(i), DateTime.now(), roundBorder(Constants.green), normalTextStyle(Constants.red), true);
        decorationList.add(decoration);
      }
    }

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
      print(response);
      List<String> list1 = response.split(Constants.splitter1);
      for (int i = 1; i <= DateTime(year, month+1, 0).day; i++) {
        try {
          List<String> list2 = list1[i].split(Constants.splitter2);
          DateType2 dateType = DateType2(list2[0], DateTime.parse(list2[1]));
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

class CustomCalenderDecoration2{
  late String day;
  late DateTime? dateTime;
  late BoxDecoration boxDecoration;
  late bool isActive;
  late TextStyle textStyle;

  CustomCalenderDecoration2(this.day, this.dateTime,
      this.boxDecoration, this.textStyle, this.isActive);
}

class DateType2{
  late String type;
  late DateTime dateTime;

  DateType2(this.type, this.dateTime);
}
