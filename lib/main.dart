import 'package:flutter/material.dart';
import '/views/employee/comp_off_holiday_activity.dart';
import '/views/home_activity.dart';
import '/views/hr_activity.dart';
import '/views/login_activity.dart';
import '/views/main_activity.dart';

import 'Supports/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.signature),
        useMaterial3: true,
      ),
      home: const MainPage(),
      routes: {
        '/login'          : (context) => const LoginPage(),
        '/home'           : (context) => const HomePage(),
        '/hr'             : (context) => const HrPage(),
        '/compOffHoliday' : (context) => const CompOffHolidayPage(),
      },
    );
  }
}

