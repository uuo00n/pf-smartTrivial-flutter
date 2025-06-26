import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modules_c_k/view/home/homeDetil.dart';
import 'package:modules_c_k/view/home/searchPage.dart';
import 'package:modules_c_k/api/config.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  var _search = TextEditingController();
  var _adPageControl = PageController();
  var _adList = [];
  var _homeList = [];
  List<String> uniqueProvinces = [];
  List<String> uniqueCity = [];

  int _adIndex = 0;

  Timer? timer;
  String? selectProv;
  String? selectCity;

  Future<void> getAd() async {
    var ad = Uri.parse(Base_url + '/api/adv/list');
    var adhd = {"Content-Type": "application/json"};
    var adReq = await http.get(ad, headers: adhd);
    var adResp = jsonDecode(utf8.decode(adReq.bodyBytes));
    setState(() {
      _adList = adResp['data'];
    });
  }

  Future<void> gethome() async {
    var home = Uri.parse(Base_url + '/api/house/list');
    var homehd = {"Content-Type": "application/json"};
    var homeReq = await http.get(home, headers: homehd);
    var homeResp = jsonDecode(utf8.decode(homeReq.bodyBytes));
    setState(() {
      _homeList = homeResp['rows'];
    });
    print(_homeList);
  }

  Future<void> getLocation() async {
    var location = Uri.parse(Base_url + '/api/location/area/list');
    var locationhd = {
      "Content-Type": "application/json",
      "Authorization": Base_token
    };
    var locationReq = await http.get(location, headers: locationhd);
    var locationResp = jsonDecode(utf8.decode(locationReq.bodyBytes));
    print(locationResp);
    uniqueProvinces = (locationResp['rows'] as List)
        .map((e) => e['provinceName'] as String)
        .toSet()
        .toList();
    print(uniqueProvinces);
  }

  Future<void> getcity() async {
    var location = Uri.parse(Base_url +
        '/api/location/area/list?provinceName==' +
        selectProv.toString());
    var locationhd = {
      "Content-Type": "application/json",
      "Authorization": Base_token
    };
    var locationReq = await http.get(location, headers: locationhd);
    var locationResp = jsonDecode(utf8.decode(locationReq.bodyBytes));
    print(locationResp);
    uniqueCity = (locationResp['rows'] as List)
        .map((e) => e['name'] as String)
        .toSet()
        .toList();
    print(uniqueCity);
  }

  void _adPageScroll() {
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_adPageControl.hasClients) {
        _adIndex++;
        if (_adIndex >= _adList.length) {
          _adIndex = 0;
        }
        _adPageControl.animateToPage(_adIndex,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAd();
    gethome();
    _adPageScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _search,
          decoration: InputDecoration(
            hintText: "搜索",
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => searchPage(
                        initText: _search.text,
                      ),
                    ));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_adList.length != 0 && _homeList.length != 0)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [],
                    ),
                  ),
                  Container(
                    child: PageView.builder(
                      controller: _adPageControl,
                      itemCount: _adList.length,
                      itemBuilder: (context, index) {
                        var item = _adList[index];
                        return Image.network(
                          Base_url + item["image"],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: " | ", style: TextStyle(color: Colors.blue)),
                        TextSpan(
                            text: "热门推荐",
                            style: TextStyle(color: Colors.black)),
                      ]),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _homeList.length,
                    itemBuilder: (context, index) {
                      var item = _homeList[index];
                      return ListTile(
                        onTap: () {
                          print(item['id']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    homeDetil(id: item['id'].toString()),
                              ));
                        },
                        title: Text(item['title'],
                            overflow: TextOverflow.ellipsis),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            Base_url + item['cover'],
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("地理位置：" + item['cityInfo']),
                            Text("评分：" + item["score"]),
                            Text(
                              "￥${item['price']}",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("数据加载中，请稍后..."), CircularProgressIndicator()],
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.home),
      ),
    );
  }
}
