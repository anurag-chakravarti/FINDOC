import '../entities/picsum_image.dart';

abstract class GalleryRepository {
  Future<List<PicsumImage>> fetchImages({int limit = 10});
}
