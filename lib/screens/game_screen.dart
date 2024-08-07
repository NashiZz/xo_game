import 'package:flutter/material.dart';
import 'package:xo_game/models/xo_model.dart';
import 'package:xo_game/screens/home_screen.dart';
import 'package:xo_game/screens/select_board.dart';
import 'package:xo_game/screens/select_player.dart';

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
  int _playerWins = 0;
  int _aiWins = 0;

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

  @override
  void dispose() {
    _playerWins = 0;
    _aiWins = 0;
    super.dispose();
  }

  void _handleTap(int row, int col) {
    if (_game.currentPlayer == widget.player && _game.makeMove(row, col)) {
      setState(() {});
      if (_game.winner.isNotEmpty) {
        if (_game.winner != 'Draw') {
          _winningCells = _game.getWinningCells(_game.winner);
        }
        _updateWinCounts();
        _showEndGameDialog();
      } else {
        _game.aiMove();
        setState(() {});
        if (_game.winner.isNotEmpty) {
          if (_game.winner != 'Draw') {
            _winningCells = _game.getWinningCells(_game.winner);
          }
          _updateWinCounts();
          _showEndGameDialog();
        }
      }
    }
  }

  void _updateWinCounts() {
    if (_game.winner == widget.player) {
      _playerWins++;
    } else if (_game.winner == _aiPlayer) {
      _aiWins++;
      print('AI Wins: $_aiWins');
      print('Winning Cells: $_winningCells');
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              _game.winner == 'Draw'
                  ? 'It\'s a Draw!'
                  : 'Winner: ${_game.winner}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _restartGame();
                },
                child: Text(
                  'Play Again',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.indigo.shade400,
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Main Menu',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.indigo.shade400,
                  ),
                ),
              ),
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
          backgroundColor: Colors.white,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double boardSize = constraints.maxWidth * 0.9;
            double cellSize = boardSize / _game.size;
            double textSize = cellSize * 0.6;

            Color userColor = widget.player == 'X'
                ? Colors.blue.shade700
                : Colors.lightBlue.shade500;
            Color aiColor = _aiPlayer == 'X'
                ? Colors.blue.shade700
                : Colors.lightBlue.shade500;

            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Column for Player
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 70, 0, 0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: userColor, width: 4),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 35,
                                  color: userColor,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Player ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade700)),
                                  Text(widget.player,
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.blue.shade700)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Column for AI
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 70, 30, 0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('AI ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightBlue.shade500)),
                                  Text(_aiPlayer,
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.lightBlue.shade500)),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: aiColor, width: 4),
                                ),
                                child: Icon(
                                  Icons.android_rounded,
                                  size: 35,
                                  color: aiColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Center for Score
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "$_playerWins",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            Text(
                              " : $_aiWins",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue.shade500),
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
                        child: Table(
                          border: const TableBorder(
                            horizontalInside:
                                BorderSide(color: Colors.grey, width: 2),
                            verticalInside:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          children: List.generate(_game.size, (row) {
                            return TableRow(
                              children: List.generate(_game.size, (col) {
                                bool isWinningCell = _winningCells.any(
                                    (cell) => cell[0] == row && cell[1] == col);
                                String cellContent = _game.board[row][col];
                                Color cellColor = isWinningCell
                                    ? (cellContent == 'X'
                                        ? Colors.blue.shade700
                                        : Colors.lightBlue.shade500)
                                    : Colors.transparent;
                                Color textColor = isWinningCell
                                    ? Colors.white
                                    : (cellContent == 'X'
                                        ? Colors.blue.shade700
                                        : Colors.lightBlue.shade500);

                                return GestureDetector(
                                  onTap: () {
                                    _handleTap(row, col);
                                  },
                                  child: Container(
                                    height: cellSize,
                                    width: cellSize,
                                    color: cellColor,
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
                              }),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  // Bottom buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 60, 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back to Main Screen Button
                        ElevatedButton(
                          onPressed: () {
                            _showNavigationDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.indigo.shade500,
                            padding: const EdgeInsets.all(15),
                          ),
                          child: const Icon(
                            Icons.settings,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        // Restart Game Button
                        ElevatedButton(
                          onPressed: _restartGame,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.indigo.shade500,
                            padding: const EdgeInsets.all(15),
                          ),
                          child: const Icon(
                            Icons.refresh,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showNavigationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'XO Game',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
          content: Text(
            'Choose an option',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade400,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectPlayerScreen(
                            boardSize: _game.size,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        Text(
                          'Back Select Player',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectBoardSizeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.apps_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        Text(
                          'Back Select Board Size',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        Text(
                          'Back to Home',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
