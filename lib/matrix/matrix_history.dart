import 'positions.dart';

List<MH> matrixHistory(int thisMemberPos, int lastMemberPos) {
  List<MH> listMH = [];
  if (lastMemberPos >= dlFirstPos(1, thisMemberPos)) {
    var dlfp = dlFirstPos(1, thisMemberPos);
    if (lastMemberPos >= dlLastPos(1, thisMemberPos)) {
      while (dlfp <= dlLastPos(1, thisMemberPos)) {
        listMH.add(MH(amount: 400, isPlus: true, memPos: dlfp));
        dlfp++;
      }
      listMH.add(MH(
          amount: 500,
          isPlus: false,
          memPos: upLevelPosition(2, thisMemberPos)));
      listMH.add(MH(amount: 120, isPlus: false, memPos: 0));
    } else {
      while (dlfp <= lastMemberPos) {
        listMH.add(MH(amount: 400, isPlus: true, memPos: dlfp));
        dlfp++;
      }
    }
  }

  //
  if (lastMemberPos >= dlFirstPos(3, thisMemberPos)) {
    var dlfp = dlFirstPos(2, thisMemberPos);
    if (lastMemberPos >= dlLastPos(3, thisMemberPos)) {
      while (dlLastPos(1, dlfp) <= dlLastPos(3, thisMemberPos)) {
        listMH.add(MH(amount: 500, isPlus: true, memPos: dlfp));
        dlfp++;
      }
      listMH.add(MH(
          amount: 2000,
          isPlus: false,
          memPos: upLevelPosition(3, thisMemberPos)));
      listMH.add(MH(amount: 450, isPlus: false, memPos: 0));
    } else {
      while (dlFirstPos(1, dlfp + 1) <= lastMemberPos) {
        listMH.add(MH(amount: 500, isPlus: true, memPos: dlfp));
        dlfp++;
      }
    }
  }

  //
  if (lastMemberPos >= dlFirstPos(6, thisMemberPos)) {
    var dlfp = dlFirstPos(3, thisMemberPos);
    if (lastMemberPos >= dlLastPos(6, thisMemberPos)) {
      while (dlLastPos(3, dlfp) <= dlLastPos(6, thisMemberPos)) {
        listMH.add(MH(amount: 2000, isPlus: true, memPos: dlfp));
        dlfp++;
      }
      listMH.add(MH(
          amount: 5000,
          isPlus: false,
          memPos: upLevelPosition(6, thisMemberPos)));
      listMH.add(MH(amount: 5400, isPlus: false, memPos: 0));
    } else {
      while (dlLastPos(3, dlfp) <= lastMemberPos) {
        listMH.add(MH(amount: 2000, isPlus: true, memPos: dlfp));
        dlfp++;
      }
    }
  }

  //
  if (lastMemberPos >= dlFirstPos(8, thisMemberPos)) {
    var dlfp = dlFirstPos(4, thisMemberPos);
    if (lastMemberPos >= dlLastPos(8, thisMemberPos)) {
      while (dlLastPos(4, dlfp) <= dlLastPos(8, thisMemberPos)) {
        listMH.add(MH(amount: 5000, isPlus: true, memPos: dlfp));
        dlfp++;
      }
      listMH.add(MH(
          amount: 50000,
          isPlus: false,
          memPos: upLevelPosition(6, thisMemberPos)));
      listMH.add(MH(amount: 40500, isPlus: false, memPos: 0));
    } else {
      while (dlLastPos(4, dlfp) <= lastMemberPos) {
        listMH.add(MH(amount: 5000, isPlus: true, memPos: dlfp));
        dlfp++;
      }
    }
  }

  //
  if (lastMemberPos >= dlFirstPos(10, thisMemberPos)) {
    var dlfp = dlFirstPos(5, thisMemberPos);
    if (lastMemberPos >= dlLastPos(10, thisMemberPos)) {
      while (dlLastPos(5, dlfp) <= dlLastPos(10, thisMemberPos)) {
        listMH.add(MH(amount: 50000, isPlus: true, memPos: dlfp));
        dlfp++;
      }
    } else {
      while (dlLastPos(5, dlfp) <= lastMemberPos) {
        listMH.add(MH(amount: 50000, isPlus: true, memPos: dlfp));
        dlfp++;
      }
    }
  }

  //
  return listMH;
}
