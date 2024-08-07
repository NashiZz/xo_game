import 'package:flutter/material.dart';
import 'package:xo_game/screens/game_screen.dart';

class SelectPlayerScreen extends StatefulWidget {
  final int boardSize;

  const SelectPlayerScreen({super.key, required this.boardSize});

  @override
  _SelectPlayerScreenState createState() => _SelectPlayerScreenState();
}

class _SelectPlayerScreenState extends State<SelectPlayerScreen> {
  String? selectedPlayer;

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
              'Choose your side',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlayerButton('X'),
                const SizedBox(width: 40),
                _buildPlayerButton('O'),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (selectedPlayer != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(
                        boardSize: widget.boardSize,
                        player: selectedPlayer!,
                      ),
                    ),
                  );
                } else {
                  _showSelectionError();
                }
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerButton(String player) {
    bool isSelected = selectedPlayer == player;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlayer = player;
        });
      },
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.transparent, // Background color is transparent
            border: Border.all(
              color: isSelected ? Colors.red : Colors.transparent,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              player,
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: player == 'X' ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSelectionError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Player'),
          content: const Text('Please choose X or O before continuing'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
