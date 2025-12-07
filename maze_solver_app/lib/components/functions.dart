import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:collection/collection.dart';

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
    await Future.delayed(Duration(milliseconds: speed));

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

Future<void> dijkstra(
  List<List<Cell>> grid,
  int algI,
  int speedMs,
  VoidCallback onUpdate,
) async {
  final rows = grid.length;
  final cols = grid[0].length;

  // Adjust this to however you define start / end
  final Cell start = grid[0][0];
  Cell? end;
  for (var row in grid) {
    for (var c in row) {
      if (c.end == true) {
        end = c;
        break;
      }
    }
    if (end != null) break;
  }

  // Distances and visited
  final Map<Cell, int> dist = {};
  final Set<Cell> visited = {};

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      dist[grid[i][j]] = 0x7FFFFFFF; // big "infinity"
    }
  }
  dist[start] = 0;

  // Min-heap priority queue of (distance, cell)
  final pq = PriorityQueue<_Node>((a, b) => a.dist.compareTo(b.dist));
  pq.add(_Node(start, 0));

  while (pq.isNotEmpty) {
    final current = pq.removeFirst();
    final Cell cur = current.cell;
    final int curDist = current.dist;

    if (visited.contains(cur)) continue;
    visited.add(cur);

    // mark for visualization
    cur.visitedBy[algI] = algI + 1;
    onUpdate();
    await Future.delayed(Duration(milliseconds: speedMs));

    if (cur == end) {
      print('Dijkstra Reached end cell with distance: $curDist');
      return;
    }

    for (final Cell nbr in cur.neighbors) {
      if (visited.contains(nbr)) continue;

      final int newDist = curDist + 1; // or edge weight if you have one
      final int oldDist = dist[nbr] ?? 0x7FFFFFFF;

      if (newDist < oldDist) {
        dist[nbr] = newDist;
        pq.add(_Node(nbr, newDist));
      }
    }
  }

  print("dijkstra hasn't found mommy :'(");
}

class _Node {
  final Cell cell;
  final int dist;
  _Node(this.cell, this.dist);
}

int heuristic(Cell a, Cell b) {
  // Manhattan distance
  return (a.i - b.i).abs() + (a.j - b.j).abs();
}

Future<void> astar(
  List<List<Cell>> grid,
  int algI,
  int speedMs,
  VoidCallback onUpdate,
) async {
  final rows = grid.length;
  final cols = grid[0].length;

  // Find start and end
  Cell? start;
  Cell? goal;
  for (var row in grid) {
    for (var c in row) {
      if (c.start) start = c;
      if (c.end) goal = c;
    }
  }

  if (start == null || goal == null) {
    print("No start or end cell set!");
    return;
  }

  // g-score (distance from start), f-score, parent
  final Map<Cell, int> g = {};
  final Map<Cell, int> f = {};
  final Map<Cell, Cell> parent = {};

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      g[grid[i][j]] = 0x7FFFFFFF; // big "infinity"
    }
  }

  g[start!] = 0;
  f[start!] = heuristic(start!, goal!);

  // Min-heap priority queue of (f-score, cell)
  final pq = PriorityQueue<_ANode>((a, b) => a.priority.compareTo(b.priority));
  pq.add(_ANode(start!, f[start!]!));

  while (pq.isNotEmpty) {
    final current = pq.removeFirst();
    final Cell cur = current.cell;
    final int curF = current.priority;

    if (cur.visited) continue;
    cur.visited = true;

    // mark for visualization
    cur.visitedBy[algI] = algI + 1;
    onUpdate();
    await Future.delayed(Duration(milliseconds: speedMs));

    if (cur.end) {
      print('A* done! Path length: TBD');
      // Reconstruct path if needed
      List<Cell> path = [];
      Cell? p = goal;
      while (p != null) {
        path.add(p);
        p = parent[p];
      }
      path = path.reversed.toList();
      print('Path length: ${path.length}');
      return;
    }

    for (final Cell nbr in cur.neighbors) {
      if (nbr.visited) continue;

      final int tentativeG = g[cur]! + 1;
      if (tentativeG < (g[nbr] ?? 0x7FFFFFFF)) {
        parent[nbr] = cur;
        g[nbr] = tentativeG;
        f[nbr] = tentativeG + heuristic(nbr, goal);
        pq.add(_ANode(nbr, f[nbr]!));
      }
    }
  }

  print("No path found.");
}

class _ANode {
  final Cell cell;
  final int priority;
  _ANode(this.cell, this.priority);
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
