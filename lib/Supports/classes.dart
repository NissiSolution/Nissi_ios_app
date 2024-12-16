class LeaveData {
  late String startDate, endDate, type, theData;
  late int status, duration, id;
  late int timestamp;

  LeaveData(this.startDate, this.endDate, this.type, this.status, this.duration,
      this.theData, this.id, this.timestamp);
}

class LeaveL {
  late String typeName, slug, symbol;

  LeaveL(this.typeName, this.slug, this.symbol);
}

class RemainL {
  late String leaveType, totalDays, remainingDays;

  RemainL(this.leaveType, this.totalDays, this.remainingDays);
}

class Department {
  late int staffId, departmentId;
  late String position, manageName;

  Department(this.staffId, this.departmentId, this.position, this.manageName);
}

class Approval {
  late int staffId, status, timestamp;

  Approval(this.staffId, this.status, this.timestamp);
}

class MissedPunch {
  late String date, workedHour;
  late int status;
  late String theData;
  late int id, timestamp;

  MissedPunch(this.date, this.workedHour, this.status, this.theData, this.id,
      this.timestamp);
}

class CompOffHoliday {
  late String date, requestType;
  late int status;
  late String theData;
  late int id, timestamp;

  CompOffHoliday(this.date, this.requestType, this.status, this.theData,
      this.id, this.timestamp);
}

class SingleGuestHouse {
  late int position;
  late String name, mapUrl, imageUrl;

  SingleGuestHouse(this.position, this.name, this.mapUrl, this.imageUrl);
}

class GuestHouse {
  late String nameL, nameR, imageL, imageR, linkL, linkR;
  late int count;

  GuestHouse(this.nameL, this.nameR, this.imageL, this.imageR, this.linkL,
      this.linkR, this.count);
}

class AdminLeave {
  late String staffName, leaveType, startDate, endDate;
  late int duration, status, id;
  late String theData;
  late int timestamp;
  late bool isChecked;

  AdminLeave(this.staffName, this.leaveType, this.startDate, this.endDate,
      this.duration, this.status, this.id, this.theData, this.timestamp,
      this.isChecked);
}

class AdminMissedPunch {
  late String date, staffName, period, theData;
  late int status, timestamp;
  late bool isChecked;

  AdminMissedPunch(this.date, this.staffName, this.period, this.theData,
      this.status, this.timestamp, this.isChecked);
}

class AdminCompOffHoliday {
  late String date, staffName, requestType, theData;
  late int status, timestamp;
  late bool isChecked;

  AdminCompOffHoliday(this.date, this.staffName, this.requestType, this.theData,
      this.status, this.timestamp, this.isChecked);
}

class CheckedInfo {
  late String staffName;
  late double longitude, latitude;
  late String date;
  late int type;
  late String data;

  CheckedInfo(this.staffName, this.longitude, this.latitude, this.date,
      this.type, this.data);
}

class CheckedData {
  late DateTime dateTime;
  late int status;

  CheckedData(this.dateTime, this.status);
}

class StaffInfo{
  late int staffid;
  late String firstname, lastname, staff_identifi;

  StaffInfo(this.staffid, this.firstname, this.lastname, this.staff_identifi);
}

class Departments{
  late int departmentid;
  late String name;

  Departments(this.departmentid, this.name);
}

class StaffDepartments{
  late int staffid, departmentid;

  StaffDepartments(this.staffid, this.departmentid,);
}

class PermissionGroup{
  late int permission_id;
  late String name;
  PermissionGroup(this.permission_id, this.name);
}

class PermissionName{
  late int id, permission_id;
  late String name;


  PermissionName(this.id, this.permission_id, this.name);
}

class PermissionData{
  late int id;
  late String tagName;
  late bool isChecked;

  PermissionData(this.id, this.tagName,{this.isChecked = false});
}

class PermissionStaff{
  late int id, permission_id, staffid;

  PermissionStaff(this.id, this.permission_id, this.staffid);
}

enum PunchSelectionCharacter {
  all, punchedIn, punchedOut
}

enum AttendanceSelectionCharacter {
  punchInOut, nightShift, compOff, localHoliday
}