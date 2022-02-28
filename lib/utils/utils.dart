import 'dart:math';

int generateId() {
  final _random = Random();

  return 0 + _random.nextInt(9999 - 0);
}
