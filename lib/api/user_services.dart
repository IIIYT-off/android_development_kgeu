import 'package:dio/dio.dart';
import 'package:trp_shut_off/api/request/api_user_requests.dart';
import 'package:trp_shut_off/globals.dart' as globals;


class UserServices{
  final Dio _dio = Dio(
    BaseOptions(baseUrl: globals.baseURL),
  );

  Future getUserData(UserRequestsBody body) async {
    final response = await _dio.post(
      'getuser/',
      data: body.toApi(),
    );
    print(response.statusCode);
    return response;
  }

  Future getUsersData(UserRequestsBody body) async {
    final response = await _dio.post(
      'listusers/',
      data: body.toApi(),
    );
    print(response.statusCode);
    return response;
  }

  Future updateUserData(UpdateUserDataRequestBody body) async {
    final response = await _dio.post(
      'userupdate/',
      data: body.toApi(),
    );
    print(response.statusCode);
    return response;
  }

  Future updateUserImage(UpdateUserImageRequestsBody body) async {
    final response = await _dio.post(
      'updateuserimage/',
      data: body.toApi(),
    );
    print(response.statusCode);
    return response;
  }

  Future getOtherUserData(OtherUserRequestsBody body) async {
    final response = await _dio.post(
      'getuserwithid/',
      data: body.toApi(),
    );
    print(response.statusCode);
    return response;
  }

  Future getDialogData(GetDialogRequestBody body) async {
    final response = await _dio.post(
      'getdialog/',
      data: body.toApi(),
    );
    print(response.statusCode);
    return response;
  }

  Future sendMessage(SendMessageRequestBody body) async {
    final response = await _dio.post(
      'sendmessage/',
      data: body.toApi(),
    );
    print(response.statusCode);
    return response;
  }

}



