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

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  UserDataModel user = UserDataModel();
  bool editing = false;
  Future _futureData;
  File _pickedImage;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Профиль'), actions: appBarActions()),
      body: listBody(),
      endDrawer: leftDrawer(context),
      bottomNavigationBar: bottomBar(context, _scaffoldKey),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _pickedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  appBarActions() {
    List<Widget> _list = [];
    if (!editing) {
      _list.add(Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {
            editing = true;
            print('updateMode');
            setState(() {});
          },
          child: Icon(
            Icons.edit,
            size: 26.0,
          ),
        ),
      ));
    } else {
      _list.add(Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () async {
            String _token = await getTokenFromStorage();
            try {
              await UserServices().updateUserData(UpdateUserDataRequestBody(
                  token: _token,
                  user: user.user,
                  family: user.family,
                  birthday: user.birthday,
                  phoneNumber: user.phoneNumber,
                  vk: user.vk,
                  skype: user.skype));
            } catch (error) {
              print(error);
            }
            List<int> imageBytes = _pickedImage.readAsBytesSync();
            try {
              await UserServices().updateUserImage(UpdateUserImageRequestsBody(token: _token, image: base64Encode(imageBytes)));
            } catch (error) {
              print(error);
            }
            editing = false;
            _pickedImage = null;
            print('save');
            refreshList();
          },
          child: Icon(
            Icons.save,
            size: 26.0,
          ),
        ),
      ));
      _list.add(Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {
            editing = false;
            print('cancel');
            refreshList();
          },
          child: Icon(
            Icons.dangerous,
            size: 26.0,
          ),
        ),
      ));
    }
    return _list;
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
    return await UserServices()
        .getUserData(UserRequestsBody(token: await getTokenFromStorage()));
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
        userDataField('Логин', user.login),
        userDataField('Номер телефона', user.phoneNumber),
        userDataField('Фамилия', user.family),
        // userDataField('Фамилия', 'user.family'),
        userDataField('Имя', user.user),
        userDataField('Дата рождения', user.birthday),
        userDataField('VK', user.vk),
        userDataField('Skype', user.skype),
      ],
    );
  }

  Widget userImageField() {
    Widget _image;
    if (_pickedImage == null) {
      _image = Image.network(user.image);
    } else {
      _image = Image.file(_pickedImage);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          if(editing){
            getImage();
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.height / 5,
          child: _image,
        ),
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
          readOnly: !editing,
          enabled: editing,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
          ),
        ));
  }


}
