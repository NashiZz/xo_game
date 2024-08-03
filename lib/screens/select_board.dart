import 'package:flutter/material.dart';
import 'package:xo_game/screens/select_player.dart';

class SelectBoardSizeScreen extends StatelessWidget {
  const SelectBoardSizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: '3');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Board'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter Board Size',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  int size = int.parse(controller.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SelectPlayerScreen(boardSize: size,),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
