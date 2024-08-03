import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:xo_game/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('th_TH');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XO Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // Set Font
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryTextTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
