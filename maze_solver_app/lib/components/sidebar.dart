import 'package:flutter/material.dart';
import 'package:maze_solver_app/components/GenerateSelect.dart';
import 'package:maze_solver_app/components/SizeSlider.dart';
import 'package:maze_solver_app/components/SpeedSlider.dart';
import 'package:maze_solver_app/components/select.dart';
import 'package:maze_solver_app/main.dart';

class SidebarWidget extends StatelessWidget {
  final int gridSizeX;
  final int gridSizeY;
  final int totalCells;
  final int cellSizeState;
  final List<String> algorithms;
  final String generateAlgo;
  final void Function(String) onGenerateAlgoChange;
  final void Function(int) removeAlgorithm;
  final void Function() addAlgorithm;
  final void Function(int, String) changeAlgorithms;
  final void Function() runAlgorithm;
  final void Function() clearMaze;

  const SidebarWidget({
    required this.gridSizeX,
    required this.gridSizeY,
    required this.totalCells,
    required this.cellSizeState,
    required this.algorithms,
    required this.generateAlgo,
    required this.onGenerateAlgoChange,
    required this.removeAlgorithm,
    required this.addAlgorithm,
    required this.changeAlgorithms,
    required this.runAlgorithm,
    required this.clearMaze,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Column(
                children: [
                  Text("Maze Info", style: TextStyle(fontSize: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 20,
                    children: [
                      Text("Maze Size", style: TextStyle(fontSize: 12)),
                      Text(
                        "$gridSizeX x $gridSizeY",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 20,
                    children: [
                      Text("Total Cells", style: TextStyle(fontSize: 12)),
                      Text("$totalCells", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 20,
                    children: [
                      Text("Cell Size", style: TextStyle(fontSize: 12)),
                      Text("$cellSizeState", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizeSlider(),
          ValueListenableBuilder(
            valueListenable: speedNotifier,
            builder: (context, value, child) {
              return Text("speed: $value ms", style: TextStyle(fontSize: 20));
            },
          ),
          SpeedSlider(),
          Generateselect(
            algorithm: generateAlgo,
            onChanged: onGenerateAlgoChange,
          ),
          const SizedBox(height: 16, width: 20),
          const Text("Choose your algorithm", style: TextStyle(fontSize: 30)),
          const SizedBox(height: 16, width: 20),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: List.generate(
              algorithms.length,
              (index) => Row(
                children: [
                  Select(
                    algorithm: algorithms[index],
                    onChanged: (String newValue) {
                      changeAlgorithms(index, newValue);
                    },
                    key: ValueKey(index),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      removeAlgorithm(index);
                    },
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10, width: 20),

          ElevatedButton(
            onPressed: addAlgorithm,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              minimumSize: const Size(300, 50), // Full width
            ),
            child: const Icon(Icons.plus_one),
          ),

          const SizedBox(height: 30, width: 20),
          ElevatedButton(
            onPressed: runAlgorithm,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              minimumSize: const Size(300, 50), // Full width
            ),
            child: const Text("Run"),
          ),
          const SizedBox(height: 30, width: 20),
          ElevatedButton(
            onPressed: clearMaze,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              minimumSize: const Size(300, 50), // Full width
            ),
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }
}
