
import 'package:trp_shut_off/api/models/api_gallery_models.dart';
import 'package:trp_shut_off/data/model.dart';

class GalleryMapper {
  static InternetImage fromMap(ApiGetGallery result) {
    return InternetImage(image: result.image);
  }
}