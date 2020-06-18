abs(value) => value > 0 ? value : -value;

int binarySearch(List<int> array, int start, int end, int key) {
  if (start > end) return -1;

  if (array[start] == key) return start;
  if (array[end] == key) return end;

  final middle = start + (end-start) ~/ 2;

  if (array[middle] == key) return middle;

  if (array[middle] > key) {
    return binarySearch(array, start, middle - 1, key);
  } else {
    return binarySearch(array, middle + 1, end, key);
  }

}