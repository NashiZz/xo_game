import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:xo_game/screens/replay_screen.dart'; // เพิ่มการนำเข้าแพ็คเกจ intl

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('games').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final games = snapshot.data!.docs;

          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              // แปลง List<dynamic> เป็น List<List<String>>
              final board = (game['board'] as List<dynamic>)
                  .map((row) => (row as String).split(',').toList())
                  .toList();
              final winner = game['winner'];
              final winnertype = game['winnerType'];
              final timestamp = (game['timestamp'] as Timestamp).toDate();

              // ใช้ DateFormat ในการจัดรูปแบบวันที่
              final formattedDate =
                  DateFormat('d MMM yyyy', 'th_TH').format(timestamp);

              return ListTile(
                title: Text('Winner: $winnertype ($winner)'),
                subtitle: Text('Played on: $formattedDate'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReplayScreen(
                        board: board,
                        winner: winner,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
