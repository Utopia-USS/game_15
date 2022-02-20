const _holeStartingRow = 0;
const _holeStartingCol = 0;

class Square {
  final int startingRow;
  final int startingCol;
  final int currentRow;
  final int currentCol;

  const Square._({
    required this.startingRow,
    required this.startingCol,
    required this.currentRow,
    required this.currentCol,
  });

  factory Square.initial({
    required int startingRow,
    required int startingCol,
  }) => Square._(
    startingRow: startingRow,
    startingCol: startingCol,
    currentRow: startingRow,
    currentCol: startingCol,
  );

  Square moveTo({
    required int newRow,
    required int newCol,
  }) => Square._(
    startingRow: startingRow,
    startingCol: startingCol,
    currentRow: newRow,
    currentCol: newCol,
  );
}

List<Square> _createInitialPositions() {
  List<Square> squares = [];
  for(int row = 0; row < 4; row++) {
    for(int col = 0; col < 4; col++) {
      squares.add(Square.initial(startingRow: row, startingCol: col));
    }
  }
  return squares;
}

List<Square> getRandomizedPositions(int moveNum) {
  var squareList = _createInitialPositions();
  var hole = squareList.firstWhere((e) => e.startingCol == _holeStartingCol && e.startingRow == _holeStartingRow);
  for(int i = 0; i < moveNum; i++) {
    final adjacentSquares = squareList
        .where((e) => e.currentRow == hole.currentRow && (e.currentCol - hole.currentCol).abs() == 1 ||
            e.currentCol == hole.currentCol && (e.currentRow - hole.currentRow).abs() == 1)
        .toList();
    adjacentSquares.shuffle();
    final squareToMove = adjacentSquares.first;
    final movedSquare = squareToMove.moveTo(newRow: hole.currentRow, newCol: hole.currentCol);
    squareList.remove(squareToMove);
    squareList.add(movedSquare);

    squareList.remove(hole);
    hole = hole.moveTo(newRow: squareToMove.currentRow, newCol: squareToMove.currentCol);
    squareList.add(hole);
  }

  return squareList;
}
