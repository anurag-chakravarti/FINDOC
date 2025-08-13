import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

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
      child: const _HomeScaffold(),
    );
  }
}

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: Text(
          'Home',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await Prefs.clearToken();
              // ignore: use_build_context_synchronously
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
            case GalleryStatus.initial:
            case GalleryStatus.loading:
              return const _ListSkeleton();

            case GalleryStatus.failure:
              return _ErrorRetry(
                message: state.error ?? 'Something went wrong',
                onRetry: () =>
                    context.read<GalleryBloc>().add(GalleryRequested()),
              );

            case GalleryStatus.success:
              final items = state.data;
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<GalleryBloc>().add(GalleryRequested()),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final it = items[i];
                    final screenW = MediaQuery.of(context).size.width;
                    final aspect = (it.width == 0 || it.height == 0)
                        ? 16 / 9
                        : it.width / it.height;
                    final imgH = screenW / aspect;

                    return _AnimatedIn(
                      index: i,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Material(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: imgH,
                                child: CachedNetworkImage(
                                  imageUrl: it.imageUrl,
                                  fit: BoxFit.cover,
                                  cacheKey: 'picsum_${it.id}',
                                  placeholder: (_, __) => Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(color: Colors.white),
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Icon(Icons.broken_image_outlined),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  14,
                                  12,
                                  14,
                                  12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Photo by ${it.author}',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}

// Shimmer
class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Container(height: 180, color: Colors.white),
              Container(height: 60, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// error retry button
class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $message', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

// slide+fade widget
class _AnimatedIn extends StatefulWidget {
  const _AnimatedIn({required this.child, required this.index, super.key});
  final Widget child;
  final int index;

  @override
  State<_AnimatedIn> createState() => _AnimatedInState();
}

class _AnimatedInState extends State<_AnimatedIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
  );
  late final Animation<double> _dy = Tween(
    begin: 12.0,
    end: 0.0,
  ).animate(_curve); // slide up a bit

  @override
  void initState() {
    super.initState();
    final delay = Duration(milliseconds: 60 * (widget.index % 8));
    Future.delayed(delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, _) => Opacity(
        opacity: _curve.value,
        child: Transform.translate(
          offset: Offset(0, _dy.value),
          child: widget.child,
        ),
      ),
    );
  }
}
