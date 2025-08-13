import '../entities/picsum_image.dart';
import '../repositories/gallery_repository.dart';

class FetchImagesUseCase {
  final GalleryRepository repo;
  FetchImagesUseCase(this.repo);

  Future<List<PicsumImage>> call({int limit = 10}) {
    return repo.fetchImages(limit: limit);
  }
}