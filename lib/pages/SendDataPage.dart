import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendDataPage extends StatefulWidget {
  SendDataPage({Key key, this.title, this.data}) : super(key: key);
  final String title;
  final Map data;
  
  @override
  _SendDataPage createState() => _SendDataPage();
}

class _SendDataPage extends State<SendDataPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _linkGitHub;
  String _linkResume;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(14.0),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: FormGetKey(),
          )
        )
      )
    );
}

   Widget FormGetKey() {
    return Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.url,
          decoration: InputDecoration(labelText: 'Ссылка на GitHub'),
          validator: validateUrl,
          onSaved: (value) {
            _linkGitHub = value;
          },
        ),
        TextFormField(
          keyboardType: TextInputType.url,
          decoration: InputDecoration(labelText: 'Ссылка на резюме'),
          validator: validateUrl,
          onSaved: (value) {
            _linkResume = value;
          },
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 50.0)),
        RaisedButton(
          onPressed: _validateInputs,
          child: const Text('Зарегистрироваться', style: TextStyle(fontSize: 20)),
          color: Colors.orange,
          textColor: Colors.white,
          elevation: 5,
        ),
      ],
    );
  }

  String validateUrl(String value) {
    Pattern pattern =
        r"(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Неверный формат ссылки';
    else
      return null;
  }

  void _validateInputs() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      http.Response res = await sendData();
      if(jsonDecode(res.body)['code'] == 0){
        // token = jsonDecode(res.body)['data'];
        print("RESPONSE: " + res.body);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Данные приняты в обработку'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK!', style: TextStyle(color: Colors.orange, fontSize: 20),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      else{
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Что-то пошло не так!'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK!', style: TextStyle(color: Colors.orange, fontSize: 20),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future<http.Response> sendData() {
    return http.post(
      'https://vacancy.dns-shop.ru/api/candidate/summary',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer ${widget.data['token']}'
      },
      body: jsonEncode({
        "firstName": widget.data['firstName'],
        "lastName": widget.data['lastName'],
        "phone": widget.data['phone'],
        "email": widget.data['email'],
        "githubProfileUrl": _linkGitHub,
        "summary": _linkResume
      }),
    );
  }
}

