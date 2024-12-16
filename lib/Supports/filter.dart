import 'classes.dart';

class Filter {
  List<MissedPunch> filterMissedPunch(List<MissedPunch> list, int type) {
    List<MissedPunch> missedPunchList = [];
    switch (type) {
      case 0:
        for (int i = 0; i < list.length; i ++) {
          MissedPunch missedPunch = list[i];
          if (missedPunch.status == 0) {
            missedPunchList.add(missedPunch);
          }
        }
        for (int i = 0; i < list.length; i ++) {
          MissedPunch missedPunch = list[i];
          if (missedPunch.status != 0) {
            missedPunchList.add(missedPunch);
          }
        }
      case 1:
        for (int i = 0; i < list.length; i ++) {
          MissedPunch missedPunch = list[i];
          if (missedPunch.status == 0) {
            missedPunchList.add(missedPunch);
          }
        }
      case 2:
        for (int i = 0; i < list.length; i ++) {
          MissedPunch missedPunch = list[i];
          if (missedPunch.status == 1) {
            missedPunchList.add(missedPunch);
          }
        }
      case 3:
        for (int i = 0; i < list.length; i ++) {
          MissedPunch missedPunch = list[i];
          if (missedPunch.status == 2) {
            missedPunchList.add(missedPunch);
          }
        }
    }
    return missedPunchList;
  }

  List<AdminMissedPunch> filterAdminMissedPunch(List<AdminMissedPunch> list, int type) {
    List<AdminMissedPunch> adminMissedPunchList = [];
    switch (type) {
      case 0:
        for (int i = 0; i < list.length; i ++) {
          AdminMissedPunch adminMissedPunch = list[i];
          if (adminMissedPunch.status == 0) {
            adminMissedPunchList.add(adminMissedPunch);
          }
        }
        for (int i = 0; i < list.length; i ++) {
          AdminMissedPunch adminMissedPunch = list[i];
          if (adminMissedPunch.status != 0) {
            adminMissedPunchList.add(adminMissedPunch);
          }
        }
        break;
      case 1:
        for (int i = 0; i < list.length; i ++) {
          AdminMissedPunch adminMissedPunch = list[i];
          if (adminMissedPunch.status == 0) {
            adminMissedPunchList.add(adminMissedPunch);
          }
        }
        break;
      case 2:
        for (int i = 0; i < list.length; i ++) {
          AdminMissedPunch adminMissedPunch = list[i];
          if (adminMissedPunch.status == 1) {
            adminMissedPunchList.add(adminMissedPunch);
          }
        }
        break;
      case 3:
        for (int i = 0; i < list.length; i ++) {
          AdminMissedPunch adminMissedPunch = list[i];
          if (adminMissedPunch.status == 2) {
            adminMissedPunchList.add(adminMissedPunch);
          }
        }
        break;
    }
    return adminMissedPunchList;
  }

  List<LeaveData> filterLeaveData(List<LeaveData> list, int type) {
    List<LeaveData> leaveDataList = [];
    switch (type) {
      case 0:
        for (int i = 0; i < list.length; i ++) {
          LeaveData leaveData = list[i];
          if (leaveData.status == 0) {
            leaveDataList.add(leaveData);
          }
        }
        for (int i = 0; i < list.length; i ++) {
          LeaveData leaveData = list[i];
          if (leaveData.status != 0) {
            leaveDataList.add(leaveData);
          }
        }
        break;
      case 1:
        for (int i = 0; i < list.length; i ++) {
          LeaveData leaveData = list[i];
          if (leaveData.status == 0) {
            leaveDataList.add(leaveData);
          }
        }
        break;
      case 2:
        for (int i = 0; i < list.length; i ++) {
          LeaveData leaveData = list[i];
          if (leaveData.status == 1) {
            leaveDataList.add(leaveData);
          }
        }
        break;
      case 3:
        for (int i = 0; i < list.length; i ++) {
          LeaveData leaveData = list[i];
          if (leaveData.status == 2) {
            leaveDataList.add(leaveData);
          }
        }
        break;
    }
    return leaveDataList;
  }

