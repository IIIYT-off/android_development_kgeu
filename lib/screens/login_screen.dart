import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trp_shut_off/api/auth_services.dart';
import 'package:trp_shut_off/api/mapper/user.dart';
import 'package:trp_shut_off/api/models/api_user_models.dart';
import 'package:trp_shut_off/api/request/api_user_requests.dart';
import 'package:trp_shut_off/data/model.dart';
import 'package:trp_shut_off/data/token_storage.dart';
import 'package:trp_shut_off/globals.dart' as globals;
import 'package:trp_shut_off/screens/user_profile.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();

  String login;
  String password;

  String authError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(globals.appName)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onChanged: (text) {
                  login = text;
                },
                obscureText: false,
                validator: (value) {
                  if (value.isEmpty) return 'Пожалуйста, введите логин';
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'Логин',
                  labelStyle:
                      new TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
              TextFormField(
                onChanged: (text) {
                  password = text;
                },
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) return 'Пожалуйста, введите пароль';
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Пароль',
                  labelStyle:
                      new TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  authError,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text('Зарегистрироваться'),
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        regNewUser();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text('Войти'),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        logIn();
                      },
                    ),
                  ),
                ],
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  regNewUser() async {
    Response response = await AuthServices()
        .register(LogRegRequestBody(login: login, password: password));
    if (response.statusCode == 200) {
      if (response.data != 'error') {
        LogRegDataModel _logReg =
            RegLogMapper.fromMap(ApiLogRegModel.fromJson(response.data));
        print(_logReg.login);
        print(_logReg.token);
        await addTokenToStorage(_logReg.token);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => new UserProfileScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        //Пользователь с таким Логином уже зарегистрирован
        print(response.data);
      }
    } else {
      print(response.statusCode);
    }
  }

  logIn() async {
    Response response = await AuthServices()
        .login(LogRegRequestBody(login: login, password: password));
    if (response.statusCode == 200) {
      if (response.data != 'error') {
        LogRegDataModel _logReg =
            RegLogMapper.fromMap(ApiLogRegModel.fromJson(response.data));
        print(_logReg.login);
        print(_logReg.token);
        await addTokenToStorage(_logReg.token);
            Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => new UserProfileScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        //Не верные данные авторизации
        print(response.data);
      }
    } else {
      print(response.statusCode);
    }
  }
}
