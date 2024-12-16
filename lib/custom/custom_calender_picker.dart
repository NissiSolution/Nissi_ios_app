import "package:flutter/material.dart";

import "../Supports/constants.dart";

class CustomCalenderPicker extends StatefulWidget {
  CustomCalenderPicker({super.key,
  this.month,
  this.year,
  this.startDate,
  this.endDate,
  this.selectedDate, this.isOneMonth, this.onValueChanged,});

  late int? month, year;
  late DateTime? startDate, endDate, selectedDate;
  late ValueChanged<DateTime?>? onValueChanged;
  late bool? isOneMonth;

  @override
  State<CustomCalenderPicker> createState() => _CustomCalenderPickerState();
}

class _CustomCalenderPickerState extends State<CustomCalenderPicker> {

  late int month, year;
  final List<String> weekList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
      monthList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  late bool show5, show6;
  late List<DayColor?> dateList;
  late DateTime selectedDate, currentDate = DateTime.now();
  late ValueChanged<DateTime?> onValueChanged;
  late DateTime? startDate, endDate;
  late bool isOneMonth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    month = (widget.month ?? DateTime.now().month);
    year = (widget.year ?? DateTime.now().year);
    selectedDate = (widget.selectedDate  ?? DateTime.now());
    startDate = (widget.startDate);
    endDate = (widget.endDate);
    displayDates(month, year);
    onValueChanged = widget.onValueChanged!;
    isOneMonth = (widget.isOneMonth ?? false);
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
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
                    changeMonth(1);
                    // if (month == 1) {
                    //   month = 12;
                    //   year = year - 1;
                    // } else {
                    //   month = month - 1;
                    // }
                    // setState(() {
                    //
                    // });
                    // displayDates(month, year);
                  }, icon: const Icon(Icons.arrow_left, color: Colors.white,)),
                  TextButton(
                      style: monthButtonStyle,
                      onPressed: () {
                        // displayDates(month, year);
                      },
                      child: Text("${monthList[month - 1]} $year")),
                  IconButton(onPressed: () {
                    changeMonth(2);
                    // if (month == 12) {
                    //   month = 1;
                    //   year = year + 1;
                    // } else {
                    //   month = month + 1;
                    // }
                    // setState(() {
                    //
                    // });
                    // displayDates(month, year);
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
          padding: const EdgeInsets.only(top: 2.0),
          margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
          width: 269.5,
          decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0),), color: Color(0xFFD4F2FF)),
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                  children: [
                    for (int i = 0; i < 7; i++)
                      daySizedBox(dateList[i]),
                  ]
              ),
              Row(children: [
                for (int i = 7; i < 14; i++)
                  daySizedBox(dateList[i]),
              ]
              ),
              Row(children: [
                for (int i = 14; i < 21; i++)
                  daySizedBox(dateList[i]),
              ]
              ),
              Row(children: [
                for (int i = 21; i < 28; i++)
                  daySizedBox(dateList[i]),
              ]
              ),
              if (show5)
                Row(
                  children: [
                    for (int i = 28; i < 35; i++)
                    daySizedBox(dateList[i]),
                  ]
              ),
              if (show6)
                Row(
                children: [
                  for (int i = 35; i < 42; i++)
                  daySizedBox(dateList[i]),
                ],
              )
            ],
          )
        )
      ],
    );
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

  void setDisplay(int day, int endDate, int month, int year) {
    dateList = [];
    int previousDate = 0;
    for (int i = 0; i < 42; i++) {
      if (i < day) {
        dateList.add(null);
      } else if (i == 0) {
        previousDate++;
        DateTime dateTime = DateTime(year, month, previousDate);
        late Color foregroundColor;
        if (dateTime.weekday == 7) {
          foregroundColor = Colors.red;
        } else if (dateTime.weekday == 6) {
          foregroundColor = Colors.black;
        } else {
          foregroundColor = Constants.company;
        }
        dateList.add(DayColor(getTwoDigit(previousDate), foregroundColor));
      } else {
        int currentDate = previousDate + 1;
        if (currentDate <= endDate) {
          DateTime dateTime = DateTime(year, month, currentDate);
          late Color foregroundColor;
          if (dateTime.weekday == 7) {
            foregroundColor = Colors.red;
          } else if (dateTime.weekday == 6) {
            foregroundColor = Colors.black;
          } else {
            foregroundColor = Constants.company;
          }
          dateList.add(DayColor(getTwoDigit(currentDate), foregroundColor));
        } else {
          dateList.add(null);
        }
        previousDate++;
      }
    }
    setState(() {

    });

  }

  void changeMonth(int type) {
    if ((startDate != null && endDate != null)) {
      if (type == 1) {
        if (DateTime(startDate!.year, startDate!.month).millisecondsSinceEpoch < DateTime(year, month).millisecondsSinceEpoch) {
          if (month == 1) {
            month = 12;
            year = year - 1;
          } else {
            month = month - 1;
          }
        }
      } else if (type == 2) {
        if (DateTime(endDate!.year, endDate!.month).millisecondsSinceEpoch < DateTime(year, month).millisecondsSinceEpoch) {
          if (month == 12) {
            month = 1;
            year = year + 1;
          } else {
            month = month + 1;
          }
        }
      }
    } else if (startDate != null) {
      if (type == 1) {
        if (DateTime(startDate!.year, startDate!.month).millisecondsSinceEpoch < DateTime(year, month).millisecondsSinceEpoch) {
          if (month == 1) {
            month = 12;
            year = year - 1;
          } else {
            month = month - 1;
          }
        }
      } else if (type == 2) {
        if (month == 12) {
          month = 1;
          year = year + 1;
        } else {
          month = month + 1;
        }
      }
    } else if (endDate != null) {
      if (type == 1) {
        if (month == 1) {
          month = 12;
          year = year - 1;
        } else {
          month = month - 1;
        }
      } else if (type == 2) {
        if (DateTime(endDate!.year, endDate!.month).millisecondsSinceEpoch < DateTime(year, month).millisecondsSinceEpoch) {
          if (month == 12) {
            month = 1;
            year = year + 1;
          } else {
            month = month + 1;
          }
        }
      }
    } else if (!isOneMonth) {
      if (type == 1) {
        if (month == 1) {
          month = 12;
          year = year - 1;
        } else {
          month = month - 1;
        }
      } else if (type == 2) {
        if (month == 12) {
          month = 1;
          year = year + 1;
        } else {
          month = month + 1;
        }
      }
    }
    displayDates(month, year);
  }

  String getTwoDigit(int value) {
    if (value < 10) {
      return "0$value";
    }
    return value.toString();
  }

  SizedBox daySizedBox(DayColor? dayColor) {
    return
      SizedBox(
        width: 38.5,
        height: 38.5,
        child: Column(
          children: [
            if (dayColor != null)
              Container(
                decoration: boxDecoration(dayColor.text),
                padding: const EdgeInsets.all(4.0),
                child: InkResponse(
                  onTap: () {
                    setState(() {
                      selectedDate = DateTime(year, month, int.parse(dayColor.text));
                      onValueChanged(selectedDate);
                    });
                  },
                  child: Text(dayColor.text, style: textStyle(dayColor.color, dayColor.text),),
                ),
              ),
          ],
        ),
      );
  }

  TextStyle textStyle(Color color, String text) {
    DateTime currentDate = DateTime(year, month, int.parse(text));

    if (startDate != null && endDate != null) {
      DateTime startTime = DateTime(startDate!.year, startDate!.month, startDate!.day);
      DateTime endTime = DateTime(endDate!.year, endDate!.month, endDate!.day);
      if (currentDate.millisecondsSinceEpoch <= startTime.millisecondsSinceEpoch &&
          currentDate.millisecondsSinceEpoch >= endTime.millisecondsSinceEpoch) {
        return const TextStyle(color: Colors.black26);
      }
    } else if (startDate != null) {
      DateTime startTime = DateTime(startDate!.year, startDate!.month);
      if (currentDate.millisecondsSinceEpoch >= startTime.millisecondsSinceEpoch) {
        return const TextStyle(color: Colors.black26);
      }
    } else if (endDate != null) {
      DateTime endTime = DateTime(endDate!.year, endDate!.month, endDate!.day);
      if (currentDate.millisecondsSinceEpoch <= endTime.millisecondsSinceEpoch) {
        return const TextStyle(color: Colors.black26);
      }
    }

    if (selectedDate.day == currentDate.day && selectedDate.month == currentDate.month && selectedDate.year == currentDate.year) {
      return const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    } else {
      return TextStyle(color: color);
    }
  }

  BoxDecoration boxDecoration(String text) {
    DateTime currentDate = DateTime(year, month, int.parse(text));
    if (selectedDate.day == currentDate.day && selectedDate.month == currentDate.month && selectedDate.year == currentDate.year) {
      return BoxDecoration(color: Constants.company, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5.0), border: const Border(top: BorderSide(color: Constants.company),bottom: BorderSide(color: Constants.company), right: BorderSide(color: Constants.company), left: BorderSide(color: Constants.company)));
    } else if (currentDate.day == this.currentDate.day && currentDate.month == this.currentDate.month && currentDate.year == this.currentDate.year) {
      return BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: const Border(top: BorderSide(color: Constants.company),bottom: BorderSide(color: Constants.company), right: BorderSide(color: Constants.company), left: BorderSide(color: Constants.company)));
    } else {
      return const BoxDecoration();
    }
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

  TextStyle weekTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  ButtonStyle monthButtonStyle = TextButton.styleFrom(
      alignment: Alignment.center,
      backgroundColor: Constants.company,
      foregroundColor:  Colors.white,
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
      minimumSize: const Size(140.0, 30.0),
      maximumSize: const Size(140.0, 30.0),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))
  );

}

class DayColor {
  late String text;
  late Color color;

  DayColor(this.text, this.color);

}
