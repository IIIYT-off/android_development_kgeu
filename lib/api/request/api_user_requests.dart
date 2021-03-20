
import 'package:flutter/material.dart';

class LogRegRequestBody {
  String login;
  String password;


  LogRegRequestBody({
    @required this.login,
    @required this.password,
  });

  Map<String, dynamic> toApi() {
    return {
      'login': login,
      'password': password,
    };
  }
}

class UserRequestsBody {

  String token;

  UserRequestsBody({
    @required this.token
});

  Map<String, dynamic> toApi() {
    return {
      'token': token,
    };
  }

}

class OtherUserRequestsBody {

  String token;
  int id;

  OtherUserRequestsBody({
    @required this.token,
    @required this.id
  });

  Map<String, dynamic> toApi() {
    return {
      'token': token,
      'userid': id,
    };
  }

}



class UpdateUserDataRequestBody {
  String token;
  String user;
  String family;
  String birthday;
  String phoneNumber;
  String vk;
  String skype;

  UpdateUserDataRequestBody({
    @required this.token,
    @required this.user,
    @required this.family,
    @required this.birthday,
    @required this.phoneNumber,
    @required this.vk,
    @required this.skype,
  });

  Map<String, dynamic> toApi() {
    return {
      'token': token,
      'nameuser': user,
      'family': family,
      'birthday': birthday,
      'phonenumber': phoneNumber,
      'vk': vk,
      'skype': skype,
    };
  }

}

class UpdateUserImageRequestsBody {

  String token;
  String image;

  UpdateUserImageRequestsBody({
    @required this.token,
    @required this.image
  });

  Map<String, dynamic> toApi() {
    return {
      'token': token,
      'img': image,
    };
  }

}

class GetDialogRequestBody {

  String token;
  int receiver;

  GetDialogRequestBody({
    @required this.token,
    @required this.receiver
  });

  Map<String, dynamic> toApi() {
    return {
      'token': token,
      'userto': receiver,
    };
  }

}

class SendMessageRequestBody {

  String token;
  int receiver;
  String message;

  SendMessageRequestBody({
    @required this.token,
    @required this.receiver,
    @required this.message,
  });

  Map<String, dynamic> toApi() {
    return {
      'token': token,
      'userto': receiver,
      'message': message,
    };
  }

}