  List<AdminLeave> filterAdminLeaveData(List<AdminLeave> list, int type) {
    List<AdminLeave> adminLeaveList = [];
    switch (type) {
      case 0:
        for (int i = 0; i < list.length; i ++) {
          AdminLeave adminLeave = list[i];
          if (adminLeave.status == 0) {
            adminLeaveList.add(adminLeave);
          }
        }
        for (int i = 0; i < list.length; i ++) {
          AdminLeave adminLeave = list[i];
          if (adminLeave.status != 0) {
            adminLeaveList.add(adminLeave);
          }
        }
        break;
      case 1:
        for (int i = 0; i < list.length; i ++) {
          AdminLeave adminLeave = list[i];
          if (adminLeave.status == 0) {
            adminLeaveList.add(adminLeave);
          }
        }
        break;
      case 2:
        for (int i = 0; i < list.length; i ++) {
          AdminLeave adminLeave = list[i];
          if (adminLeave.status == 1) {
            adminLeaveList.add(adminLeave);
          }
        }
        break;
      case 3:
        for (int i = 0; i < list.length; i ++) {
          AdminLeave adminLeave = list[i];
          if (adminLeave.status == 2) {
            adminLeaveList.add(adminLeave);
          }
        }
        break;
    }
    return adminLeaveList;
  }

  List<CompOffHoliday> filterCompOffHoliday(List<CompOffHoliday> list, int type) {
    List<CompOffHoliday> compOffHolidayList = [];
    switch (type) {
      case 0:
        for (int i = 0; i < list.length; i ++) {
          CompOffHoliday compOffHoliday = list[i];
          if (compOffHoliday.status == 0) {
            compOffHolidayList.add(compOffHoliday);
          }
        }
        for (int i = 0; i < list.length; i ++) {
          CompOffHoliday compOffHoliday = list[i];
          if (compOffHoliday.status != 0) {
            compOffHolidayList.add(compOffHoliday);
          }
        }
        break;
      case 1:
        for (int i = 0; i < list.length; i ++) {
          CompOffHoliday compOffHoliday = list[i];
          if (compOffHoliday.status == 0) {
            compOffHolidayList.add(compOffHoliday);
          }
        }
        break;
      case 2:
        for (int i = 0; i < list.length; i ++) {
          CompOffHoliday compOffHoliday = list[i];
          if (compOffHoliday.status == 1) {
            compOffHolidayList.add(compOffHoliday);
          }
        }
        break;
      case 3:
        for (int i = 0; i < list.length; i ++) {
          CompOffHoliday compOffHoliday = list[i];
          if (compOffHoliday.status == 2) {
            compOffHolidayList.add(compOffHoliday);
          }
        }
        break;
    }
    return compOffHolidayList;
  }

  List<AdminCompOffHoliday> filterAdminCompOffHoliday(List<AdminCompOffHoliday> list, int type) {
    List<AdminCompOffHoliday> adminCompOffHolidayList = [];
    switch (type) {
      case 0:
        for (int i = 0; i < list.length; i ++) {
          AdminCompOffHoliday adminCompOffHoliday = list[i];
          if (adminCompOffHoliday.status == 0) {
            adminCompOffHolidayList.add(adminCompOffHoliday);
          }
        }
        for (int i = 0; i < list.length; i ++) {
          AdminCompOffHoliday adminCompOffHoliday = list[i];
          if (adminCompOffHoliday.status != 0) {
            adminCompOffHolidayList.add(adminCompOffHoliday);
          }
        }
        break;
      case 1:
        for (int i = 0; i < list.length; i ++) {
          AdminCompOffHoliday adminCompOffHoliday = list[i];
          if (adminCompOffHoliday.status == 0) {
            adminCompOffHolidayList.add(adminCompOffHoliday);
          }
        }
        break;
      case 2:
        for (int i = 0; i < list.length; i ++) {
          AdminCompOffHoliday adminCompOffHoliday = list[i];
          if (adminCompOffHoliday.status == 1) {
            adminCompOffHolidayList.add(adminCompOffHoliday);
          }
        }
        break;
      case 3:
        for (int i = 0; i < list.length; i ++) {
          AdminCompOffHoliday adminCompOffHoliday = list[i];
          if (adminCompOffHoliday.status == 2) {
            adminCompOffHolidayList.add(adminCompOffHoliday);
          }
        }
        break;
    }
    return adminCompOffHolidayList;
  }
}