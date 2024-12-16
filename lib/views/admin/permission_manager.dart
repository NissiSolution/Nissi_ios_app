import 'dart:convert';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '/Supports/checkpassword.dart';
import '/Supports/constants.dart';

import '../../Supports/classes.dart';
import '../../Supports/supports.dart';

class PermissionManager extends StatefulWidget {
  const PermissionManager({super.key});

  @override
  State<PermissionManager> createState() => _PermissionManagerState();
}

class _PermissionManagerState extends State<PermissionManager> {
  late String selectedStaff,
      selectedId,
      selectedType,
      selectedDate,
      selectedDepartment;
  Supports? supports;
  late List<String> staffNameList = [], staffIdList = [];
  final List<CheckedInfo> checkedInfoList = [];
  bool isActive = true;
  late List<StaffInfo> staffInfoList = [];
  late List<Departments> departmentsList = [];
  late List<String> departmentNameList = [];
  late List<StaffDepartments> staffDepartmentList = [];
  late List<PermissionGroup> permissionGroupList = [];
  late List<PermissionName> permissionNameList = [];
  late List<PermissionData> staffPermissionDataList = [];
  List<PermissionData> permissionDataList = [];
  bool isChecked = false;
  late int staffId = 0, count = 0;
  bool isPermissionDataTaken = false;
  late int type = 0;

