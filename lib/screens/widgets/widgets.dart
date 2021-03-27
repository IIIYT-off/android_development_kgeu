import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trp_shut_off/data/token_storage.dart';

import '../chat_screen.dart';
import '../gallery_screen.dart';
import '../login_screen.dart';
import '../other_users.dart';
import '../user_profile.dart';

Widget bottomBar(BuildContext context, _key) {
  return BottomAppBar(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          tooltip: 'Galery',
          icon: const Icon(Icons.image_outlined),
          onPressed: () {
            if (!context.toString().contains('GalleryScreen')) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GalleryScreen()));
            }
          },
        ),
        IconButton(
          tooltip: 'Dialogs',
          icon: const Icon(Icons.chat),
          onPressed: () {
            if (!context.toString().contains('ChatScreen')) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatScreen()));
            }
          },
        ),
        IconButton(
          tooltip: 'Open navigation menu',
          icon: const Icon(Icons.menu),
          onPressed: () {
            _key.currentState.openEndDrawer();
          },
        ),
      ],
    ),
  );
}

Widget leftDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: <Widget>[
        DrawerHeader(
          child: Center(
            child: Text(
              'Shutovs App',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.lightGreen,
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_circle_outlined),
          title: Text('Профиль'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserProfileScreen()));
          },
        ),
        ListTile(
          leading: Icon(Icons.people_outline_outlined),
          title: Text('Пользователи'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OtherUsersScreen()));
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Выход'),
          onTap: () async {
            await removeTokenFromStorage();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => new LogInScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    ),
  );
}

