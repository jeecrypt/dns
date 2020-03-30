import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../route.gr.dart';

class GetKeyPage extends StatefulWidget {
  // GetKeyPage({Key key}) : super(key: key);

  @override
  _GetKeyPage createState() => _GetKeyPage();
}

class _GetKeyPage extends State<GetKeyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  String _token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ввод данных", style: TextStyle(color: Colors.white),),
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
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: 'Имя'),
          validator: validateName,
          onSaved: (value) {
            _firstName = value;
          },
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: 'Фамилия'),
          validator: validateLastName,
          onSaved: (value) {
            _lastName = value;
          },
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'e-mail'),
          validator: validateEmail,
          onSaved: (value) {
            _email = value;
          },
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(labelText: 'Телефон'),
          validator: validateMobile,
          onSaved: (value) {
            _phone = value;
          },
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 50.0)),
        RaisedButton(
          onPressed: _validateInputs,
          child: const Text('Получить ключ', style: TextStyle(fontSize: 20)),
          color: Colors.orange,
          textColor: Colors.white,
          elevation: 5,
        ),
      ],
    );
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Имя не может быть короче 3 символов';
    else
      return null;
  }

  String validateLastName(String value) {
    if (value.length < 3)
      return 'Фамилия не может быть короче 3 символов';
    else
      return null;
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Номер должен содержать 10 цифр';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Неверный формат E-mail';
    else
      return null;
  }

  void _validateInputs() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      http.Response res = await getKey();
      if(jsonDecode(res.body)['code'] == 0){
        _token = jsonDecode(res.body)['data'];
        print("TOKEN: " + _token);
        ExtendedNavigator.of(context).pushNamed(Routes.sendDataPage, arguments: SendDataPageArguments(title: 'Отправка данных', data: {
            "firstName": _firstName,
            "lastName": _lastName,
            "phone": _phone,
            "email": _email,
            "token": _token
          })
        );
      }
      else{
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(jsonDecode(res.body)['data']),
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

  Future<http.Response> getKey() {
    return http.post(
      'https://vacancy.dns-shop.ru/api/candidate/token',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "firstName": _firstName,
        "lastName": _lastName,
        "phone": _phone,
        "email": _email
      }),
    );
  }
}

