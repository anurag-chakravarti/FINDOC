part of 'gallery_bloc.dart';

enum GalleryStatus { initial, loading, success, failure }

class GalleryState extends Equatable {
  final GalleryStatus status;
  final List<PicsumImage> data;
  final String? error;

  const GalleryState({required this.status, this.data = const [], this.error});

  const GalleryState.initial() : this(status: GalleryStatus.initial);

  GalleryState copyWith({
    GalleryStatus? status,
    List<PicsumImage>? data,
    String? error,
  }) => GalleryState(
    status: status ?? this.status,
    data: data ?? this.data,
    error: error ?? this.error,
  );

  @override
  List<Object?> get props => [status, data, error];
}
