part of 'gallery_bloc.dart';

sealed class GalleryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GalleryRequested extends GalleryEvent {}
