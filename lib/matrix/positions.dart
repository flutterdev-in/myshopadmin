import 'dart:math';

int rowNumber(int position) {
  int x = 0;
  int m = position - pow(3, x).toInt();
  while (m > 0) {
    x++;
    m = m - pow(3, x).toInt();
  }
  return x;
}

int rowPosition(int position) {
  int x = 0;
  int row = rowNumber(position);
  while (x < row) {
    position = position - pow(3, x).toInt();
    x++;
  }

  return position;
}

int getPosition(int row, int rowPos) {
  if (row == 0) {
    return 1;
  } else {
    int x = 0;

    int pos = pow(3, x).toInt();
    while (x < row - 1) {
      x++;
      pos = pos + pow(3, x).toInt();
    }

    return pos + rowPos;
  }
}

int oneUpLevelPosition(int position) {
  if (position == 1 || position == 0) {
    return 0;
  } else if (position <= 4) {
    return 1;
  } else {
    int l1Row = rowNumber(position) - 1;
    if (l1Row < 0) {
      l1Row = 0;
    }

    int upperRowPosition = 0;
    int rowPos = rowPosition(position);

    if (rowPos <= 3) {
      upperRowPosition = 1;
    } else {
      upperRowPosition = (rowPos / 3).ceil();
      // int rowPosReminder = rowPos % 3;
      // if (rowPosReminder == 0) {
      //   upperRowPosition = (rowPos / 3).ceil();
      // } else {
      //   upperRowPosition = (rowPos / 3).ceil() + 1;
      // }
    }

    return getPosition(l1Row, upperRowPosition);
  }
}

int upLevelPosition(int levelNumber, int originalPosition) {
  int initialUpLevel = 1;
  int levelPos = oneUpLevelPosition(originalPosition);

  while (initialUpLevel < levelNumber) {
    levelPos = oneUpLevelPosition(levelPos);
    initialUpLevel++;
  }
  return levelPos;
}

List<int> get5downLevelEndPositions(int originalPosition) {
  int rowNum = rowNumber(originalPosition);
  int rowPos = rowPosition(originalPosition);
  int dl(int num) {
    return getPosition(rowNum + num, rowPos * pow(3, num).toInt());
  }

  return [dl(1), dl(3), dl(6), dl(8), dl(10)];
}

class MH {
  int amount;
  bool isPlus;
  int memPos;
  MH({
    required this.amount,
    required this.isPlus,
    required this.memPos,
  });
}

int dlLastPos(int level, int originalPosition) {
  int rowNum = rowNumber(originalPosition);
  int rowPos = rowPosition(originalPosition);
  return getPosition(rowNum + level, rowPos * pow(3, level).toInt());
}

int dlFirstPos(int level, int originalPosition) {
  int rowNum = rowNumber(originalPosition);
  int rowPos = rowPosition(originalPosition);
  if (rowPos == 1) {
    return getPosition(rowNum + level, 1);
  } else {
    return getPosition(
        rowNum + level, ((rowPos - 1) * pow(3, level).toInt()) + 1);
  }
}
