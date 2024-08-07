import 'package:flutter/material.dart';
import 'package:xo_game/screens/select_player.dart';

class SelectBoardSizeScreen extends StatefulWidget {
  const SelectBoardSizeScreen({super.key});

  @override
  _SelectBoardSizeScreenState createState() => _SelectBoardSizeScreenState();
}

class _SelectBoardSizeScreenState extends State<SelectBoardSizeScreen> {
  String? _selectedSize;
  TextEditingController _customSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSize = '3x3';
    _customSizeController.text = '3';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Board size'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Board size',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade700),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 200, 
                height: 55,
                child: DropdownButton<String>(
                  value: _selectedSize,
                  isExpanded: true, 
                  items: ['3x3', '4x4', '5x5', 'Custom'].map((size) {
                    return DropdownMenuItem<String>(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSize = value;
                      if (value != 'Custom') {
                        _customSizeController.text = value!.split('x').first;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (_selectedSize == 'Custom')
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _customSizeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'size',
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  int size = int.tryParse(_customSizeController.text) ??
                      int.parse(_selectedSize!.split('x').first);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectPlayerScreen(
                        boardSize: size,
                      ),
                    ),
                  );
                },
                child: Text(
                  'NEXT',
                  style: TextStyle(fontSize: 18, color: Colors.indigo.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
