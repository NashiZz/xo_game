import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xo_game/screens/replay_screen.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getGamesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final gameDates = <String, Map<int, List<DocumentSnapshot>>>{};
          final games = snapshot.data!.docs;

          // จัดกลุ่มข้อมูลตามวันที่และขนาดตาราง
          for (var game in games) {
            final timestamp = (game['timestamp'] as Timestamp).toDate();
            final formattedDate =
                DateFormat('d MMM yyyy', 'th_TH').format(timestamp);
            final boardSize = (game['board'] as List<dynamic>).length;

            if (!gameDates.containsKey(formattedDate)) {
              gameDates[formattedDate] = {};
            }
            if (!gameDates[formattedDate]!.containsKey(boardSize)) {
              gameDates[formattedDate]![boardSize] = [];
            }
            gameDates[formattedDate]![boardSize]!.add(game);
          }

          return ListView(
            children: gameDates.entries.map((entry) {
              final date = entry.key;
              final sizeGroups = entry.value;

              return ExpansionTile(
                title: Text(date),
                children: sizeGroups.entries.map((sizeEntry) {
                  final boardSize = sizeEntry.key;
                  final games = sizeEntry.value;

                  return ExpansionTile(
                    title: Text('Board Size: $boardSize'),
                    children: games.map((game) {
                      final board = (game['board'] as List<dynamic>)
                          .map((row) => (row as String).split(',').toList())
                          .toList();
                      final winner = game['winner'];
                      final winnertype = game['winnerType'];
                      final timestamp =
                          (game['timestamp'] as Timestamp).toDate();

                      final winningCells =
                          (game['winningCells'] as List<dynamic>)
                              .map((cell) => (cell as String)
                                  .split(',')
                                  .map(int.parse)
                                  .toList())
                              .toList();

                      return ListTile(
                        title: Text('Winner: $winnertype ($winner)'),
                        subtitle: Text(
                            'Played on: ${DateFormat('d MMM yyyy', 'th_TH').format(timestamp)}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReplayScreen(
                                board: board,
                                winner: winner,
                                winnertype: winnertype,
                                winningCells: winningCells,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> _getGamesStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('history')
          .doc(currentUser.uid)
          .collection('games')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return Stream.empty();
    }
  }
}
