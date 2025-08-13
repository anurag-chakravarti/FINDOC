import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/network/http_client.dart';
import 'core/storage/prefs.dart';
import 'features/auth/presentation/screens/login_page.dart';
import 'features/gallery/data/datasources/picsum_remote_ds.dart';
import 'features/gallery/data/models/repositories/gallery_repository_impl.dart';
import 'features/gallery/domain/usecases/fetch_images_usecase.dart';
import 'features/gallery/presentation/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init(); // SharedPreferences
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    //  DI for the Gallery feature
    final http = AppHttpClient();
    final remote = PicsumRemoteDataSource(http);
    final repo = GalleryRepositoryImpl(remote);
    final fetchImages = FetchImagesUseCase(repo);

    final base = ThemeData.light().textTheme.apply(bodyColor: Colors.black);

    final start = Prefs.hasToken
        ? HomePage(fetchImages: fetchImages)
        : const LoginPage();

    return MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: fetchImages)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Findoc Assignment',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF317773)),
          useMaterial3: true,
          textTheme: GoogleFonts.montserratTextTheme(base),
        ),
        home: start,
        routes: {HomePage.route: (_) => HomePage(fetchImages: fetchImages)},
      ),
    );
  }
}
