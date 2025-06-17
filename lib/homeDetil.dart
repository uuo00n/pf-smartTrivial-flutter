import 'package:flutter/material.dart';
import 'config.dart';
import 'package:http/http.dart' as http;

class homeDetil extends StatefulWidget {
  const homeDetil({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<homeDetil> createState() => _homeDetilState();
}

class _homeDetilState extends State<homeDetil> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("民宿详细"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
