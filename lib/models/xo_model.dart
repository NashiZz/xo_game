import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class XOGame {
  int size;
  List<List<String>> board;
  String currentPlayer;
  String winner;
  String player; // เพิ่มตัวแปรสำหรับเก็บข้อมูลผู้เล่น
  String difficulty;

  XOGame(this.size, this.player)
      : board = List.generate(size, (_) => List.filled(size, '')),
        currentPlayer = 'X',
        winner = '',
        difficulty = size == 3 ? 'hard' : 'medium';

  bool makeMove(int row, int col) {
    if (board[row][col] == '' && winner == '') {
      board[row][col] = currentPlayer;
      if (checkWinner(row, col)) {
        winner = currentPlayer;
        _saveGameToFirestore(); // บันทึกข้อมูลเกมเมื่อมีผู้ชนะ
      } else if (isDraw()) {
        winner = 'Draw';
        _saveGameToFirestore(); // บันทึกข้อมูลเกมเมื่อเสมอ
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
      return true;
    }
    return false;
  }

  bool checkWinner(int row, int col) {
    // Check row
    if (board[row].every((cell) => cell == currentPlayer)) {
      return true;
    }

    // Check column
    if (board.every((row) => row[col] == currentPlayer)) {
      return true;
    }

    // Check diagonals
    if (row == col &&
        List.generate(size, (index) => board[index][index])
            .every((cell) => cell == currentPlayer)) {
      return true;
    }

    if (row + col == size - 1 &&
        List.generate(size, (index) => board[index][size - 1 - index])
            .every((cell) => cell == currentPlayer)) {
      return true;
    }

    return false;
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

  void _easyMove() {
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
          if (checkWinner(row, col)) {
            makeMove(row, col);
            return;
          }
          board[row][col] = '';
        }
      }
    }
    _easyMove();
  }

  void _hardMove() {
    int bestScore = -999;
    int bestRow = 0;
    int bestCol = 0;

    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (board[row][col] == '') {
          board[row][col] = currentPlayer;
          int score = minimax(board, 0, false);
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

  int minimax(List<List<String>> board, int depth, bool isMaximizing) {
    if (checkWinnerBoard('X')) return -1;
    if (checkWinnerBoard('O')) return 1;
    if (isDraw()) return 0;

    if (isMaximizing) {
      int bestScore = -999;
      for (int row = 0; row < size; row++) {
        for (int col = 0; col < size; col++) {
          if (board[row][col] == '') {
            board[row][col] = 'O';
            int score = minimax(board, depth + 1, false);
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
            int score = minimax(board, depth + 1, true);
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


  // ฟังก์ชันบันทึกข้อมูลเกมลง Firestore
  void _saveGameToFirestore() async {
    final gameRef = FirebaseFirestore.instance.collection('games').doc();
    String winnerType;

    // กำหนด winnerType ตามผู้ชนะ
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
        'winnerType': winnerType,  // เพิ่มฟิลด์ winnerType
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving game to Firestore: $e');
    }
  }
}
