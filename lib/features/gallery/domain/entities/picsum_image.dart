import 'package:equatable/equatable.dart';

class PicsumImage extends Equatable {
  final String id;
  final String author;
  final int width;
  final int height;
  final String pageUrl;
  final String imageUrl;

  const PicsumImage({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.pageUrl,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, author, width, height, pageUrl, imageUrl];
}
