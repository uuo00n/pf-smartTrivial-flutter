import 'package:flutter/material.dart';
import 'config.dart';
import 'package:http/http.dart' as http;

class searchPage extends StatefulWidget {
  const searchPage({Key? key, this.initText}) : super(key: key);
  final String? initText;

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  var _search = TextEditingController();

  void getInitText() {
    if (widget.initText != null) {
      setState(() {
        _search.text = widget.initText!;
      });
    }
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
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: "输入你要搜索的内容",
                    ),
                  ),
                ),
                TextButton(
                  child: Text("搜索"),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
