import 'dart:math';

import 'package:flutter/animation.dart';

class Cell {
  var i = 0, j = 0;
  var neighbors = <Cell>[];
  bool visited = false;
  bool end = false;
  bool start = false;
  bool frontier = false;
  List<int> visitedBy = List.generate(4, (index) => 0, growable: false);

  Cell(this.i, this.j); //constructor

  Cell clone() {
    return Cell(i, j)
      ..visited = visited
      ..end = end
      ..neighbors = List<Cell>.from(neighbors)
      ..visitedBy = List<int>.from(visitedBy);
  }
}

Future<void> dfs(
  List<List<Cell>> grid,
  int startI,
  int startJ,
  int algI,
  int speed,
  VoidCallback onUpdate,
) async {
  Set<Cell> visited = {};
  List<Cell> stack = [];

  stack.add(grid[startI][startJ]);
  visited.add(grid[startI][startJ]);

  while (stack.isNotEmpty) {
    Cell cur = stack.last;
    cur.visitedBy[algI] = algI + 1;

    onUpdate();

    if (cur.end) {
      print("Found end");
      return;
    }

    Cell? nextNeighbor;
    for (var neighbor in cur.neighbors) {
      if (!visited.contains(neighbor)) {
        nextNeighbor = neighbor;
        break;
      }
    }

    if (nextNeighbor != null) {
      stack.add(nextNeighbor);
      visited.add(nextNeighbor);
    } else {
      stack.removeLast();
    }

    await Future.delayed(Duration(milliseconds: speed));
  }

  print("No path found");
}

Future<void> bfs(
  List<List<Cell>> grid,
  int algI,
  int speed,
  VoidCallback onUpdate,
) async // 2d array of pointers
{
  // cout << "cleaning grid..." << endl;
  // cleanGrid(grid);

  List<Cell> q = []; // pointer queue

  grid[0][0].visited = true;
  q.add(grid[0][0]);

  while (q.isNotEmpty) {
    Cell cur = q.first;
    cur.visitedBy[algI] = algI + 1;
    onUpdate();

    if (cur.end) {
      print("bfs found");
      return;
    }

    q.removeAt(0);

    for (Cell x in cur.neighbors) {
      if (!x.visited) {
        grid[x.i][x.j].visited = true;
        grid[x.i][x.j].visitedBy[algI] = algI + 1;
        q.add(x);
      }
    }
    await Future.delayed(Duration(milliseconds: speed));
  }
}

void dfsGenerate(List<List<Cell>> grid) {
  List<Cell> stack = [];
  Cell start = grid[0][0];
  start.visited = true;
  stack.add(start);

  List<int> dx = [-1, 1, 0, 0];
  List<int> dy = [0, 0, -1, 1];

  while (stack.isNotEmpty) {
    Cell cur = stack.last;
    List<Cell> neighbors = [];
    int x = cur.i;
    int y = cur.j;
    for (int dir = 0; dir < 4; dir++) {
      int nx = x + dx[dir];
      int ny = y + dy[dir];
      if (nx >= 0 &&
          ny >= 0 &&
          nx < grid.length &&
          ny < grid[0].length &&
          !grid[nx][ny].visited) {
        neighbors.add(grid[nx][ny]);
      }
    }

    if (neighbors.isNotEmpty) {
      int idx = Random().nextInt(neighbors.length);
      Cell next = neighbors[idx];
      next.visited = true;

      cur.neighbors.add(next);

      stack.add(next);
    } else {
      stack.removeLast();
    }
  }
}

void generateMaze(int row, int col, List<List<Cell>> grid) {
  var cur = grid[row][col];
  var cells = <Cell>[];

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

    generateMaze(newCell.i, newCell.j, grid);
    cells.removeAt(randIndex);
    if (cells.isNotEmpty) {
      generateMaze(row, col, grid);
    }
  }
  return;
}

void findFrontiers(int x, int y, List<Cell> frontiers, List<List<Cell>> grid) {
  List<int> dx = [-1, 1, 0, 0];
  List<int> dy = [0, 0, -1, 1];
  // add neighbors to frontiers
  for (int k = 0; k < 4; k++) {
    int nx = x + dx[k];
    int ny = y + dy[k];
    if (nx >= 0 &&
        ny >= 0 &&
        nx < grid.length &&
        ny < grid[0].length &&
        !grid[nx][ny].visited &&
        !grid[nx][ny].frontier) {
      frontiers.add(grid[nx][ny]);
      grid[nx][ny].frontier = true;
    }
  }
}

void prim(List<List<Cell>> grid) {
  List<Cell> frontiers = [];

  // pick random cell
  int randX = 0;
  int randY = 0;
  Cell currentCell = grid[randX][randY];
  currentCell.visited = true;

  findFrontiers(randX, randY, frontiers, grid);

  while (frontiers.isNotEmpty) {
    // choose random frontier
    int frontierI = Random().nextInt(frontiers.length);
    Cell frontier = frontiers[frontierI];
    // frontiers.erase(frontiers.begin() + frontierI); // inefficient
    frontiers[frontierI] = frontiers.last;
    frontiers.removeLast();
    frontier.visited = true;

    List<Cell> visitedNeighbors = [];
    List<int> dx = [-1, 1, 0, 0];
    List<int> dy = [0, 0, -1, 1];
    for (int k = 0; k < 4; k++) {
      int nx = frontier.i + dx[k];
      int ny = frontier.j + dy[k];
      if (nx >= 0 &&
          ny >= 0 &&
          nx < grid.length &&
          ny < grid[0].length &&
          grid[nx][ny].visited) {
        visitedNeighbors.add(grid[nx][ny]);
      }
    }
    if (visitedNeighbors.isNotEmpty) {
      Cell neighbor =
          visitedNeighbors[Random().nextInt(visitedNeighbors.length)];
      neighbor.neighbors.add(frontier);
      frontier.neighbors.add(neighbor);
    }

    // add former frontier's frontiers xD
    findFrontiers(frontier.i, frontier.j, frontiers, grid);
  }
}
