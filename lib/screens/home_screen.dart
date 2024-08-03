import 'package:flutter/material.dart';
import 'package:xo_game/screens/history_screen.dart';
import 'package:xo_game/screens/select_board.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('XO Game Home'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 20 : 40,
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/logo_img/logo_game.png',
                  width: isSmallScreen ? 150 : 200,
                  height: isSmallScreen ? 150 : 200,
                ),
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectBoardSizeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 8 : 10,
                      horizontal: isSmallScreen ? 20 : 30,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Play",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 8 : 10,
                      horizontal: isSmallScreen ? 20 : 30,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "History Play",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
