import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/storage/prefs.dart';
import '../../../auth/presentation/screens/login_page.dart';
import '../../domain/usecases/fetch_images_usecase.dart';
import '../bloc/gallery_bloc.dart';

class HomePage extends StatelessWidget {
  static const route = '/home';
  final FetchImagesUseCase fetchImages;
  const HomePage({super.key, required this.fetchImages});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GalleryBloc(fetchImages)..add(GalleryRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              tooltip: 'Logout',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await Prefs.clearToken();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                      (_) => false,
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<GalleryBloc, GalleryState>(
          builder: (context, state) {
            switch (state.status) {
              case GalleryStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case GalleryStatus.failure:
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: ${state.error}'),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () =>
                            context.read<GalleryBloc>().add(GalleryRequested()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              case GalleryStatus.success:
                final items = state.data;
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final it = items[i];
                    final screenW = MediaQuery.of(context).size.width;
                    final aspect = it.width == 0 ? 1.5 : it.width / it.height;
                    final imgH = screenW / aspect; // width-match; dynamic height

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: double.infinity,
                              height: imgH,
                              child: Image.network(
                                it.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (c, w, p) => p == null
                                    ? w
                                    : Container(
                                  color: Colors.black12,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.black12,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Photo by ${it.author}',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            it.pageUrl,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              case GalleryStatus.initial:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}