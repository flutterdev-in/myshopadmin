int blockedMatrixIncome(int matrixIncome) {
  List<int> zeroBlock = [580, 2630, 46230, 360730, 11095730];
  if (matrixIncome == 0) {
    return 0;
  } else if (zeroBlock.contains(matrixIncome)) {
    return 0;
  } else if (matrixIncome < 801) {
    //400+400=800+1
    return 580;
  } else if (matrixIncome < 3031) {
    //580+2450 = 3030+1
    return matrixIncome - 580;
  } else if (matrixIncome < 4581) {
    //580+8x500 = 4580+1
    return 2450;
  } else if (matrixIncome < 13031) {
    //580+2050+10400 = 13030+1
    return matrixIncome - 3030;
  } else if (matrixIncome < 54631) {
    //580+2050+26x2000 = 54630+1
    return 10400;
  } else if (matrixIncome < 136730) {
    //580+2050+43600+90500 = 136730+1
    return matrixIncome - 13030;
  } else if (matrixIncome < 446231) {
    //580+2050+43600+80x5000 = 446230+1
    return 90500;
  } else if (matrixIncome < 1551731) {
    //580+2050+43600+90500+1415000 = 1551730+1
    return matrixIncome - 136730;
  } else if (matrixIncome < 12460731) {
    //580+2050+43600+90500+242x50000 = 12460730+1
    return 1415000;
  } else {
    return 0;
  }
}

//
int netMatrixIncome(int matrixIncome) {
  return matrixIncome - blockedMatrixIncome(matrixIncome);
}

//
List<int> blockedIncomeList(int matrixIncome) {
  int blockedAmount = blockedMatrixIncome(matrixIncome);
  if (blockedAmount == 580) {
    return [580, 120];
  } else if (blockedAmount == 2450) {
    return [2000, 450];
  } else if (blockedAmount == 10400) {
    return [5000, 5400];
  } else if (blockedAmount == 90500) {
    return [50000, 40500];
  } else if (blockedAmount == 1415000) {
    return [200000, 1215000];
  } else {
    return [0, 0];
  }
}

int needDirectRef(int matrixIncome) {
  if (matrixIncome == 580) {
    return 3;
  } else if (matrixIncome == 2630) {
    return 5;
  } else if (matrixIncome == 46230) {
    return 10;
  } else if (matrixIncome == 360730) {
    return 35;
  } else if (matrixIncome < 801) {
    return 3;
  } else if (matrixIncome < 4581) {
    return 5;
  } else if (matrixIncome < 54631) {
    return 10;
  } else if (matrixIncome < 4462301) {
    return 35;
  } else if (matrixIncome < 12460730) {
    return 250;
  } else {
    return 0;
  }
}

//
int currentLevel(int matrixIncome) {
  if (matrixIncome == 580) {
    return 2;
  } else if (matrixIncome == 2630) {
    return 3;
  } else if (matrixIncome == 46230) {
    return 4;
  } else if (matrixIncome == 360730) {
    return 5;
  } else if (matrixIncome < 801) {
    return 1;
  } else if (matrixIncome < 4581) {
    return 2;
  } else if (matrixIncome < 54631) {
    return 3;
  } else if (matrixIncome < 4462301) {
    return 4;
  } else {
    return 6;
  }
}
