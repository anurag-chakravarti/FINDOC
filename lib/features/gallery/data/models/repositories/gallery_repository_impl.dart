import '../../../domain/entities/picsum_image.dart';
import '../../../domain/repositories/gallery_repository.dart';
import '../../datasources/picsum_remote_ds.dart';


class GalleryRepositoryImpl implements GalleryRepository {
  final PicsumRemoteDataSource remote;
  GalleryRepositoryImpl(this.remote);

  @override
  Future<List<PicsumImage>> fetchImages({int limit = 10}) async {
    final list = await remote.fetchList(limit: limit);
    return list.map((j) {
      final w = int.tryParse('${j['width']}') ?? 0;
      final h = int.tryParse('${j['height']}') ?? 0;
      return PicsumImage(
        id: '${j['id']}',
        author: j['author'] ?? '',
        width: w,
        height: h,
        pageUrl: j['url'] ?? '',
        imageUrl: j['download_url'] ?? '',
      );
    }).toList();
  }
}