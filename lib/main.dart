import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:xo_game/firebase_options.dart';
import 'package:xo_game/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('th_TH');
  await _signInAnonymously();
  runApp(const MyApp());
}

Future<void> _signInAnonymously() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print('Signed in with temporary account.');
      await _createUserDocument(FirebaseAuth.instance.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error: ${e.message}");
      }
    }
  } else {
    print('Already signed in with anonymous account.');
    await _createUserDocument(currentUser.uid);
  }
}

Future<void> _createUserDocument(String uid) async {
  final userDocRef = FirebaseFirestore.instance.collection('history').doc(uid);

  // ตรวจสอบว่าเอกสาร history มีอยู่แล้วหรือไม่
  final userDocSnapshot = await userDocRef.get();
  if (!userDocSnapshot.exists) {
    // หากเอกสาร history ยังไม่ถูกสร้าง
    await userDocRef.set({});
    print('User document created for UID: $uid');
  } else {
    print('User document already exists for UID: $uid');
  }

  // สร้าง collection games ถ้าหากยังไม่มี
  final gamesCollection = userDocRef.collection('games');

  // ตรวจสอบว่า collection games มีเอกสารอยู่แล้วหรือไม่
  final gamesQuerySnapshot = await gamesCollection.limit(1).get();
  if (gamesQuerySnapshot.docs.isEmpty) {
    print('Collection games is empty for UID: $uid');
  } else {
    print('Collection games already has documents for UID: $uid');
  }
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

// Example function to save game data to Firestore
Future<void> saveGameToFirestore(List<List<String>> board, String winner,
    String winnerType, List<List<int>> winningCells) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    String uid = currentUser.uid;
    final gameData = {
      'board': board.map((row) => row.join(',')).toList(),
      'winner': winner,
      'winnerType': winnerType,
      'winningCells': winningCells.map((cell) => cell.join(',')).toList(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    // บันทึกข้อมูลเกมใน collection games ของผู้ใช้
    await FirebaseFirestore.instance
        .collection('history')
        .doc(uid)
        .collection('games')
        .add(gameData);
    print('Game data saved for UID: $uid');
  }
}
