import 'package:flutter/material.dart';

class ReplayScreen extends StatelessWidget {
  final List<List<String>> board;
  final String winner;
  final String winnertype;
  final List<List<int>> winningCells;

  const ReplayScreen({
    super.key,
    required this.board,
    required this.winner,
    required this.winningCells,
    required this.winnertype,
  });

  @override
  Widget build(BuildContext context) {
    double cellSize = MediaQuery.of(context).size.width / board.length * 0.9;
    double textSize = cellSize * 0.6;

    Color getTextColor(String content, bool isWinningCell) {
      if (isWinningCell) {
        return Colors.white;
      } else {
        return content == 'X'
            ? Colors.blue.shade700
            : Colors.lightBlue.shade500;
      }
    }

    Color getBackgroundColor(String content, bool isWinningCell) {
      if (isWinningCell) {
        return content == 'X'
            ? Colors.blue.shade700
            : Colors.lightBlue.shade500;
      } else {
        return Colors.transparent;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Replay'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
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
                      bool isWinningCell = winningCells
                          .any((cell) => cell[0] == row && cell[1] == col);
                      String cellContent = board[row][col];
                      Color cellColor =
                          getBackgroundColor(cellContent, isWinningCell);
                      Color textColor =
                          getTextColor(cellContent, isWinningCell);

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: cellColor,
                        ),
                        child: Center(
                          child: Text(
                            cellContent,
                            style: TextStyle(
                              fontSize: textSize,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
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
              winner == 'Draw'
                  ? 'It\'s a Draw!'
                  : 'Winner: $winnertype ($winner)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
