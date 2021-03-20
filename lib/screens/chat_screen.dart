import 'package:flutter/material.dart';
import 'package:trp_shut_off/screens/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: new Container(),
        title: Text('Диалоги'),
        actions: [createNewDialog()],
      ),
      endDrawer: leftDrawer(context),
      bottomNavigationBar: bottomBar(context, _scaffoldKey),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createNewDialog() {
    return GestureDetector(
      onTap: () {

      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add,
              size: 20,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              "Создать новый",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
