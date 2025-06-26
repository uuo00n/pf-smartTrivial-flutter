import 'package:flutter/material.dart';
import 'package:modules_c_k/view/devPage.dart';
import 'package:modules_c_k/view/home/homePage.dart';
import 'package:modules_c_k/view/init/login.dart';
import '../api/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'modules_c',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/login': (context) => loginPage(),
        '/main': (context) => MyHomePage()
      },
      initialRoute: '/login',
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  var _pageList = [homePage(),DevPage(),DevPage(),DevPage()];
  int _pageIndex = 0;

  void _selectPageIndex(index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(Base_token.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "文章"),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: "收藏"),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle), label: "我的"),
        ],
        onTap: _selectPageIndex,
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
      ),
    );
  }
}