  @override
  void initState() {
    declareItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.permissionManagement),
        foregroundColor: Colors.white,
        backgroundColor: Constants.company,
      ),
      backgroundColor: Constants.company,
      body: Container(
        padding: Constants.padding1,
        child: Container(
          alignment: Alignment.center,
          decoration: Constants.backgroundContent,
          padding: Constants.padding1,
          child: Column(
            children: [
              const SizedBox(
                width: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 80,
                      child: Text(
                        "Staff",
                        style: Constants.textStyle2(Constants.company),
                      )),
                  Text(
                    Constants.colan,
                    style: Constants.textStyle2(Constants.company),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: CustomDropdown<String>.search(
                      onChanged: (String? value) {
                        setState(() {
                          selectedStaff = value ?? "No Staff";
                          getStaffId(selectedStaff);
                        });
                      },
                      items: staffNameList,
                      hintText: "Select Staff",
                      initialItem: selectedStaff,
                      closedHeaderPadding: const EdgeInsets.all(12),
                      decoration: CustomDropdownDecoration(
                          headerStyle:
                              const TextStyle(color: Constants.company),
                          listItemStyle:
                              const TextStyle(color: Constants.company),
                          closedBorder: Border.all(color: Constants.company),
                          closedBorderRadius: BorderRadius.circular(10),
                          expandedBorder: Border.all(color: Constants.company),
                          expandedBorderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                      width: 90,
                      child: Text(
                        "Depatments",
                        style: Constants.textStyle2(Constants.company),
                      )),
                  Text(
                    Constants.colan,
                    style: Constants.textStyle2(Constants.company),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: CustomDropdown<String>.search(
                      onChanged: (String? value) {
                        setState(() {
                          selectedDepartment = value ?? "Empty";
                        });
                        setStaffSpinner(staffInfoList);
                      },
                      items: departmentNameList,
                      hintText: "Select Department",
                      initialItem: selectedDepartment,
                      closedHeaderPadding: const EdgeInsets.all(12),
                      decoration: CustomDropdownDecoration(
                          searchFieldDecoration: const SearchFieldDecoration(
                              textStyle: TextStyle(color: Constants.company),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants.company))),
                          headerStyle:
                              const TextStyle(color: Constants.company),
                          listItemStyle:
                              const TextStyle(color: Constants.company),
                          closedBorder: Border.all(color: Constants.company),
                          closedBorderRadius: BorderRadius.circular(10),
                          expandedBorder: Border.all(color: Constants.company),
                          expandedBorderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: selectedStaff != "Select"
                      ? Column(
                          children: [
                            Expanded(
                              child: FutureBuilder(
                                future: getPermissionGroup(),
                                builder: (context, index) {
                                  return ListView.builder(
                                    itemCount: permissionDataList.length,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Row(
                                          children: [
                                            Text(
                                              permissionDataList[index].tagName,
                                              style: Constants.textStyle2(
                                                  Constants.company),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Container(
                                          decoration: boxDecoration(),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  permissionDataList[index]
                                                      .tagName,
                                                  style: Constants.textStyle3(
                                                      Constants.company),
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                Constants.colan,
                                                style: Constants.textStyle3(
                                                    Constants.company),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Checkbox(
                                                  value:
                                                      permissionDataList[index]
                                                          .isChecked,
                                                  onChanged: (bool? newValue) {
                                                    setState(() {
                                                      permissionDataList[index]
                                                              .isChecked =
                                                          newValue!;
                                                      // isChecked = newValue;
                                                    });
                                                  })
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              //padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setPermission();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      backgroundColor: Constants.company),
                                  child: const Text(
                                    "UPDATE",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        )
                      : const Text("")),
              Constants.licenceButton
            ],
          ),
        ),
      ),
    );
  }

  void declareItem() {
    selectedStaff = "Select";
    staffNameList.add(selectedStaff);
    selectedDepartment = "All Departments";
    departmentNameList.add(selectedDepartment);
    //setListeners();
    supports = Supports(context);
    getStaff();
    getDepartment();
    getPermissionGroup();
    CheckPass(context);
  }

  void getStaff() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {Constants.requestType: Constants.getStaff};
    var response = await post(url, body: data);
    if (response.statusCode == 200) {
      var jsonArray = jsonDecode(response.body);
      staffInfoList.clear();
      for (int i = 0; i < jsonArray.length; i++) {
        var jsonObject = jsonArray[i];
        StaffInfo staffInfo = StaffInfo(
            jsonObject[Constants.staffId1],
            jsonObject[Constants.firstName],
            jsonObject[Constants.lastName],
            jsonObject[Constants.staffIdentifi]);
        staffInfoList.add(staffInfo);
      }
      setStaffSpinner(staffInfoList);
    } else {
      print("Errorr--");
    }
  }

  void setStaffSpinner(List<StaffInfo> staffInfoList) {
    staffNameList.clear();
    staffNameList.add('Select');
    if (selectedDepartment == departmentNameList[0]) {
      for (StaffInfo staffInfo in staffInfoList) {
        staffNameList.add(
            "${staffInfo.firstname} ${staffInfo.lastname} ${staffInfo.staff_identifi}");
      }
    } else {
      compareDepartment();
    }
    selectedStaff = staffNameList[0];
    setState(() {});
  }

  void compareDepartment() {
    int id = 0;
    String departmentName = selectedDepartment;
    for (Departments departments in departmentsList) {
      if (departments.name == departmentName) {
        id = departments.departmentid;

        break;
      }
    }
    List<StaffInfo> filteredData = getStaffInfoList(id);
    for (StaffInfo staffInfo in filteredData) {
      staffNameList.add(
          "${staffInfo.firstname} ${staffInfo.lastname} ${staffInfo.staff_identifi}");
    }
  }

  List<StaffInfo> getStaffInfoList(int id) {
    List<StaffInfo> staffInfoList = [];
    List<int> staffIdList = [];

    for (StaffDepartments staffDepartments in staffDepartmentList) {
      if (id == staffDepartments.departmentid) {
        staffIdList.add(staffDepartments.staffid);
      }
    }

    for (StaffInfo staffInfo in this.staffInfoList) {
      if (staffIdList.contains(staffInfo.staffid)) {
        staffInfoList.add(staffInfo);
      }
    }
    return staffInfoList;
  }

  void getDepartment() async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType: Constants.getAllDepartment
    };
    var response = await post(url, body: data);
    if (response.statusCode == 200) {
      staffDepartmentList.clear();
      departmentsList.clear();

      List<String> list1 = response.body.split(Constants.splitter2);
      var jsonArray1 = jsonDecode(list1[0]);
      for (int i = 0; i < jsonArray1.length; i++) {
        var jsonObject = jsonArray1[i];
        Departments departments = Departments(
            jsonObject[Constants.departmentID], jsonObject[Constants.name]);
        departmentsList.add(departments);
      }
      var jsonArray2 = jsonDecode(list1[1]);
      for (int i = 0; i < jsonArray2.length; i++) {
        var jsonObject = jsonArray2[i];
        StaffDepartments staffDepartments = StaffDepartments(
            jsonObject[Constants.staffId1], jsonObject[Constants.departmentID]);
        staffDepartmentList.add(staffDepartments);
      }
      setDepartmentSpinner(departmentsList);
      setStaffSpinner(staffInfoList);
    } else {
      print("Not Succeed");
    }
    setState(() {});
  }

  void setDepartmentSpinner(List<Departments> departmentList) {
    departmentNameList.clear();
    departmentNameList.add("All Departments");
    for (Departments departments in departmentList) {
      departmentNameList.add(departments.name);
    }
    selectedDepartment = departmentNameList[0];
    setState(() {});
  }

  Future<void> getPermissionGroup() async {
    if (!isPermissionDataTaken) {
      var url = Uri.parse(Constants.databaseLink);
      Map<String, String> data = {
        Constants.requestType: Constants.getPermissionGroup
      };
      var response = await post(url, body: data);

      if (response.statusCode == 200) {
        List<String> list1 = response.body.split(Constants.splitter2);
        var jsonArray1 = jsonDecode(list1[0]);
        var jsonArray2 = jsonDecode(list1[1]);

        permissionGroupList.clear();

        for (int i = 0; i < jsonArray1.length; i++) {
          var jsonObject = jsonArray1[i];
          PermissionGroup permissionGroup = PermissionGroup(
              jsonObject[Constants.permissionID], jsonObject[Constants.name]);
          permissionGroupList.add(permissionGroup);
        }

        permissionNameList.clear();

        for (int i = 0; i < jsonArray2.length; i++) {
          var jsonObject = jsonArray2[i];
          PermissionName permissionName = PermissionName(
              jsonObject[Constants.id],
              jsonObject[Constants.permissionID],
              jsonObject[Constants.name]);
          permissionNameList.add(permissionName);
        }
        setPermissionDataList();
        setState(() {});
      } else {
        print("GetGroupPermission Not Work");
      }
      isPermissionDataTaken = true;
    }
  }

  void setPermissionDataList() {
    permissionDataList.clear();
    for (PermissionGroup permissionGroup in permissionGroupList) {
      permissionDataList.add(PermissionData(0, permissionGroup.name));
      for (PermissionName permissionName in permissionNameList) {
        if (permissionGroup.permission_id == permissionName.permission_id) {
          permissionDataList
              .add(PermissionData(permissionName.id, permissionName.name));
        }
      }
    }
  }

  void getStaffId(String staffName) {
    for (StaffInfo staffInfo in staffInfoList) {
      String staffN =
          "${staffInfo.firstname} ${staffInfo.lastname} ${staffInfo.staff_identifi}";
      if (staffN == staffName) {
        staffId = staffInfo.staffid;
        getPermission(staffId);
      }
    }
  }

  void getPermission(int staffID) async {
    var url = Uri.parse(Constants.databaseLink);
    Map<String, String> data = {
      Constants.requestType: Constants.getPermission,
      Constants.staffId: staffID.toString()
    };
    var response = await post(url, body: data);

    if (response.statusCode == 200) {
      staffPermissionDataList.clear();
      List<PermissionStaff> permissionStaffList = [];
      for (PermissionData permissionData in permissionDataList) {
        permissionData.isChecked = false;
      }
      if (response.body.isNotEmpty) {
        var jsonArray = jsonDecode(response.body);
        for (int i = 0; i < jsonArray.length; i++) {
          var jsonObject = jsonArray[i];
          PermissionStaff permissionStaff = PermissionStaff(
              jsonObject[Constants.id],
              jsonObject[Constants.permissionID],
              jsonObject[Constants.staffId1]);
          permissionStaffList.add(permissionStaff);
        }
        for (PermissionData permissionData in permissionDataList) {
          if (permissionData.id != 0) {
            for (PermissionStaff permissionStaff in permissionStaffList) {
              if (permissionStaff.permission_id == permissionData.id) {
                permissionData.isChecked = true;
                break;
              } else {
                permissionData.isChecked = false;
              }
            }
          }
          staffPermissionDataList.add(permissionData);
        }
      } else {
        staffPermissionDataList.addAll(permissionDataList);
      }
    } else {
      print("Data Not Found");
    }
    setState(() {});
  }

  void setPermission() async {
    StringBuffer builder = StringBuffer();
    count = 0;
    for (PermissionData permissionData in staffPermissionDataList) {
      if (permissionData.isChecked) {
        if (builder.isEmpty) {
          builder.write(permissionData.id);
        } else {
          builder.write(",${permissionData.id}");
        }
        count++;
      }
    }

    var url = Uri.parse(Constants.databaseLink);

    Map<String, String> data = {
      Constants.requestType: Constants.setPermission,
      Constants.staffId: staffId.toString(),
      Constants.count: count.toString(),
      Constants.permission: builder.toString()
    };
    var response = await post(url, body: data);
    if (response.statusCode == 200) {
      supports?.createSnackBar(Constants.dataSentSuccessfully);
    } else {
      supports?.createSnackBar(Constants.errorMessage);
    }
  }

  BoxDecoration boxDecoration() {
    if (type == 0) {
      type = 1;
      BoxDecoration decoration = const BoxDecoration(
          color: Color(0xFFE2E2E2),
          borderRadius: BorderRadius.all(Radius.circular(5)));
      return decoration;
    } else {
      type = 0;
      BoxDecoration decoration = const BoxDecoration(
          color: Color(0xFFEBF7FF),
          borderRadius: BorderRadius.all(Radius.circular(5)));
      return decoration;
    }
  }
}
