import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maps_launcher/maps_launcher.dart';

class DisplayInfo extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final displayInfo;

  const DisplayInfo({Key? key, required this.displayInfo}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DisplayInfo createState() => _DisplayInfo();
}

class _DisplayInfo extends State<DisplayInfo> {
  var language = "en";

  var infoModel = {
    "Title": "",
    "DistrictText": "",
    "District": "",
    "Route": "",
    "RouteText": "",
    "HowToAccess": "",
    "HowToAccessText": "",
    "MapURL": "",
    "Latitude": 0.0,
    "Longitude": 0.0,
    "OpenMap": "",
  };

  @override
  void initState() {
    super.initState();
    _oninit();
  }

  //初始化
  Future<void> _oninit() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language').toString();
    if (language != null) {
      setState(() {
        language = language;
      });
    } else {
      prefs.setString("language", "en");
      setState(() {
        language = "en";
      });
    }
    setLaunage();
  }

  //按語言序列化物件
  void setLaunage() {
    switch (language) {
      case "en":
        infoModel["Title"] = widget.displayInfo["Title_en"];
        infoModel["District"] = widget.displayInfo["District_en"];
        infoModel["DistrictText"] = "District:";
        infoModel["Route"] =
            '${widget.displayInfo["Route_en"]}'.replaceAll("<br>", "\n");
        infoModel["RouteText"] = "Route:";
        infoModel["HowToAccess"] = widget.displayInfo["HowToAccess_en"]
            .toString()
            .replaceAll("<br>", "\n");
        infoModel["HowToAccess"] =
            infoModel["HowToAccess"].toString().replaceAll("<br>", "\n");
        infoModel["HowToAccessText"] = "How to access:";
        infoModel["MapURL"] = widget.displayInfo["MapURL_en"];
        infoModel["Latitude"] = widget.displayInfo["Latitude"];
        infoModel["Longitude"] = widget.displayInfo["Longitude"];
        infoModel["OpenMap"] = "Open in Map";
        break;
      case "tc":
        infoModel["Title"] = widget.displayInfo["Title_tc"];
        infoModel["District"] = '${widget.displayInfo["District_tc"]}';
        infoModel["DistrictText"] = "區:";
        infoModel["Route"] =
            '${widget.displayInfo["Route_tc"]}'.replaceAll("<br>", "\n");
        infoModel["RouteText"] = "路徑:";
        infoModel["HowToAccess"] = widget.displayInfo["HowToAccess_tc"]
            .toString()
            .replaceAll("\n", "");
        infoModel["HowToAccess"] =
            infoModel["HowToAccess"].toString().replaceAll("<br>", "\n");
        infoModel["HowToAccessText"] = "如何到達:";
        infoModel["MapURL"] = widget.displayInfo["MapURL_tc"];
        infoModel["Latitude"] = widget.displayInfo["Latitude"];
        infoModel["Longitude"] = widget.displayInfo["Longitude"];
        infoModel["OpenMap"] = "在地圖中打開";
        break;
      case "sc":
        infoModel["Title"] = widget.displayInfo["Title_sc"];
        infoModel["District"] = '${widget.displayInfo["District_sc"]}';
        infoModel["DistrictText"] = "区:";
        infoModel["Route"] =
            '${widget.displayInfo["Route_sc"]}'.replaceAll("<br>", "\n");
        infoModel["RouteText"] = "路径:";
        infoModel["HowToAccess"] = widget.displayInfo["HowToAccess_sc"]
            .toString()
            .replaceAll("\n", "");
        infoModel["HowToAccess"] =
            infoModel["HowToAccess"].toString().replaceAll("<br>", "\n");
        infoModel["HowToAccessText"] = "如何到达:";
        infoModel["MapURL"] = widget.displayInfo["MapURL_sc"];
        infoModel["Latitude"] = widget.displayInfo["Latitude"];
        infoModel["Longitude"] = widget.displayInfo["Longitude"];
        infoModel["OpenMap"] = "在地图中打开";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xff6c5fe0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context, true),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      //語言切換按鈕
                      language != "en"
                          ? SizedBox(
                              width: 35,
                              height: 35,
                              child: MaterialButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString("language", "en");
                                  setState(() {
                                    language = "en";
                                  });
                                  setLaunage();
                                },
                                color: const Color(0xffa8a1ea),
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(7),
                                shape: const CircleBorder(),
                                child: const Text("En"),
                              ),
                            )
                          : const SizedBox(),
                      language == "en" || language == "sc"
                          ? const SizedBox(width: 10)
                          : const SizedBox(),
                      language != "tc"
                          ? SizedBox(
                              width: 35,
                              height: 35,
                              child: MaterialButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString("language", "tc");
                                  setState(() {
                                    language = "tc";
                                  });
                                  setLaunage();
                                },
                                color: const Color(0xffa8a1ea),
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(7),
                                shape: const CircleBorder(),
                                child: const Text("繁"),
                              ),
                            )
                          : const SizedBox(),
                      language == "tc" || language == "en"
                          ? const SizedBox(width: 10)
                          : const SizedBox(),
                      language != "sc"
                          ? SizedBox(
                              width: 35,
                              height: 35,
                              child: MaterialButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString("language", "sc");
                                  setState(() {
                                    language = "sc";
                                  });
                                  setLaunage();
                                },
                                color: const Color(0xffa8a1ea),
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(7),
                                shape: const CircleBorder(),
                                child: const Text("简"),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //物件资讯展示
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.1, right: size.width * 0.1),
                    child: Center(
                      child: Text(
                        infoModel["Title"].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  infoModel["MapURL"].toString() != ""
                      ? Image.network(
                          infoModel["MapURL"].toString(),
                          width: size.width * 0.9,
                          height: size.height * 0.3,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          infoModel["DistrictText"].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          infoModel["District"].toString(),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          infoModel["RouteText"].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          infoModel["Route"].toString(),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          infoModel["HowToAccessText"].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          infoModel["HowToAccess"].toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  //開啟地图按钮
                  infoModel["Latitude"].toString() != ""
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(size.width * 0.5, size.height * 0.05),
                            backgroundColor: const Color(0xff6c5fe0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            //開啟地图
                            MapsLauncher.launchCoordinates(
                                double.parse(infoModel['Latitude'].toString()),
                                double.parse(
                                    infoModel['Longitude'].toString()));
                          },
                          child: Text(infoModel["OpenMap"].toString()),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
