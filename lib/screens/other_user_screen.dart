import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trp_shut_off/api/mapper/user.dart';
import 'package:trp_shut_off/api/models/api_user_models.dart';
import 'package:trp_shut_off/api/request/api_user_requests.dart';
import 'package:trp_shut_off/api/user_services.dart';
import 'package:trp_shut_off/data/model.dart';
import 'package:trp_shut_off/data/token_storage.dart';
import 'package:trp_shut_off/globals.dart' as globals;
import 'package:trp_shut_off/screens/widgets/widgets.dart';

import 'dialog_screen.dart';

class UserProfileScreen extends StatefulWidget {
  int id;

  UserProfileScreen(this.id);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  UserDataModel user = UserDataModel();
  bool editing = false;
  Future _futureData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Профиль'),
        actions: [
          sendMessage()
        ],
      ),
      body: listBody(),
      endDrawer: leftDrawer(context),
      bottomNavigationBar: bottomBar(context, _scaffoldKey),
    );
  }

  @override
  void initState() {
    super.initState();

    // initial load
    _futureData = updateAndGetList();
  }

  void refreshList() {
    // reload
    setState(() {
      _futureData = updateAndGetList();
    });
  }

  Future updateAndGetList() async {
    return await UserServices().getOtherUserData(OtherUserRequestsBody(
        token: await getTokenFromStorage(), id: widget.id));
  }

  sendMessage(){
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DialogScreen(user)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.message,
              size: 20,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              "Отправить сообщение",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget listBody() {
    return FutureBuilder(
        future: _futureData,
        builder: (BuildContext context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            if (snapshot.data.data != 'error') {
              print('Строю экран');
              user = UserDataMapper.fromMap(
                  ApiUserDataModel.fromJson(snapshot.data.data));
              child = userData();
            } else {
              print('error');
              child = Center(
                child: ElevatedButton(
                    onPressed: () {
                      refreshList();
                    },
                    child: Text('Обновить')),
              );
            }
          } else {
            child = loading();
          }
          return child;
        });
  }

  Widget loading() {
    return ListView(
      children: [
        Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget userData() {
    return ListView(
      children: [
        userImageField(),
        userDataField('Номер телефона', user.phoneNumber),
        userDataField('Фамилия', user.family),
        userDataField('Имя', user.user),
        userDataField('Дата рождения', user.birthday),
        userDataField('VK', user.vk),
        userDataField('Skype', user.skype),
      ],
    );
  }

  Widget userImageField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.height / 5,
        child: Image.network(user.image),
      ),
    );
  }

  Widget userDataField(String label, String data) {
    TextEditingController _moduleController = new TextEditingController();
    _moduleController.text = data;
    return Padding(
        padding:
            const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
        child: TextFormField(
          controller: _moduleController,
          enabled: editing,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
          ),
        ));
  }
}
