// ignore_for_file: avoid_print

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
        difficulty = 'hard';

  bool makeMove(int row, int col) {
    if (board[row][col] == '' && winner == '') {
      board[row][col] = currentPlayer;
      if (hasWinner(currentPlayer)) {
        winner = currentPlayer;
        winningCells = getWinningCells(currentPlayer);
        _saveGameToFirestore();
        winningCells.clear();
      } else if (isDraw()) {
        winner = 'Draw';
        _saveGameToFirestore();
        winningCells.clear();
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
      return true;
    }
    return false;
  }

  List<List<int>> getWinningCells(String player) {
    List<List<int>> cells = [];
    if (hasWinner(player)) {
      for (int row = 0; row < size; row++) {
        if (hasWinningLine(board[row], player)) {
          for (int col = 0; col < size; col++) {
            cells.add([row, col]);
          }
          return cells;
        }
      }
      for (int col = 0; col < size; col++) {
        if (hasWinningLine(board.map((row) => row[col]).toList(), player)) {
          for (int row = 0; row < size; row++) {
            cells.add([row, col]);
          }
          return cells;
        }
      }
      if (hasWinningLine(List.generate(size, (i) => board[i][i]), player)) {
        for (int i = 0; i < size; i++) {
          cells.add([i, i]);
        }
        return cells;
      }
      if (hasWinningLine(
          List.generate(size, (i) => board[i][size - 1 - i]), player)) {
        for (int i = 0; i < size; i++) {
          cells.add([i, size - 1 - i]);
        }
        return cells;
      }
    }
    return cells;
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

  void _hardMove() {
    Random rand = Random();

    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (board[row][col] == '') {
          board[row][col] = currentPlayer;
          if (hasWinner(currentPlayer)) {
            makeMove(row, col);
            if (hasWinner(currentPlayer)) {
              winner = currentPlayer;
            }
            return;
          }
          board[row][col] = '';
        }
      }
    }

    String opponent = currentPlayer == 'X' ? 'O' : 'X';
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (board[row][col] == '') {
          board[row][col] = opponent;
          if (hasWinner(opponent)) {
            board[row][col] = '';
            makeMove(row, col);
            return;
          }
          board[row][col] = '';
        }
      }
    }

    if (rand.nextDouble() < 0.3) {
      _easyMoveRandom();
    } else {
      _easyMoveRandom();
    }

    if (hasWinner(currentPlayer)) {
      winner = currentPlayer;
    }
  }

  bool hasWinningLine(List<String> line, String player) {
    return line.every((cell) => cell == player);
  }

  bool hasWinner(String player) {
    for (int row = 0; row < size; row++) {
      if (hasWinningLine(board[row], player)) {
        return true;
      }
    }
    for (int col = 0; col < size; col++) {
      if (hasWinningLine(board.map((row) => row[col]).toList(), player)) {
        return true;
      }
    }
    if (hasWinningLine(List.generate(size, (i) => board[i][i]), player)) {
      return true;
    }
    if (hasWinningLine(
        List.generate(size, (i) => board[i][size - 1 - i]), player)) {
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
