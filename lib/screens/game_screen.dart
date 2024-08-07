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
  List<List<int>> _winningCells = [];

  @override
  void initState() {
    super.initState();
    _game = XOGame(widget.boardSize, widget.player); 
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
        _winningCells = _game.getWinningCells();
        _showEndGameDialog();
      } else {
        _game.aiMove();
        setState(() {});
        if (_game.winner.isNotEmpty) {
          _winningCells = _game.getWinningCells(); 
          _showEndGameDialog();
        }
      }
    }
  }

  void _restartGame() {
    setState(() {
      _game.reset();
      _winningCells = [];
      if (widget.player == 'O') {
        _game.currentPlayer = 'X';
        _game.aiMove();
      }
    });
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
                Navigator.of(context).pop();
                _restartGame();
              },
              child: const Text('Play Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pop(); 
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
                constraints.maxWidth * 0.9; 
            double cellSize = boardSize / _game.size;
            double textSize = cellSize * 0.6; 

            Color userColor = widget.player == 'X' ? Colors.blue : Colors.red;
            Color aiColor = _aiPlayer == 'X' ? Colors.blue : Colors.red;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Column for Player
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: userColor, width: 4),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: userColor,
                            ),
                          ),
                          const SizedBox(
                              width: 8.0), 
                          Text('Player (${widget.player})',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      // Column for AI
                      Row(
                        children: [
                          Text('AI ($_aiPlayer)',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(
                              width: 8.0),
                          Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: aiColor, width: 4),
                            ),
                            child: Icon(
                              Icons.computer,
                              size: 35,
                              color: aiColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: boardSize,
                      height: boardSize,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _game.size,
                        ),
                        itemBuilder: (context, index) {
                          int row = index ~/ _game.size;
                          int col = index % _game.size;
                          bool isWinningCell = _winningCells
                              .any((cell) => cell[0] == row && cell[1] == col);
                          String cellContent = _game.board[row][col];
                          Color cellColor = isWinningCell
                              ? (cellContent == 'X' ? Colors.blue : Colors.red)
                              : Colors.white;
                          Color textColor = isWinningCell
                              ? Colors.white
                              : (cellContent == 'X' ? Colors.blue : Colors.red);

                          return GestureDetector(
                            onTap: () {
                              _handleTap(row, col);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
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
                            ),
                          );
                        },
                        itemCount: _game.size * _game.size,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: _restartGame,
                    child: const Text('Restart'),
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
