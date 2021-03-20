import 'package:flutter/material.dart';
import 'package:trp_shut_off/api/mapper/user.dart';
import 'package:trp_shut_off/api/models/api_user_models.dart';
import 'package:trp_shut_off/api/request/api_user_requests.dart';
import 'package:trp_shut_off/api/user_services.dart';
import 'package:trp_shut_off/data/model.dart';
import 'package:trp_shut_off/data/token_storage.dart';

class DialogScreen extends StatefulWidget {
  UserDataModel receiver;

  DialogScreen(this.receiver);

  @override
  _DialogScreenState createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  List messages = [];
  TextEditingController controller = new TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Future _futureData;

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
    return await UserServices().getDialogData(GetDialogRequestBody(
        token: await getTokenFromStorage(), receiver: widget.receiver.id));
  }

  sendMessage() async {
    await UserServices().sendMessage(SendMessageRequestBody(
        token: await getTokenFromStorage(),
        receiver: widget.receiver.id,
        message: controller.text));
    controller.clear();
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.receiver.user),
        ),
        body: Column(
          children: [
            Expanded(
              child: listBody(),
            ),
            messageBox(),
          ],
        ));
  }

  Widget listBody() {
    return FutureBuilder(
        future: _futureData,
        builder: (BuildContext context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            if (snapshot.data.data != 'error') {
              print('Строю экран');
              messages = (snapshot.data.data['messages'])
                  .map((data) =>
                      GetDialogDataMapper.fromMap(ApiGetDialog.fromJson(data)))
                  .toList();
              child = messagesList();
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

  messagesList() {
    return ListView.builder(
      itemCount: messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment: (messages[index].receiver != widget.receiver.id
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (messages[index].receiver != widget.receiver.id
                    ? Colors.grey.shade200
                    : Colors.green[200]),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                messages[index].message,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        );
      },
    );
  }

  messageBox() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: "Сообщение...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () async {
                    if (controller.text.isNotEmpty) {
                      await sendMessage();
                    }
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
