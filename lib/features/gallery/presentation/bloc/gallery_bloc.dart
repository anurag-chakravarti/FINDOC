import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/picsum_image.dart';
import '../../domain/usecases/fetch_images_usecase.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final FetchImagesUseCase fetchImagesUseCase;

  GalleryBloc(this.fetchImagesUseCase) : super(const GalleryState.initial()) {
    on<GalleryRequested>((event, emit) async {
      emit(state.copyWith(status: GalleryStatus.loading));
      try {
        final data = await fetchImagesUseCase(limit: 10);
        emit(state.copyWith(status: GalleryStatus.success, data: data));
      } catch (e) {
        emit(
          state.copyWith(status: GalleryStatus.failure, error: e.toString()),
        );
      }
    });
  }
}
