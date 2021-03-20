class UserDataModel {
  int id;
  String image;
  String family;
  String vk;
  String birthday;
  String phoneNumber;
  String user;
  String login;
  String skype;

  UserDataModel(
      {this.birthday,
      this.family,
      this.id,
      this.image,
      this.phoneNumber,
      this.skype,
      this.user,
      this.login,
      this.vk});
}

class LogRegDataModel {
  String login;
  String token;

  LogRegDataModel({this.token, this.login});
}

class DialogDataModel {
  String message;
  String datetime;
  int receiver;
  int sender;

  DialogDataModel({this.message, this.datetime, this.sender, this.receiver});
}
