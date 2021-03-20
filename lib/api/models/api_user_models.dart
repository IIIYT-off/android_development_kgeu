class ApiLogRegModel {
  String login;
  String token;

  ApiLogRegModel({this.login, this.token});

  ApiLogRegModel.fromJson(Map<String, dynamic> json)
      : login = json['login'],
        token = json['token'];
}

class ApiUserDataModel {
  int id;
  String image;
  String family;
  String vk;
  String birthday;
  String phoneNumber;
  String user;
  String skype;
  String login;

  ApiUserDataModel(
      {this.vk,
      this.user,
      this.skype,
      this.phoneNumber,
      this.image,
      this.id,
      this.family,
      this.login,
      this.birthday});

  ApiUserDataModel.fromJson(Map<String, dynamic> json)
      : vk = json['vk'] == null ? '' : json['vk'],
        skype = json['skype'] == null ? '' : json['skype'],
        phoneNumber = json['phonenumber'] == null ? '' : json['phonenumber'],
        image = json['img'] == null ? '' : json['img'],
        id = json['id_user'],
        family = json['family'] == null ? '' : json['family'],
        birthday = json['birthday'] == null ? '' : json['birthday'],
        login = json['login'] == null ? '' : json['login'],
        user = json['user'] == null ? '' : json['user'];
}

class ApiOtherUserDataModel {
  int id;
  String image;
  String family;
  String vk;
  String birthday;
  String phoneNumber;
  String user;
  String skype;

  ApiOtherUserDataModel(
      {this.vk,
      this.user,
      this.skype,
      this.phoneNumber,
      this.image,
      this.id,
      this.family,
      this.birthday});

  ApiOtherUserDataModel.fromJson(Map<String, dynamic> json)
      : vk = json['vk'] == null ? '' : json['vk'],
        skype = json['skype'] == null ? '' : json['skype'],
        phoneNumber = json['phoneNumber'] == null ? '' : json['phoneNumber'],
        image = json['img'] == null ? '' : json['img'],
        id = json['id'],
        family = json['family'] == null ? '' : json['family'],
        birthday = json['birthday'] == null ? '' : json['birthday'],
        user = json['user'] == null ? '' : json['user'];
}

class ApiGetDialog {
  int sender;
  int receiver;
  String message;
  String datetime;

  ApiGetDialog({this.message, this.datetime, this.receiver, this.sender});

  ApiGetDialog.fromJson(Map<String, dynamic> json)
      : receiver = json['to_id'],
        message = json['message'],
        datetime = json['datetime'],
        sender = json['from_id'];
}
