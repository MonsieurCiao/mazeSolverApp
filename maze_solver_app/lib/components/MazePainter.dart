import 'package:flutter/material.dart';
import 'package:maze_solver_app/components/functions.dart';
import 'package:maze_solver_app/main.dart';

class MazeWidget extends StatefulWidget {
  final List<List<Cell>> grid;
  final int mazeI;

  const MazeWidget({required this.grid, required this.mazeI, super.key});

  @override
  State<MazeWidget> createState() => _MazeWidgetState();
}

class _MazeWidgetState extends State<MazeWidget> {
  @override
  void didUpdateWidget(covariant MazeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.grid != widget.grid) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomPaint(
        size: Size(
          canvasSize.value[0].toDouble(),
          canvasSize.value[1].toDouble(),
        ),
        painter: MazePainter(widget.grid, widget.mazeI),
      ),
    );
  }
}

class MazePainter extends CustomPainter {
  final List<List<Cell>> grid;
  final int mazeI;
  MazePainter(this.grid, this.mazeI);
  @override
  void paint(Canvas canvas, Size size) {
    // canvasSize.value = [size.width.floor(), size.height.floor()];
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        ((grid.length - 0.0) * 2 * cellSizeNotifier.value).toDouble(),
        ((grid[0].length - 0.0) * 2 * cellSizeNotifier.value).toDouble(),
      ),
      Paint()..color = Colors.black,
    );

    //visualize grid
    int spacing = cellSizeNotifier.value * 2;
    double cellSize = cellSizeNotifier.value.toDouble();
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(
              (i * spacing + cellSize).toDouble(),
              (j * spacing + cellSize).toDouble(),
            ),
            width: cellSize.toDouble(),
            height: cellSize.toDouble(),
          ),
          Paint()..color = Colors.white,
        );
        if (grid[i][j].visitedBy[mazeI] == (mazeI + 1)) {
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(
                (i * spacing + cellSize).toDouble(),
                (j * spacing + cellSize).toDouble(),
              ),
              width: cellSize.toDouble(),
              height: cellSize.toDouble(),
            ),
            Paint()..color = Colors.blue,
          );
        }
        if (grid[i][j].end) {
          canvas.drawRect(
            Rect.fromLTWH(
              (cellSize / 4 + i * cellSize) * 2,
              (cellSize / 4 + j * cellSize) * 2,
              cellSize,
              cellSize,
            ),
            Paint()..color = Colors.red,
          );
        }
        if (grid[i][j].start) {
          canvas.drawRect(
            Rect.fromLTWH(
              (cellSize / 4 + i * cellSize) * 2,
              (cellSize / 4 + j * cellSize) * 2,
              cellSize,
              cellSize,
            ),
            Paint()..color = Colors.green,
          );
        }
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
                    spacing / 2 +
                    (spacing / 2 * (neighborCell.i - cell.i)))
                .toDouble(),
            (cell.j * spacing +
                    spacing / 2 +
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
    // return old.grid != grid;
    return true;
  }
}
