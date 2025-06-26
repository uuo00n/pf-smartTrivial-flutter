import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modules_c_k/api/config.dart';
import 'package:modules_c_k/view/init/reg.dart';
import 'package:http/http.dart' as http;

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  bool _showPwdState = true;

  void _setPwdState() {
    if (_showPwdState) {
      setState(() {
        _showPwdState = false;
      });
    } else {
      setState(() {
        _showPwdState = true;
      });
    }
  }

  Future<void> login() async {
    var lg = Uri.parse(Base_url + '/api/login');
    var lgHeader = {"Content-Type": "application/json"};
    var lgbody =
        jsonEncode({"username": _username.text, "password": _password.text});
    var lgreq = await http.post(lg, headers: lgHeader, body: lgbody);
    var lgresp = jsonDecode(utf8.decode(lgreq.bodyBytes));
    if (lgresp['code'] == 200) {
      Base_token = lgresp['token'];
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(lgresp['msg'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_rounded),
                  labelText: '账号',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  )),
              controller: _username,
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: '密码',
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_showPwdState
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      _setPwdState();
                    },
                  )),
              obscureText: _showPwdState,
              controller: _password,
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
            ),
            TextButton(
                onPressed: () async {
                  final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => regPage(),
                      ));
                  if (res != null) {
                    setState(() {
                      _username.text = res;
                    });
                  }
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '还有没有账号，', style: TextStyle(color: Colors.black)),
                    TextSpan(text: '去注册', style: TextStyle(color: Colors.red)),
                  ]),
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  login();
                },
                child: Text("登录"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
