import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modules_c_k/api/config.dart';
import 'package:http/http.dart' as http;

import 'homeDetil.dart';

class searchPage extends StatefulWidget {
  const searchPage({Key? key, this.initText}) : super(key: key);
  final String? initText;

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  var _search = TextEditingController();

  var _homeList = [];

  void getInitText() {
    if (widget.initText != null) {
      setState(() {
        _search.text = widget.initText!;
      });
    }
    searchHome();
  }

  Future<void> clearHome() async {
    var home = Uri.parse(Base_url + '/api/house/list');
    var homehd = {"Content-Type": "application/json"};
    var homeReq = await http.get(home, headers: homehd);
    var homeResp = jsonDecode(utf8.decode(homeReq.bodyBytes));
    setState(() {
      _homeList = homeResp['rows'];
    });
    print(_homeList);
  }

  Future<void> searchHome() async {
    var home = Uri.parse(Base_url + '/api/house/list?title=' + _search.text);
    var homehd = {"Content-Type": "application/json"};
    var homeReq = await http.get(home, headers: homehd);
    var homeResp = jsonDecode(utf8.decode(homeReq.bodyBytes));
    if (homeResp['total'] != 0) {
      setState(() {
        _homeList = homeResp['rows'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("查询成功！共查询到${homeResp['total']}条")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("暂无相关内容")));
    }
    print(_homeList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("搜索"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                        hintText: "输入你要搜索的内容",
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 15,
                          ),
                          onPressed: () {
                            _search.clear();
                          },
                        )),
                  ),
                ),
                TextButton(
                  child: Text("搜索"),
                  onPressed: () {
                    searchHome();
                  },
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: " | ", style: TextStyle(color: Colors.blue)),
                    TextSpan(
                        text: "搜索结果", style: TextStyle(color: Colors.black)),
                  ]),
                )
              ],
            ),
            if (_homeList.length != 0)
              Expanded(
                  child: ListView.builder(
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
                        title: Text(
                            item['title'], overflow: TextOverflow.ellipsis),
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
                  ))
            else
              Center(
                child: Text("暂无相关内容"),
              )
          ],
        ),
      ),
    );
  }
}
