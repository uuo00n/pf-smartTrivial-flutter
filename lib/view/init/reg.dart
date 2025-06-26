import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modules_c_k/api/config.dart';

class regPage extends StatefulWidget {
  const regPage({Key? key}) : super(key: key);

  @override
  State<regPage> createState() => _regPageState();
}

class _regPageState extends State<regPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _nickname = TextEditingController();
  final _regCode = TextEditingController();

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

  Future<void> getCode() async {
    if (_username.text.isNotEmpty &&
        _password.text.isNotEmpty &&
        _nickname.text.isNotEmpty) {
      var reg = Uri.parse(Base_url +
          '/api/code?username=${_username.text}&password=${_password.text}');
      var reghd = {"Content-Type": "application/json"};
      var regReq = await http.get(reg, headers: reghd);
      var regResp = jsonDecode(utf8.decode(regReq.bodyBytes));
      if (regResp['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("获取验证码成功，验证码为：${regResp['valid_code']}")));
        setState(() {
          _regCode.text = regResp['valid_code'];
        });
      }
    } else {
      print('注册信息不能为空');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("注册信息不能为空")));
    }
  }

  Future<void> reg() async {
    if (_username.text.isNotEmpty &&
        _password.text.isNotEmpty &&
        _nickname.text.isNotEmpty) {
      var reg = Uri.parse(Base_url + '/api/register');
      var reghd = {"Content-Type": "application/json"};
      var regbd = jsonEncode({
        "code": _regCode.text.toString(),
        "username": _username.text.toString(),
        "password": _password.text.toString()
      });
      var regReq = await http.post(reg, headers: reghd, body: regbd);
      var regResp = jsonDecode(utf8.decode(regReq.bodyBytes));
      if (regResp['code'] == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("注册成功")));
        Navigator.pop(context,_username.text);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(regResp['msg'])));
      }
    } else {
      print('注册信息不能为空');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("注册"),
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
            SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.switch_account),
                  labelText: '昵称',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  )),
              controller: _nickname,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.code),
                        labelText: '验证码',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        )),
                    controller: _regCode,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () {
                      getCode();
                    },
                    child: Text("获取验证码"),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  reg();
                },
                child: Text("注册"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
