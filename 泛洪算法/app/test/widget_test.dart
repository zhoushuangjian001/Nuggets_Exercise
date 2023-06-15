// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('测试', () {
    var a = ListQueue();
    a.add(1);
    a.add(2);

    var b = a.removeFirst();
    print(b);
    print(a);
  });
}
