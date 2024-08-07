import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class XOGame {
  int size;
  List<List<String>> board;
  String currentPlayer;
  String winner;
  String player;
  String difficulty;
  List<List<int>> winningCells = [];

  XOGame(this.size, this.player)
      : board = List.generate(size, (_) => List.filled(size, '')),
        currentPlayer = 'X',
        winner = '',
        difficulty = size == 3 ? 'hard' : 'medium';

  bool makeMove(int row, int col) {
    if (board[row][col] == '' && winner == '') {
      board[row][col] = currentPlayer;
      if (checkWinnerBoard(currentPlayer)) {
        winner = currentPlayer;
        getWinningCells();
        _saveGameToFirestore();
      } else if (isDraw()) {
        winner = 'Draw';
        _saveGameToFirestore();
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
      return true;
    }
    return false;
  }

  List<List<int>> getWinningCells() {
    winningCells.clear();

    // Check rows
    for (int row = 0; row < size; row++) {
      if (board[row].every((cell) => cell == currentPlayer)) {
        for (int col = 0; col < size; col++) {
          winningCells.add([row, col]);
        }
        return winningCells;
      }
    }

    // Check columns
    for (int col = 0; col < size; col++) {
      if (board.every((row) => row[col] == currentPlayer)) {
        for (int row = 0; row < size; row++) {
          winningCells.add([row, col]);
        }
        return winningCells;
      }
    }

    // Check diagonals
    if (List.generate(size, (index) => board[index][index])
        .every((cell) => cell == currentPlayer)) {
      for (int i = 0; i < size; i++) {
        winningCells.add([i, i]);
      }
      return winningCells;
    }

    if (List.generate(size, (index) => board[index][size - 1 - index])
        .every((cell) => cell == currentPlayer)) {
      for (int i = 0; i < size; i++) {
        winningCells.add([i, size - 1 - i]);
      }
      return winningCells;
    }

    return winningCells;
  }

  bool isDraw() {
    for (var row in board) {
      for (var cell in row) {
        if (cell == '') {
          return false;
        }
      }
    }
    return true;
  }

  void reset() {
    board = List.generate(size, (_) => List.filled(size, ''));
    currentPlayer = 'X';
    winner = '';
  }

  void aiMove() {
    if (winner != '') return;

    switch (difficulty) {
      case 'medium':
        _mediumMove();
        break;
      case 'hard':
        _hardMove();
        break;
    }
  }

  void _easyMoveRandom() {
    Random rand = Random();
    int row, col;
    do {
      row = rand.nextInt(size);
      col = rand.nextInt(size);
    } while (board[row][col] != '');

    makeMove(row, col);
  }

  void _mediumMove() {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (board[row][col] == '') {
          board[row][col] = currentPlayer;
          if (checkWinnerBoard(currentPlayer)) {
            makeMove(row, col);
            return;
          }
          board[row][col] = '';

          String opponent = currentPlayer == 'X' ? 'O' : 'X';
          board[row][col] = opponent;
          if (checkWinnerBoard(opponent)) {
            board[row][col] = '';
            makeMove(row, col);
            return;
          }
          board[row][col] = '';
        }
      }
    }
    _easyMoveRandom();
  }

  void _hardMove() {
    int bestScore = -999;
    int bestRow = 0;
    int bestCol = 0;

    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (board[row][col] == '') {
          board[row][col] = currentPlayer;
          int score = minimax(board, 0, false, true);
          board[row][col] = '';
          if (score > bestScore) {
            bestScore = score;
            bestRow = row;
            bestCol = col;
          }
        }
      }
    }
    makeMove(bestRow, bestCol);
  }

  int minimax(List<List<String>> board, int depth, bool isMaximizing,
      bool isImperfect) {
    if (checkWinnerBoard('X')) return -1;
    if (checkWinnerBoard('O')) return 1;
    if (isDraw()) return 0;

    if (isImperfect && depth >= 4) {
      Random rand = Random();
      return rand.nextInt(3) - 1;
    }

    if (isMaximizing) {
      int bestScore = -999;
      for (int row = 0; row < size; row++) {
        for (int col = 0; col < size; col++) {
          if (board[row][col] == '') {
            board[row][col] = 'O';
            int score = minimax(board, depth + 1, false, isImperfect);
            board[row][col] = '';
            bestScore = max(score, bestScore);
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 999;
      for (int row = 0; row < size; row++) {
        for (int col = 0; col < size; col++) {
          if (board[row][col] == '') {
            board[row][col] = 'X';
            int score = minimax(board, depth + 1, true, isImperfect);
            board[row][col] = '';
            bestScore = min(score, bestScore);
          }
        }
      }
      return bestScore;
    }
  }

  bool checkWinnerBoard(String player) {
    for (int row = 0; row < size; row++) {
      if (board[row].every((cell) => cell == player)) {
        return true;
      }
    }
    for (int col = 0; col < size; col++) {
      if (board.every((r) => r[col] == player)) {
        return true;
      }
    }
    if (List.generate(size, (i) => board[i][i])
        .every((cell) => cell == player)) {
      return true;
    }
    if (List.generate(size, (i) => board[i][size - 1 - i])
        .every((cell) => cell == player)) {
      return true;
    }
    return false;
  }

  void _saveGameToFirestore() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      final gameRef = FirebaseFirestore.instance
          .collection('history')
          .doc(uid) 
          .collection('games') 
          .doc(); 

      String winnerType;

      if (winner == 'Draw') {
        winnerType = 'Draw';
      } else if (winner == 'X') {
        winnerType = player == 'X' ? 'User' : 'AI';
      } else if (winner == 'O') {
        winnerType = player == 'O' ? 'User' : 'AI';
      } else {
        winnerType = 'Unknown';
      }

      try {
        await gameRef.set({
          'size': size,
          'board': board.map((row) => row.join(',')).toList(),
          'winner': winner,
          'winnerType': winnerType,
          'timestamp': FieldValue.serverTimestamp(),
          'winningCells': winningCells.map((cell) => cell.join(',')).toList(),
        });
        print('Game data saved for UID: $uid');
      } catch (e) {
        print('Error saving game to Firestore: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }
}
