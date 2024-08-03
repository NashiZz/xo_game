import 'package:flutter/material.dart';
import 'package:xo_game/screens/game_screen.dart';

class SelectPlayerScreen extends StatelessWidget {
  final int boardSize;

  const SelectPlayerScreen({super.key, required this.boardSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Your Player',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      boardSize: boardSize,
                      player: 'X',
                    ),
                  ),
                );
              },
              child: const Text('Play as X'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      boardSize: boardSize,
                      player: 'O',
                    ),
                  ),
                );
              },
              child: const Text('Play as O'),
            ),
          ],
        ),
      ),
    );
  }
}
