import 'package:flutter/material.dart';
import 'package:maze_solver_app/components/Slider.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key});

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  var _algorithms = ["A*"];

  void addAlgorithm() {
    print("adding algorithm.");
  }

  void runAlgorithm() {
    print("running algorithms");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizeSlider(),
        const SizedBox(height: 16),
        const Text("Choose your algorithm", style: TextStyle(fontSize: 30)),
        const SizedBox(height: 16),
        DropdownButton<String>(
          value: _algorithms[0],
          items: ['A*', 'Dijkstra', 'BFS', 'DFS'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? newValue) {
            // Handle selection
            setState(() {
              _algorithms[0] = newValue ?? "A*";
            });
          },
        ),
        const SizedBox(height: 10),

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

        const SizedBox(height: 30),
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
      ],
    );
  }
}
