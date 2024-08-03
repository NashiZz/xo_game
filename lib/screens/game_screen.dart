import 'package:flutter/material.dart';
import 'package:xo_game/models/xo_model.dart';

class GameScreen extends StatefulWidget {
  final int boardSize;
  final String player;

  const GameScreen({super.key, required this.boardSize, required this.player});

  @override
  // ignore: library_private_types_in_public_api
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late XOGame _game;
  late String _aiPlayer;

  @override
  void initState() {
    super.initState();
    _game = XOGame(widget.boardSize, widget.player); // ส่งข้อมูลผู้เล่น
    _aiPlayer = widget.player == 'X' ? 'O' : 'X';

    if (widget.player == 'O') {
      _game.currentPlayer = 'X';
      _game.aiMove();
      setState(() {});
    }
  }

  void _handleTap(int row, int col) {
    if (_game.currentPlayer == widget.player && _game.makeMove(row, col)) {
      setState(() {});
      if (_game.winner.isNotEmpty) {
        _showEndGameDialog();
      } else {
        _game.aiMove();
        setState(() {});
        if (_game.winner.isNotEmpty) {
          _showEndGameDialog();
        }
      }
    }
  }

  void _showEndGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_game.winner == 'Draw'
              ? 'It\'s a Draw!'
              : 'Winner: ${_game.winner}'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _game.reset();
                  if (widget.player == 'O') {
                    _game.currentPlayer = 'X';
                    _game.aiMove();
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Restart'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pop(); // This will navigate back to the main screen
              },
              child: const Text('Main Menu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('XO Game'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double boardSize =
                constraints.maxWidth * 0.9; // Adjust size as needed
            double cellSize = boardSize / _game.size;
            double textSize = cellSize * 0.6; // Adjust text size as needed

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.person, size: 48),
                          Text('User (${widget.player})',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.computer, size: 48),
                          Text('AI ($_aiPlayer)',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: boardSize,
                      height: boardSize,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _game.size,
                        ),
                        itemBuilder: (context, index) {
                          int row = index ~/ _game.size;
                          int col = index % _game.size;
                          return GestureDetector(
                            onTap: () {
                              _handleTap(row, col);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: Text(
                                  _game.board[row][col],
                                  style: TextStyle(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _game.size * _game.size,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
