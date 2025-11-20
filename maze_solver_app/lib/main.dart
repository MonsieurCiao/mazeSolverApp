import 'package:flutter/material.dart';
import 'package:maze_solver_app/components/MazePainter.dart';
import 'package:maze_solver_app/components/sidebar.dart';

void main() {
  runApp(const MainApp());
}

ValueNotifier<int> cellSizeNotifier = ValueNotifier(10);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder(
                valueListenable: cellSizeNotifier,
                builder: (context, value, child) {
                  return MazeWidget();
                },
              ),
              SidebarWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
