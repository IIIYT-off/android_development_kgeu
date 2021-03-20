import 'package:trp_shut_off/api/models/api_user_models.dart';
import 'package:trp_shut_off/data/model.dart';

class RegLogMapper {
  static LogRegDataModel fromMap(ApiLogRegModel result) {
    return LogRegDataModel(login: result.login, token: result.token);
  }
}

class UserDataMapper {
  static UserDataModel fromMap(ApiUserDataModel result) {
    return UserDataModel(
        id: result.id,
        image: result.image,
        family: result.family,
        vk: result.vk,
        birthday: result.birthday,
        phoneNumber: result.phoneNumber,
        user: result.user,
        login: result.login,
        skype: result.skype);
  }
}

class OtherUserDataMapper {
  static UserDataModel fromMap(ApiOtherUserDataModel result) {
    return UserDataModel(
        id: result.id,
        image: result.image,
        family: result.family,
        vk: result.vk,
        birthday: result.birthday,
        phoneNumber: result.phoneNumber,
        user: result.user,
        skype: result.skype);
  }
}

class GetDialogDataMapper {
  static DialogDataModel fromMap(ApiGetDialog result) {
    return DialogDataModel(
      receiver: result.receiver,
      sender: result.sender,
      message: result.message,
      datetime: result.datetime
    );
  }
}
