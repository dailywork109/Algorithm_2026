int arr[];

void setup() {
  int i, j, tmp;
  arr = new int[10];
  for (i=0; i<arr.length; i++) {
    arr[i] = (int) random(100);
  }
  for (i=0; i<arr.length; i++) {
    print(arr[i], " ");
  }
  println();
  println();

  for (i = 0; i < arr.length - 1; i++) {
    for (j = 0; j < arr.length - 1 - i; j++) {
      if (arr[j] > arr[j+1]) {
        tmp = arr[j + 1];
        arr[j + 1] = arr[j];
        arr[j] = tmp;
      }
    }
  }

  for (i = 0; i < arr.length; i++) {
    print(arr[i], " ");
  }
}
