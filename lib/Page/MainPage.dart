import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './DisplayInfo.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  var testText = "";
  var decodeResult = [];
  var language = "en";
  var queryList = [];

  @override
  void initState() {
    super.initState();
    _oninit();
  }

  //初始化
  Future<void> _oninit() async {
    //URI  序列化
    var url = Uri.parse(
        "https://www.lcsd.gov.hk/datagovhk/facility/facility-fw.json");
    // 取得網路資料
    var response = await http.get(url);

    // 判斷是否為json格式
    if (response.headers['content-type'] == 'application/json') {
      setState(() {
        testText = jsonDecode(utf8.decode(response.bodyBytes)).toString();
        for (var i = 0;
            i < jsonDecode(utf8.decode(response.bodyBytes)).length;
            i++) {
          decodeResult.add(jsonDecode(utf8.decode(response.bodyBytes))[i]);
        }
      });
    }
    setState(() {
      //序列化搜尋列表
      queryList = decodeResult;
    });
    //取得語言
    getLanguage();
  }

  //取得語言
  void getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language').toString();
    //檢查空值
    if (language != "null") {
      setState(() {
        language = language;
      });
    } else {
      prefs.setString("language", "en");
      setState(() {
        language = "en";
      });
    }
  }

  //搜尋（預設全部檢示）
  void query(String query) {
    setState(() {
      queryList = decodeResult
          .where((element) =>
              element["Title_en"].toString().contains(query) ||
              element["Title_tc"].toString().contains(query) ||
              element["Title_sc"].toString().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: size.height * 0.07),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: Text(
                            "App Name",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: "Comfortaa",
                            ),
                          ),
                        ),
                        //語言選擇按鈕
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
                                  },
                                  color: const Color(0xffa8a1ea),
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(7),
                                  shape: const CircleBorder(),
                                  child: const Text("简"),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //搜尋框
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffa8a1ea),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.search,
                            color: Color(0xffc8c4fd),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: language == "en"
                                    ? "Search"
                                    : language == "tc"
                                        ? "搜尋"
                                        : "搜索",
                                border: InputBorder.none,
                                hintStyle: const TextStyle(
                                  color: Color(0xffc8c4fd),
                                ),
                              ),
                              onChanged: (value) {
                                query(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              //搜尋結果列表
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  // ignore: non_constant_identifier_names
                  String TitleLang;
                  //輸出指定語言的物件
                  switch (language) {
                    case "en":
                      TitleLang = "Title_en";
                      break;
                    case "tc":
                      TitleLang = "Title_tc";
                      break;
                    case "sc":
                      TitleLang = "Title_sc";
                      break;
                    default:
                      TitleLang = "Title_en";
                      break;
                  }

                  return Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 0.8, color: Color(0xffe5e5e5)))),
                    child: ListTile(
                      title: Text(queryList[index][TitleLang]),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        //檢查下一頁是否有回傳值
                        var result = await Navigator.push(
                          context,
                          //非線性動畫
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 700),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              //動畫曲線
                              animation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOutQuint);

                              //輸出物件到DisplayInfo
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: DisplayInfo(
                                  displayInfo: queryList[index],
                                ),
                              );
                            },
                          ),
                        );
                        //如果有回傳值，則重新取得語言
                        if (result == true) {
                          getLanguage();
                        }
                      },
                    ),
                  );
                },
                itemCount: queryList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
