import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void addAlgorithm() {
    print("adding algorithm.");
  }

  void runAlgorithm() {
    print("running algorithms");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Choose your algorithm",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: 'A',
                items: ['A', 'B', 'C'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle selection
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: addAlgorithm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    minimumSize: const Size(double.infinity, 50), // Full width
                  ),
                  child: const Icon(Icons.plus_one),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: runAlgorithm,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: const Size(double.infinity, 50), // Full width
                ),
                child: const Text("Run"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
