
import 'package:flutter/material.dart';

class UploadImageRequestBody {
  String image;


  UploadImageRequestBody({
    @required this.image,
  });

  Map<String, dynamic> toApi() {
    return {
      'image': image,
    };
  }
}