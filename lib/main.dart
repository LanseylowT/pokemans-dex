import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemansdex/pages/home_page.dart';
import 'package:pokemansdex/service/database_services.dart';
import 'package:pokemansdex/service/http_service.dart';

void main() async {
  await _setupServices();
  runApp(const MyApp());
}

// Register Http service so that we can access it
Future<void> _setupServices() async {
  GetIt.instance.registerSingleton<HTTPService>(HTTPService());
  GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PokemansDex',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
          textTheme: GoogleFonts.quattrocentoSansTextTheme(),
        ),
        home: HomePage(),
      ),
    );
  }
}
