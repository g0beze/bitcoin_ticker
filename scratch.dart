List<int> winningNumbers = [12, 6, 34, 22, 41, 9];

void main() {
  List<int> ticket1 = [45, 2, 9, 18, 12, 33];
  List<int> ticket2 = [41, 17, 26, 32, 7, 35];

  checkNumbers(ticket1);
  checkNumbers(ticket2);
}

void checkNumbers(List<int> myNumbers) {
  var i = 0;

  for (int myNum in myNumbers) {
    for (int winNums in winningNumbers) {
      if (myNum == winNums) {
        i++;
      }
    }
  }
  print('You\'ve $i matches!');
}


/* void main() {
  nintyNine(100);
}

void nintyNine(int bNum) {
  for (int i = bNum; i > -1; i--) {
    if (i > 0) {
      {
        print(
            '$i bottles of beer on the wall, $i bottles of beer.\n Take one down and pass it around, ${i - 1} bottles of beer of on the wall.');
      }
    } else {
      print(
          'No more bottles of beer on the wall, no more bottles of beer.\n Go to the store and buy some more, 99 bottles of beer on the wall.');
    }
  }
} */