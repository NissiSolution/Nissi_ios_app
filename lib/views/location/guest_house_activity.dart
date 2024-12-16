import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../Supports/checkpassword.dart';
import '../../Supports/classes.dart';
import '../../Supports/constants.dart';
import '../../Supports/preferences_manager.dart';
import '../../Supports/supports.dart';

class GuestHousePage extends StatefulWidget {
  const GuestHousePage({super.key});

  @override
  State<GuestHousePage> createState() => _GuestHousePageState();
}

class _GuestHousePageState extends State<GuestHousePage> {

  late bool isLoading = true, canLoad = true;
  late PreferencesManager preferencesManager;
  late Supports supports;
  late String? staffId;
  late List<SingleGuestHouse> singleGuestHouseList = [];
  late List<GuestHouse> guestHouseList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    declareItem();
    CheckPass(context);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double contentWidth = width - 60.0;
    double textWidth1 = contentWidth - 150.0;
    double textWidth2 = contentWidth - 230.0 + 30;

    return Scaffold(
      appBar: Constants.appBar(Constants.guestHouseLocation),
      backgroundColor: Constants.company,
      body: Container(
        alignment: Alignment.center,
        padding: Constants.padding1,
        child: Container(
          alignment: Alignment.center,
          decoration: Constants.backgroundContent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (isLoading)
                Expanded(child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (canLoad)
                        Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Container(
                                        padding: Constants.padding1,
                                        child: const CircularProgressIndicator(color: Constants.company, strokeWidth: 4.0,)
                                    ),
                                  ),
                                ]
                            )
                        ),
                      if (!canLoad)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: Constants.backgroundRecycler,
                                      padding: Constants.padding1,
                                      width: 340.0,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(Constants.unableMessage, style: Constants.textStyle3(Constants.company),),
                                          const SizedBox(height: 10.0,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                  style: Constants.buttonStyle4(Constants.red),
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(Constants.cancelC)
                                              ),
                                              const SizedBox(width: 20.0,),
                                              TextButton(
                                                  style: Constants.buttonStyle4(Constants.company),
                                                  onPressed: (){
                                                    setState(() {
                                                      canLoad = true;
                                                      fDelay();
                                                      getGuestHouse();
                                                    });
                                                  },
                                                  child: const Text(Constants.retryC)
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                )
                )
              else
                Expanded(child: Container(
                  padding: Constants.padding1,
                  child:
                  Column(
                    children: [
                      Expanded(child: ListView.builder(
                          itemCount: guestHouseList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              alignment: Alignment.topCenter,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          style: Constants.buttonStyle3(),
                                          onPressed: () async {
                                            Uri.parse(guestHouseList[index].linkL);
                                            _launchUrl(guestHouseList[index].linkL);
                                          },
                                          child: Constants.imageColumn2(guestHouseList[index].imageL, guestHouseList[index].nameL)),
                                      if (guestHouseList[index].count == 2)
                                        const SizedBox(width: 20.0,),
                                      if (guestHouseList[index].count == 2)
                                        TextButton(
                                            style: Constants.buttonStyle3(),
                                            onPressed: () {
                                              _launchUrl(guestHouseList[index].linkR);
                                            },
                                            child: Constants.imageColumn2(guestHouseList[index].imageR, guestHouseList[index].nameR)),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                          )
                      )
                    ],
                  ),
                )),
              Constants.licenceButton,
            ],
          ),
        ),
      ),
    );
  }

  void declareItem() {
    preferencesManager = PreferencesManager(context);
    supports = Supports(context);
    staffId = preferencesManager.getString(Constants.staffId)!;
    getGuestHouse();
    fDelay();
  }

  Future<void> fDelay() {
    return Future<void>.delayed(const Duration(seconds: 10), () => setState(() {
        canLoad=false;
      })
    );
  }

  void getGuestHouse() async {
    var url = Uri.parse(Constants.guestHouseLink);
    Map<String, String> data = {
      Constants.requestType : Constants.getGuestHouseDetails,
    };
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      handleResponse(response.body);
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }

  void handleResponse(String response) {
    if (response != Constants.failure) {
      singleGuestHouseList.clear();
      guestHouseList.clear();
      List<String> list1 = response.split(Constants.splitter1);
      for (int i = 1; i < list1.length; i++) {
        List<String> list2 = list1[i].split(Constants.splitter2);
        SingleGuestHouse single = SingleGuestHouse(int.parse(list2[0]), list2[1], list2[2], list2[3]);
        singleGuestHouseList.add(single);
      }

      if ((singleGuestHouseList.length%2) == 0) {
        for (int i = 0; i < (singleGuestHouseList.length/2); i++) {
          int id1 = 2 * i;
          int id2 = id1 + 1;
          GuestHouse gh = GuestHouse(singleGuestHouseList[id1].name, singleGuestHouseList[id2].name,
              singleGuestHouseList[id1].imageUrl, singleGuestHouseList[id2].imageUrl,
              singleGuestHouseList[id1].mapUrl, singleGuestHouseList[id2].mapUrl, 2);
          guestHouseList.add(gh);
        }
      } else {
        for (int i = 0; i < ((singleGuestHouseList.length + 1)/2); i++) {
          int id1 = 2 * i;
          int id2 = id1 + 1;
          if (i == ((singleGuestHouseList.length-1)/2)) {
            GuestHouse gh = GuestHouse(singleGuestHouseList[id1].name, Constants.empty,
                singleGuestHouseList[id1].imageUrl, Constants.empty,
                singleGuestHouseList[id1].mapUrl, Constants.empty, 1);
            guestHouseList.add(gh);
          } else {
            GuestHouse gh = GuestHouse(singleGuestHouseList[id1].name, singleGuestHouseList[id2].name,
                singleGuestHouseList[id1].imageUrl, singleGuestHouseList[id2].imageUrl,
                singleGuestHouseList[id1].mapUrl, singleGuestHouseList[id2].mapUrl, 2);
            guestHouseList.add(gh);
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    } else {
      supports.createSnackBar(Constants.errorMessage);
    }
  }


  Future<void> _launchUrl(String link) async {
    var _url = Uri.parse(link);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

}
