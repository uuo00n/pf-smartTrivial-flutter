import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modules_c_k/api/config.dart';
import 'package:http/http.dart' as http;

class homeDetil extends StatefulWidget {
  const homeDetil({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<homeDetil> createState() => _homeDetilState();
}

class _homeDetilState extends State<homeDetil> {
  final _imagePageControll = PageController();

  var _homeData = {};
  var _imageList = [];

  int _imageIndex = 0;
  double _payPrice = 0;
  int _ticketCount = 1;

  bool _stared = false;

  Timer? timer;

  void _startState() {
    if (_stared == false) {
      setState(() {
        _stared = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("收藏民宿成功")));
    } else {
      setState(() {
        _stared = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("取消收藏民宿成功")));
    }
  }

  void _imageScroll() {
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_imagePageControll.hasClients) {
        _imageIndex++;
        if (_imageIndex > _imageList.length) {
          _imageIndex = 0;
        }
        _imagePageControll.animateToPage(_imageIndex,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
  }

  Future<void> getHomeDetil() async {
    var gt = Uri.parse(Base_url + '/api/house/' + widget.id);
    var gtHeader = {"Content-Type": "application/json"};
    var gtreq = await http.get(gt, headers: gtHeader);
    var gtresp = jsonDecode(utf8.decode(gtreq.bodyBytes));
    setState(() {
      _homeData = gtresp['data'];
      _imageList = _homeData['imageList'];
      _payPrice = double.parse(_homeData['price']);
    });
  }

  void showDilogView() {
    showModalBottomSheet(
      context: context,
      builder: (context) => dilogView(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
    getHomeDetil();
    _imageScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("民宿详细"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _startState();
              },
              icon: _stared ? Icon(Icons.star) : Icon(Icons.star_border))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_imageList.length != 0)
              Column(
                children: [
                  Container(
                    child: PageView.builder(
                      controller: _imagePageControll,
                      itemCount: _imageList.length,
                      itemBuilder: (context, index) {
                        var item = _imageList[index];
                        return Image.network(
                          Base_url + item["url"],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text(
                      _homeData['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("评分：${_homeData['score']}"),
                        Text("标签：${_homeData['tags']}")
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        showDilogView();
                      },
                      child: Text("购票须知"),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                  ),
                  Divider(),
                  Card(
                    child: ListTile(
                      title: Text("购票数量"),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [Text("单价￥${_payPrice}")],
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (_ticketCount > 1) {
                                      setState(() {
                                        _ticketCount = _ticketCount - 1;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("单人不可订购少于1间")));
                                    }
                                  });
                                },
                                child: Text("-"),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("${_ticketCount}"),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (_ticketCount < 10) {
                                      setState(() {
                                        _ticketCount = _ticketCount + 1;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("单人不可订购超过10间")));
                                    }
                                  });
                                },
                                child: Text("+"),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("地理位置"),
                    subtitle: Text(
                        "地址：${_homeData['province']}${_homeData['city']}${_homeData['area']}${_homeData['location']}"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => mapDetil(),));
                      },
                      child: Text("导览"),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                  ),
                  ListTile(
                    title: Text("设施"),
                    subtitle: Text("${_homeData['equipment']}"),
                  ),
                  ListTile(
                    title: Text("特色"),
                    subtitle: Text("${_homeData['advantage']}"),
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(style: TextStyle(color: Colors.black), text: "价格总计："),
                TextSpan(
                    text: "¥${_payPrice * _ticketCount}",
                    style: TextStyle(color: Colors.red))
              ])),
              ElevatedButton(
                onPressed: () {},
                child: Text("订购"),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class dilogView extends StatefulWidget {
  const dilogView({Key? key}) : super(key: key);

  @override
  State<dilogView> createState() => _dilogViewState();
}

class _dilogViewState extends State<dilogView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          ListTile(
            title: Text("购票须知"),
            trailing: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.clear)),
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text("""（一）半票优惠对象：
1. 身高1.2米以上、6—18岁的未成年人；
2. 60—69周岁的老年人（凭身份证及老年优待证）；
3. 全日制普通本科及以下在校学生（凭有效注册的学生证）；

（二）免票优惠对象：
1. 身高1.2米以下、6岁以下儿童；
2. 70岁以上的老年人（含70岁，凭身份证及老年优待证）；
   执行甘肃省人民政府颁发的《甘肃省老年人优待证》的相关优惠政策；
   离休干部凭本人离休干部证；
3. 现役军人（凭军官证或士兵证及保障卡，不含文职人员），
   军队离休、退休干部（凭军队颁发的离休、退休证）；
4. 残疾人、伤残军人（凭身份证及残疾证或残疾军人证）；
5. 记者（凭国家新闻出版广电总局颁发的记者证）；
6. 带团导游（凭导游证、旅行社委派单及出团计划书）；
7. 公安民警（持《人民警察证》可享受省内景区门票免费政策）。""")
                ],
              ),
            ),
          ),
          Divider(),
          Container(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("我已知晓")),
            width: MediaQuery.of(context).size.width * 0.95,
          )
        ],
      ),
    );
  }
}
