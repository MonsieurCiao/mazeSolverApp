import 'package:flutter/material.dart';
import 'package:maze_solver_app/components/MazeState.dart';

void main() {
  runApp(const MainApp());
}

ValueNotifier<int> cellSizeNotifier = ValueNotifier(10);
ValueNotifier<int> speedNotifier = ValueNotifier(20);
ValueNotifier<List<int>> canvasSize = ValueNotifier([550, 420]);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(padding: const EdgeInsets.all(16.0), child: MazeScreen()),
      ),
    );
  }
}
