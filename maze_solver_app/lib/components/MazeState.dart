import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maze_solver_app/components/MazePainter.dart';
import 'package:maze_solver_app/components/functions.dart';
import 'package:maze_solver_app/components/sidebar.dart';
import 'package:maze_solver_app/main.dart';

class MazeScreen extends StatefulWidget {
  const MazeScreen({super.key});

  @override
  _MazeScreenState createState() => _MazeScreenState();
}

class _MazeScreenState extends State<MazeScreen> {
  late List<List<Cell>> grid;
  late List<List<List<Cell>>> algorithmGrids;

  final List<String> _algorithms = ["A*"];

  String generateAlgo = "DFS";

  //info calculations
  int gridSizeX = 20;
  int gridSizeY = 20;
  int cellSizeState = 10;
  int totalCells = 20 * 20;

  @override
  void initState() {
    super.initState();
    initMaze(cellSizeNotifier.value, canvasSize.value);
    //listen to cellSizeNotifier
    cellSizeNotifier.addListener(() {
      setState(() {
        initMaze(cellSizeNotifier.value, canvasSize.value);
        initInfo(cellSizeNotifier.value, canvasSize.value);
      });
    });
  }

  void initInfo(int cellSize, List<int> canvasSize) {
    gridSizeX = (0.5 * canvasSize[0] / cellSize).toInt();
    gridSizeY = (0.5 * canvasSize[1] / cellSize).toInt();
    cellSizeState = cellSize;
    totalCells = gridSizeX * gridSizeY;
  }

  List<List<Cell>> deepCopyGrid(List<List<Cell>> originalGrid) {
    int rows = originalGrid.length;
    int cols = originalGrid[0].length;

    var newGrid = List<List<Cell>>.generate(
      rows,
      (i) => List<Cell>.generate(cols, (j) => Cell(i, j), growable: false),
      growable: false,
    );

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        newGrid[i][j]
          ..visited = false
          ..end = originalGrid[i][j].end
          ..start = originalGrid[i][j].start
          ..visitedBy = List<int>.from(originalGrid[i][j].visitedBy);
      }
    }

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        newGrid[i][j].neighbors = originalGrid[i][j].neighbors
            .map((neighbor) => newGrid[neighbor.i][neighbor.j])
            .toList();
      }
    }

    return newGrid;
  }

  void initMaze(int cellSize, List<int> canvasSize) {
    int gridSizeX = (0.5 * canvasSize[0] / cellSize).toInt();
    int gridSizeY = (0.5 * canvasSize[1] / cellSize).toInt();
    grid = List<List<Cell>>.generate(
      gridSizeX,
      (i) => List<Cell>.generate(gridSizeY, (j) => Cell(i, j), growable: false),
      growable: false,
    );
    grid[0][0].start = true;
    grid[gridSizeX - 1][gridSizeY - 1].end = true;
    // generateMaze(0, 0, grid);
    if (generateAlgo == "DFS") {
      dfsGenerate(grid);
    } else {
      prim(grid);
    }
    algorithmGrids = List.generate(
      4,
      (_) => deepCopyGrid(grid),
      growable: false,
    );
  }

  void addAlgorithm() {
    setState(() {
      if (_algorithms.length < 4) {
        _algorithms.add("A*");
      }
    });
  }

  void removeAlgorithm(int index) {
    setState(() {
      _algorithms.removeAt(index);
    });
  }

  void changeAlgorithms(int i, String value) {
    setState(() {
      _algorithms[i] = value;
    });
    print(_algorithms);
  }

  void onGenerateAlgoChange(String value) {
    setState(() {
      generateAlgo = value;
    });
  }

  void runAlgorithm() async {
    // dfs(grid, 0, 0, 0, () {
    //   setState(() {});
    // });
    print("running algorithms");
    for (int i = 0; i < _algorithms.length; i++) {
      print("on $i");
      if (_algorithms[i] == "DFS") {
        dfs(algorithmGrids[i], 0, 0, i, speedNotifier.value, () {
          setState(() {});
        });
      } else if (_algorithms[i] == "BFS") {
        bfs(algorithmGrids[i], i, speedNotifier.value, () {
          setState(() {});
        });
      }
    }
  }

  void clearMaze() {
    for (int mazeI = 0; mazeI < _algorithms.length; mazeI++) {
      for (int i = 0; i < grid.length; i++) {
        for (int j = 0; j < grid[0].length; j++) {
          algorithmGrids[mazeI][i][j].visitedBy = List.generate(
            4,
            (index) => 0,
            growable: false,
          );
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  children: List.generate(
                    _algorithms.length > 2 ? 2 : _algorithms.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MazeWidget(
                          grid: algorithmGrids[index],
                          mazeI: index,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  children: List.generate(
                    _algorithms.length - 2 > 0 ? _algorithms.length - 2 : 0,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MazeWidget(
                          grid: algorithmGrids[index + 2],
                          mazeI: index + 2,
                        ), // Later: pass individual grids here!
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        ValueListenableBuilder(
          valueListenable: (cellSizeNotifier),
          builder: (context, value, child) {
            return SidebarWidget(
              gridSizeX: gridSizeX,
              gridSizeY: gridSizeY,
              totalCells: totalCells,
              cellSizeState: cellSizeState,
              algorithms: _algorithms,
              generateAlgo: generateAlgo,
              onGenerateAlgoChange: onGenerateAlgoChange,
              removeAlgorithm: removeAlgorithm,
              addAlgorithm: addAlgorithm,
              changeAlgorithms: changeAlgorithms,
              runAlgorithm: runAlgorithm,
              clearMaze: clearMaze,
            );
          },
        ),
        // SidebarWidget(),
      ],
    );
  }
}
