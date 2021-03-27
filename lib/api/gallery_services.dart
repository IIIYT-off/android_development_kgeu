
import 'package:dio/dio.dart';
import 'package:trp_shut_off/api/request/api_gallery_request.dart';
import 'package:trp_shut_off/globals.dart' as globals;

class GalleryServices {

  final Dio _dio = Dio(
    BaseOptions(baseUrl: globals.baseURL),
  );

  Future getGallery() async {
    final response = await _dio.get(
      '',
    );
    print(response.statusCode);
    return response;
  }

  Future uploadImage(FormData body) async {
    final response = await _dio.post(
      'send/',
      data: body,
    );
    print(response.statusCode);
    return response;

  }

}