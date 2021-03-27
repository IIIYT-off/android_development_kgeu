
class ApiGetGallery {
  String image;

  ApiGetGallery({this.image});

  ApiGetGallery.fromJson(Map<String, dynamic> json)
      : image = json['img'];
}