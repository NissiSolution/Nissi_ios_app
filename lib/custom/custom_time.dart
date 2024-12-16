import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Supports/constants.dart';

class CustomTime extends StatefulWidget {
  const CustomTime({super.key});

  @override
  State<CustomTime> createState() => _CustomTimeState();
}

class _CustomTimeState extends State<CustomTime> {

  bool showCol = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loopTime();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(hour(), style: Constants.textStyle6(Constants.company, 20.0),),
        if (showCol)
          Text(" : ", style: Constants.textStyle6(Constants.signature, 20.0),),
        if (!showCol)
          Text(" : ", style: Constants.textStyle6(Colors.white, 20.0),),
        Text(minute(), style: Constants.textStyle6(Constants.company, 20.0),),
        Text(amPm(), style: Constants.textStyle6(Constants.company, 15.0),),
      ],
    );
  }

  Future<void> loopTime() async {

    Future.delayed(const Duration(milliseconds: 1000), () {

      setState(() {
        showCol = !showCol;
      });
      loopTime();
    });
  }

  String hour() {
    DateFormat format = DateFormat("hh");
    return format.format(DateTime.now());
  }

  String minute() {
    DateFormat format = DateFormat("mm");
    return format.format(DateTime.now());
  }

  String amPm() {
    DateFormat format = DateFormat(" a");
    return format.format(DateTime.now());
  }

}
