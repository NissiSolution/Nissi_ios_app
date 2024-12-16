import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class Constants {
  static const Color company = Color(0xFF016DB5);
  static const Color signature = Color(0xFF03A9F4);
  static const Color lightBlue = Color(0xFFC6E9FF);
  static const Color lighterGreen = Color(0xFFDEFFDF);
  static const Color lightGreen = Color(0xFFA4E6A6);
  static const Color green = Color(0xFF4CAF50);
  static const Color lightRed = Color(0xFFFFC7C3);
  static const Color redText = Color(0xFFFF7E74);
  static const Color red = Color(0xFFFF0000);
  static const Color lighterRed = Color(0xFFFFF7F7);

  static const String licence = "NISSI ENGINEERING SOLUTION Pvt. Ltd.";
  static const String updateViewed = "update_viewed";
  static const String halfDay = "Half Day";
  static const String on = "On";
  static const String checkPassword = "check_password";
  static const String loginPage = "Login Page";
  static const String missedDate = "Missed Date";
  static const String getCurrentLeaveData = "get_current_leave_data";
  static const String startTime = "Start Time";
  static const String endTime = "End Time";
  static const String cancel = "cancel";
  static const String cancelC = "CANCEL";
  static const String approveC = "APPROVE";
  static const String rejectC = "REJECT";
  static const String retryC = "RETRY";
  static const String logOut = "Log Out";
  static const String approveOrRejectLeave = "approve_or_reject_leave";
  static const String approveOrReject = "approve_or_reject";
  static const String checkInOut = "check_in_out";
  static const String typeCheck = "type_check";
  static const String routePointId = "route_point_id";
  static const String workplaceId = "workplace_id";
  static const String longitude = "longitude";
  static const String latitude = "latitude";
  static const String login = "LOGIN";
  static const String enterEmail = "Enter your email here";
  static const String enterPassword = "Enter your password here";
  static const String databaseLink = "https://nissiconnect.com/mobile_application/check_in_out_for_app.php";
  // static Uri client = Uri.https("nissiconnect.com", "mobile_application/check_in_out_for_app.php");
  static Uri client = Uri.https("nissiconnect.com", "media/nanthini-m/check_in_out_for_app.php");
  static const String guestHouseLink = "https://nissiconnect.com/mobile_application/guest_house_location.php";
  static const String failure = "failure";
  static const String email = "email";
  static const String password = "password";
  static const String requestType = "request_type";
  static const String getAllDepartment = "get_all_departments";
  static const String departmentID = "departmentid";
  static const String getPermissionGroup = "get_permission_group";
  static const String getPermission = "get_permission";
  static const String permissionID = "permission_id";
  static const String name = "name";
  static const String theInformation = "the_information";
  static const String isAdmin = "is_admin";
  static const String getNotification = "get_notification";
  static const String admin = "admin";
  static const String checkIsTheRequestExist = "check_is_the_request_exist";
  static const String requestTypeC = "Request Type";
  static const String auth = "auth";
  static const String empty = " ";
  static const String error = "error";
  static const String emailError = "Email Id doesn't exists";
  static const String passwordError = "Wrong Password";
  static const String staffId = "staff_id";
  static const String staffId1 = "staffid";
  static const String firstName = "firstname";
  static const String lastName = "lastname";
  static const String staffIdentifi = "staff_identifi";
  static const String fetchData = "fetch_data";
  static const String loginSuccess = "Logged in Successfully";
  static const String errorMessage = "Something went wrong";
  static const String required = "Required";
  static const String nissi = "NISSI";
  static const String attendance = "Attendance";
  static const String guestHouseLocation = "Guest House Location";
  static const String humanResources = "Human Resources";
  static const String support = "Support";
  static const String sos = "SOS";
  static const String leaveRequest = "Leave Request";
  static const String approveLeave = "Approve Leave";
  static const String missedPunchRequest = "Missed Punch Request";
  static const String approveMissedPunch = "Approve Missed Punch";
  static const String compOffHolidayRequest = "Comp-Off & Holiday Request";
  static const String permissionManager = "Permission Manager";
  static const String approveCompOffHoliday = "Approve Comp-Off Holiday";
  static const String nightShiftRequest = "Night Shift Request";
  static const String permissionManagement = "Permission Management";
  static const String setPermission = 'set_permission';
  static const String permission = "permission";
  static const String count = "count";
  static const String approveNightShift = "Approve Night Shift";
  static const String punchedLocation = "Punched Location";
  static const String punchedHistory = "Punched History";
  static const String leaveInformation = "Leave Information";
  static const String period = "Period";
  static const String duration = "Duration";
  static const String leaveType = "Leave Type";
  static const String availableDays = "Available Days";
  static const String appliedDays = "Applied Days";
  static const String status = "Status";
  static const String colan = ":";
  static const String applyForLeave = "APPLY FOR LEAVE";
  static const String getLeaveRequestData = "get_leave_request_data";
  static const String month = "month";
  static const String year = "year";
  static const String splitter1 = "-@-";
  static const String splitter2 = "@-@";
  static const String splitter3 = "#-@-#";
  static const String splitter4 = "#@-@#";
  static const String getLeaveType = "get_leave_type";
  static const String select = "Select";
  static const String getAllLeaveBalance = "get_all_leave_balance";
  static const String date = "date";
  static const String dateC = "Date";
  static const String key0 = "0";
  static const String key1 = "1";
  static const String key2 = "2";
  static const String key3 = "3";
  static const String key10 = "10";
  static const String key100 = "100";
  static const String key101 = "101";
  static const String key102 = "102";
  static const String key103 = "103";
  static const String key110 = "110";
  static const String data = "data";
  static const String purpose = "purpose";
  static const String requestDate = "Request Date";
  static const String requestedOn = "Requested On";
  static const String reasonC = "Reason";
  static const String purposeC = "Purpose";
  static const String reason = "reason";
  static const String rejectedReason = "Rejected Reason";
  static const String type = "type";
  static const String typeC = "Type";
  static const String getAllDepartmentInfo = "get_all_department_info";
  static const String approver = "Approver";
  static const String position = "Position";
  static const String yourBalanceLeaveDays = "Your Balance Leave Days";
  static const String getMissedPunchData = "get_missed_punch_data";
  static const String getCompOffHoliday = "get_comp_off_holiday";
  static const String getNightShift = "get_night_shift";
  static const String workedHour = "Worked Hour";
  static const String workedPeriod = "Worked Period";
  static const String missedPunchInformation = "Missed Punch Information";
  static const String addNewRequest = "ADD NEW REQUEST";
  static const String compOffC = "COMP-OFF";
  static const String compOff = "Comp-Off";
  static const String localHoliday = "Local Holiday";
  static const String holidayC = "HOLIDAY";
  static const String compOffLocalHoliday = "Comp-Off & Local Holiday";
  static const String informationC = "INFORMATION";
  static const String getGuestHouseDetails = "get_guest_house_details";
  static const String getLeaveApprovalRequest = "get_leave_approval_request";
  static const String getMissedPunchApprovalRequest = "get_missed_punch_approval_request";
  static const String getCompOffHolidayApprovalRequest = "get_comp_off_holiday_approval_request";
  static const String getNightShiftApprovalRequest = "get_night_shift_approval_request";
  static const String staffName = "Staff Name";
  static const String departmentC = "Department";
  static const String nissiConnect = "https://nissiconnect.com/admin";
  static const String all = "All";
  static const String punchedIn = "Punched In";
  static const String punchedOut = "Punched Out";
  static const String getDirectEmployee = "get_direct_employee";
  static const String punchedInformation = "Punched Information";
  static const String pickDateC = "PICK DATE";
  static const String filterC = "FILTER";
  static const String getDirectEmployeeInfo = "get_direct_employee_info";
  static const String getStaff = 'get_all_staffs';
  static const String getDirectEmployeeLocation = "get_direct_employee_location";
  static const String deleteData = "delete_data";
  static const String id = "id";
  static const String success = "success";
  static const String punchedInAt = "Punched-in at";
  static const String punchedOutAt = "Punched-out at";
  static const String punchInOut = "Punch In/Out";
  static const String nightShift = "Night Shift";
  static const String timeInC = "TIME IN";
  static const String timeOutC = "TIME OUT";
  static const String sendRequestC = "SEND REQUEST";
  static const String exists = "exists";
  static const String getMyDetailsInfo = "get_my_details_info";
  static const String currentDateCheck = "current_date_check";
  static const String getCheckedData = "get_checked_data";
  static const String holidayOrCompOff = "holiday_or_comp_off";
  static const String fromDate = "from_date";
  static const String toDate = "to_date";
  static const String sendLeaveRequest = "send_leave_request";
  static const String dateCreated = "date_created";
  static const String numberOfDays = "number_of_days";
  static const String numberOfLeavingDay = "number_of_leaving_day";
  static const String typeOfLeaveText = "type_of_leave_text";
  static const String symbol = "symbol";
  static const String timestamp = "timestamp";
  static const String workHours = "work_hours";
  static const String fromTime = "from_time";
  static const String toTime = "to_time";
  static const String dataSentSuccessfully = "Request sent successfully";
  static const String totalLeaveDaysC = "Total Leave Days";
  static const String remainingLeaveDaysC = "Remaining Leave Days";
  static const String numberOfDaysC = "Number of Days";
  static const String fromDateC = "From Date";
  static const String toDateC = "To Date";
  static const String sendLOPLeaveRequest = "Send LOP leave request?";
  static const String insufficientLeave = "Insufficient leave balance at the selected leave type";
  static const String sendC = "SEND";
  static const String approverId = "approver_id";
  static const String currentTimestamp = "current_timestamp";
  static const String getCheckInOutData = "get_check_in_out_data";
  static const String unableMessage = "Unable to fetch information. Check your internet connection and try again.";
  static const String ok = "OK";
  static const String selectAll = "Select All";
  static const String deSelectAll = "De-select All";
  static const String massApproveOrReject = "mass_approve_or_reject";
  static const String massApproveOrRejectLeave = "mass_approve_or_reject_leave";

  static const List<String> monthList = ["Select Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  static const List<String> typeList = ["All", "On-Process", "Approved", "Rejected"];

  static const String lLogo = "assets/images/logo.png";
  static const String lApprove = "assets/images/approve.jpg";
  static const String lChecked = "assets/images/checked.png";
  static const String lCompOff = "assets/images/comp_off.jpg";
  static const String lDimSos = "assets/images/dim_sos.png";
  static const String lDimSupport = "assets/images/dim_support.png";
  static const String lGuestHouse = "assets/images/guest_house.jpg";
  static const String lHr = "assets/images/hr.jpeg";
  static const String lIcon = "assets/images/icon.jpg";
  static const String lLeave = "assets/images/leave.jpeg";
  static const String lMissedPunch = "assets/images/missed_punch.jpg";
  static const String lSos = "assets/images/sos.png";
  static const String lSupport = "assets/images/support.png";
  static const String lLocation = "assets/images/location.jpeg";
  static const String lNightShift = "assets/images/night_shift.jpeg";
  static const String lPermission = "assets/images/permission.png";

  static const BoxDecoration backgroundContent =  BoxDecoration(
    shape: BoxShape.rectangle,
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  );

  static BoxDecoration backgroundR(Color borderColor, Color? backgroundColor) {
    return BoxDecoration(
      color: backgroundColor,
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      border: Border(
        top: BorderSide(color: borderColor, width: 2.0),
        right: BorderSide(color: borderColor, width: 2.0),
        bottom: BorderSide(color: borderColor, width: 2.0),
        left: BorderSide(color: borderColor, width: 2.0),
      ),
    );
  }

  static BoxDecoration checkInStatusDecoration(int status) {
    if (status == 1) {
      return backgroundR(lighterGreen, lighterGreen);
    } else {
      return backgroundR(lighterRed, lighterRed);
    }
  }

  static const BoxDecoration backgroundRecycler = BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      border: Border(
        top: BorderSide(color: company, width: 2.0),
        right: BorderSide(color: company, width: 2.0),
        bottom: BorderSide(color: company, width: 2.0),
        left: BorderSide(color: company, width: 2.0),
      ),
  );

  static const BoxDecoration backgroundRecyclerApproved = BoxDecoration(
    color: lighterGreen,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    border: Border(
      top: BorderSide(color: company, width: 2.0),
      right: BorderSide(color: company, width: 2.0),
      bottom: BorderSide(color: company, width: 2.0),
      left: BorderSide(color: company, width: 2.0),
    ),
  );

  static const BoxDecoration backgroundRecyclerRejected = BoxDecoration(
    color: lightRed,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    border: Border(
      top: BorderSide(color: company, width: 2.0),
      right: BorderSide(color: company, width: 2.0),
      bottom: BorderSide(color: company, width: 2.0),
      left: BorderSide(color: company, width: 2.0),
    ),
  );

  static const BoxDecoration backgroundChecked = BoxDecoration(
    color: lightBlue,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    border: Border(
      top: BorderSide(color: company, width: 2.0),
      right: BorderSide(color: company, width: 2.0),
      bottom: BorderSide(color: company, width: 2.0),
      left: BorderSide(color: company, width: 2.0),
    ),
  );

  static BoxDecoration statusDecoration(int status) {
    if (status == 0) {
      return backgroundRecycler;
    } else if (status == 1) {
      return backgroundRecyclerApproved;
    } else {
      return backgroundRecyclerRejected;
    }
  }

  static BoxDecoration checkedDecoration(bool isChecked) {
    if (isChecked) {
      return backgroundChecked;
    } else {
      return backgroundRecycler;
    }
  }

  static const BoxDecoration ch =  BoxDecoration(
    shape: BoxShape.rectangle,
    color: Colors.green,
  );

  static TextStyle textStyle1(Color color) {
    return TextStyle(
      color: color,
    );
  }

  static TextStyle textStyle2(Color color) {
    return TextStyle(
        color: color,
        fontWeight: FontWeight.bold
    );
  }

  static TextStyle textStyle3(Color color) {
    return TextStyle(
        color: color,
        fontStyle: FontStyle.italic
    );
  }

  static TextStyle textStyle6(Color color, double fontSize) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
  }

    static SizedBox imageColumn(String imageLocation, String text) {
      return SizedBox(
        width: 140,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(imageLocation, width: 140, height: 140, fit: BoxFit.fill),),
            Text(text, style: textStyle1(company), textAlign: TextAlign.center,),
          ],
        ),
      );
    }

    static SizedBox imageColumn2(String imageLocation, String text) {
      return SizedBox(
        width: 140,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(imageLocation, width: 140, height: 140, fit: BoxFit.fill),),
            Text(text, style: textStyle1(company), textAlign: TextAlign.center,),
          ],
        ),
      );
    }

  static SizedBox imageColumn3(String imageLocation, String text, int count) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                decoration: BoxDecoration(border: Border.all(width: 4.0, color: const Color(0xFFC2BDBD)), borderRadius: BorderRadius.circular(20.0)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(imageLocation, width: 140, height: 140, fit: BoxFit.fill),),
              ),
              if (count != 0)
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(color: signature, borderRadius: BorderRadius.circular(4.0), border: Border.all(color: company)),
                  child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
            ],
          ),
          Text(text, style: textStyle1(company), textAlign: TextAlign.center,),
        ],
      ),
    );
  }

  static SizedBox imageColumn4(String imageLocation, String text, int count) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(imageLocation, width: 140, height: 140, fit: BoxFit.fill),),
              if (count != 0)
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(color: signature, borderRadius: BorderRadius.circular(4.0), border: Border.all(color: company)),
                  child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
            ],
          ),
          Text(text, style: textStyle1(company), textAlign: TextAlign.center,),
        ],
      ),
    );
  }

    static AppBar appBar(String text) {
      return AppBar(
        title: Text(text),
        foregroundColor: Colors.white,
        backgroundColor: company,
      );
    }

    static BoxDecoration backgroundDecoration = const BoxDecoration(color: company);

    static BoxDecoration backgroundDecoration2 = const BoxDecoration(
      color: signature,
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    );

    static const TextStyle buttonTextStyle = TextStyle(fontWeight: FontWeight.bold);

    static EdgeInsets padding1 = const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0);
    static EdgeInsets padding2 = const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0);
    static EdgeInsets padding3 = const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
    static EdgeInsets padding4 = const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0);
    static EdgeInsets padding5 = const EdgeInsets.fromLTRB(15.0, 0, 15.0, 15.0);
    static EdgeInsets padding6 = const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0);

    static TextButton licenceButton = TextButton(onPressed: () async {
      var _url = Uri.parse(nissiConnect);
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }, child: const Text(licence, style: TextStyle(color: company, fontStyle: FontStyle.italic)),);

    static List<String> yearList() {
      final theDate = DateTime.now();
      int theYear = theDate.year;
      List<String> yearL = ["Select Year"];
      for (int i = theYear; i > 2022; i--) {
        yearL.add(i.toString());
      }
      return yearL;
    }

    static ButtonStyle buttonStyle(Color color) {
      return TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          minimumSize: const Size(150.0, 40.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)));
    }

    static ButtonStyle buttonStyle2(Color color) {
      return TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
          //minimumSize: const Size(150.0, 40.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
    }

    static ButtonStyle buttonStyle3() {
      return TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
    }

    static ButtonStyle buttonStyle4(Color color) {
      return TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          minimumSize: const Size(120.0, 40.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)));
    }

    static InputDecoration inputDecoration1(String reason, Icon? prefixIcon,
        Color? prefixIconColor, Color enableColor, Color labelColor, Color focusColor) {
      return InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        labelText: reason,
        labelStyle: textStyle1(labelColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide:  BorderSide(color: enableColor, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide:  BorderSide(color: focusColor, width: 2.0),
        ),
      );
    }

    static Future<String> futureDelay = Future<String>.delayed(
      const Duration(seconds: 5),
          () => 'Data Loaded',
    );
}
