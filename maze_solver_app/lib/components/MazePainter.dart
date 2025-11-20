import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maze_solver_app/main.dart';

class Cell {
  var i = 0, j = 0;
  var neighbors = <Cell>[];
  bool visited = false;
  Cell(this.i, this.j); //constructor
}

ValueNotifier<List<int>> canvasSize = ValueNotifier([200, 200]);

class MazeWidget extends StatefulWidget {
  const MazeWidget({super.key});
  @override
  _MazeWidgetState createState() => _MazeWidgetState();
}

class _MazeWidgetState extends State<MazeWidget> {
  late List<List<Cell>> grid;

  @override
  void initState() {
    super.initState();
    initMaze(cellSizeNotifier.value, canvasSize.value);
    //listen to cellSizeNotifier
    cellSizeNotifier.addListener(() {
      setState(() {
        initMaze(cellSizeNotifier.value, canvasSize.value);
      });
    });
  }

  void initMaze(int cellSize, List<int> canvasSize) {
    print(canvasSize);
    print("cellSize: $cellSize");
    int gridSizeX = (canvasSize[0] / cellSize).toInt();
    int gridSizeY = (canvasSize[1] / cellSize).toInt();
    grid = List<List<Cell>>.generate(
      gridSizeX,
      (i) => List<Cell>.generate(gridSizeY, (j) => Cell(i, j), growable: false),
      growable: false,
    );
    grid[0][0].visited = true;
    generateMaze(0, 0, grid);
  }

  void generateMaze(int row, int col, List<List<Cell>> grid) {
    var cur = grid[row][col];
    var cells = <Cell>[];
    // drawCell(canvas, row, col);

    if (row > 0) {
      var leftCell = grid[row - 1][col];
      if (!leftCell.visited) {
        cells.add(leftCell);
      }
    }
    if (row < grid.length - 1) {
      var rightCell = grid[row + 1][col];
      if (!rightCell.visited) {
        cells.add(rightCell);
      }
    }
    if (col > 0) {
      var topCell = grid[row][col - 1];
      if (!topCell.visited) {
        cells.add(topCell);
      }
    }
    if (col < grid[0].length - 1) {
      var bottomCell = grid[row][col + 1];
      if (!bottomCell.visited) {
        cells.add(bottomCell);
      }
    }

    if (cells.isNotEmpty) {
      int randIndex = Random().nextInt(cells.length); // 0 <= x < 4
      var newCell = cells[randIndex];
      newCell.visited = true;
      cur.neighbors.add(newCell);
      newCell.neighbors.add(cur);
      generateMaze(newCell.i, newCell.j, grid);
      cells.removeAt(randIndex);
      if (cells.isNotEmpty) {
        generateMaze(row, col, grid);
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // child: CustomPaint(size: Size(2000, 2000), painter: MazePainter(grid)),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final newSize = [
            constraints.maxWidth.floor(),
            constraints.maxHeight.floor(),
          ];
          if (canvasSize.value[0] != newSize[0] ||
              canvasSize.value[1] != newSize[1]) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              canvasSize.value = newSize;
            });
          }
          return CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: MazePainter(grid),
          );
        },
      ),
    );
  }
}

class MazePainter extends CustomPainter {
  final List<List<Cell>> grid;
  MazePainter(this.grid);
  @override
  void paint(Canvas canvas, Size size) {
    var center = size / 2;
    canvasSize.value = [size.width.floor(), size.height.floor()];
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.width, center.height),
        width: size.width,
        height: size.height,
      ),
      Paint()..color = Colors.black,
    );

    //visualize grid
    int spacing = cellSizeNotifier.value * 2;
    double cellSize = cellSizeNotifier.value.toDouble();
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid.length; j++) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(
              (i * spacing + cellSize / 2).toDouble(),
              (j * spacing + cellSize / 2).toDouble(),
            ),
            width: cellSize.toDouble(),
            height: cellSize.toDouble(),
          ),
          Paint()..color = Colors.white,
        );
        visualizeConnections(canvas, grid[i][j], spacing);
      }
    }
  }

  void visualizeConnections(Canvas canvas, Cell cell, int spacing) {
    for (Cell neighborCell in cell.neighbors) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(
            (cell.i * spacing +
                    spacing / 4 +
                    (spacing / 2 * (neighborCell.i - cell.i)))
                .toDouble(),
            (cell.j * spacing +
                    spacing / 4 +
                    (spacing / 2 * (neighborCell.j - cell.j)))
                .toDouble(),
          ),
          width: (spacing / 2).toDouble(),
          height: (spacing / 2).toDouble(),
        ),
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(MazePainter old) {
    return old.grid != grid;
  }
}
