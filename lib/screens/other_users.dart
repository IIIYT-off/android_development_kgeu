import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:trp_shut_off/api/mapper/user.dart';
import 'package:trp_shut_off/api/models/api_user_models.dart';
import 'package:trp_shut_off/api/request/api_user_requests.dart';
import 'package:trp_shut_off/api/user_services.dart';
import 'package:trp_shut_off/data/model.dart';
import 'package:trp_shut_off/data/token_storage.dart';
import 'package:trp_shut_off/screens/other_user_screen.dart';
import 'package:trp_shut_off/screens/widgets/widgets.dart';

class OtherUsersScreen extends StatefulWidget {
  @override
  _OtherUsersScreenState createState() => _OtherUsersScreenState();
}

class _OtherUsersScreenState extends State<OtherUsersScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Future _futureData;
  List users = [];
  List _searchResult = [];
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Пользователи'),
        actions: [
          Container()
        ],
      ),
      endDrawer: leftDrawer(context),
      bottomNavigationBar: bottomBar(context, _scaffoldKey),
      body: listBody(),
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
    return await UserServices()
        .getUsersData(UserRequestsBody(token: await getTokenFromStorage()));
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    users.forEach((userDetail) {
      if (userDetail.user.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }



 Widget listBody() {
    return FutureBuilder(
        future: _futureData,
        builder: (BuildContext context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            if (snapshot.data.data != 'error') {
              print('Строю экран');
              users = (snapshot.data.data['users']).map((data) => OtherUserDataMapper.fromMap(ApiOtherUserDataModel.fromJson(data))).toList();
              child = _buildBody();
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

  Widget _buildBody() {
    return new Column(
      children: <Widget>[
        new Container(
            color: Theme.of(context).primaryColor, child: _buildSearchBox()),
        new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? searchUsersList()
                : usersList()),
      ],
    );
  }

  Widget usersList(){
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, i) =>
          Padding(
            padding: EdgeInsets.all(8),
            child: GestureDetector(
              child: GradientCard(
                gradient: Gradients.buildGradient(Alignment.centerLeft, Alignment.centerRight, [Colors.lightGreen.withOpacity(0.95), Colors.lightGreen.withOpacity(0.30)]),
                child: ListTile(
                  title: Text(users[i].user,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserProfileScreen(users[i].id)));
              },
            ),
          ),
    );
  }

  Widget searchUsersList(){
    return ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, i) =>
          Padding(
            padding: EdgeInsets.all(8),
            child: GestureDetector(
              child: GradientCard(
                gradient: Gradients.buildGradient(Alignment.centerLeft, Alignment.centerRight, [Colors.lightGreen.withOpacity(0.95), Colors.lightGreen.withOpacity(0.30)]),
                child: ListTile(
                  title: Text(_searchResult[i].user,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserProfileScreen(_searchResult[i].id)));
              },
            ),
          ),
    );
  }


  Widget _buildSearchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'Поиск', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

}
