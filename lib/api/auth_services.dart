
import 'package:dio/dio.dart';
import 'package:trp_shut_off/api/request/api_user_requests.dart';
import 'package:trp_shut_off/globals.dart' as globals;

class AuthServices {

  final Dio _dio = Dio(
    BaseOptions(baseUrl: globals.baseURL),
  );

  Future login(LogRegRequestBody body) async {
      final response = await _dio.post(
        'auth/',
        data: body.toApi(),

      );
      print(response.statusCode);
      return response;
  }

  Future register(LogRegRequestBody body) async {
    final response = await _dio.post(
      'register/',
      data: body.toApi(),
    );
    print(response.statusCode);
    return response;

  }

}

