import 'positions.dart';

int matrixIncome(int thisMemberPos, int lastMemberPos) {
  int matrixInc = 0;
  if (lastMemberPos >= dlFirstPos(1, thisMemberPos)) {
    if (lastMemberPos >= dlLastPos(1, thisMemberPos)) {
      matrixInc += 580;
    } else {
      matrixInc += (lastMemberPos - dlFirstPos(1, thisMemberPos) + 1) * 400;
    }
  }
  if (lastMemberPos >= dlFirstPos(3, thisMemberPos)) {
    if (lastMemberPos >= dlLastPos(3, thisMemberPos)) {
      matrixInc += 2050;
    } else {
      matrixInc +=
          ((lastMemberPos - dlFirstPos(3, thisMemberPos)) / 3 - 1).ceil() * 500;
    }
  }
  if (lastMemberPos >= dlFirstPos(6, thisMemberPos)) {
    if (lastMemberPos >= dlLastPos(6, thisMemberPos)) {
      matrixInc += 43600;
    } else {
      matrixInc +=
          ((lastMemberPos - dlFirstPos(6, thisMemberPos)) / 27).ceil() * 2000;
    }
  }
  if (lastMemberPos >= dlFirstPos(8, thisMemberPos)) {
    if (lastMemberPos >= dlLastPos(8, thisMemberPos)) {
      matrixInc += 43600;
    } else {
      matrixInc +=
          ((lastMemberPos - dlFirstPos(8, thisMemberPos)) / 81).ceil() * 5000;
    }
  }
  if (lastMemberPos >= dlFirstPos(10, thisMemberPos)) {
    if (lastMemberPos >= dlLastPos(10, thisMemberPos)) {
      matrixInc += 43600;
    } else {
      matrixInc +=
          ((lastMemberPos - dlFirstPos(8, thisMemberPos)) / 243).ceil() * 50000;
    }
  }

  return matrixInc;
}
