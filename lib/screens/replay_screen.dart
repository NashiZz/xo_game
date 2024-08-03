import 'package:flutter/material.dart';

class ReplayScreen extends StatelessWidget {
  final List<List<String>> board;
  final String winner;

  const ReplayScreen({super.key, required this.board, required this.winner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Replay'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: board.length,
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ board.length;
                      int col = index % board.length;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            board[row][col],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    itemCount: board.length * board.length,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              winner == 'Draw' ? 'It\'s a Draw!' : 'Winner: $winner',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
