// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idkit/idkit.dart';

void main() {
  const int count = 1000;
  const int itemCount = 1000;
  final List<String> testList = List.generate(itemCount, (index) => '循环测试-$index ');
  test('For 循环的性能测试', () {
    final List<int> timeList = [];
    for (var i = 0; i < count; i++) {
      final Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      for (var i = 0; i < testList.length; i++) {}
      stopwatch.stop();
      timeList.add(stopwatch.elapsedMicroseconds);
    }
    debugPrint('For 循环的 $count 次, 每次 $itemCount 个数据的测试的平均耗时: ${timeList.average} 微妙。');
  });

  test('For-In 循环的性能测试', () {
    final List<int> timeList = [];
    for (var i = 0; i < count; i++) {
      final Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      for (var element in testList) {}
      stopwatch.stop();
      timeList.add(stopwatch.elapsedMicroseconds);
    }
    debugPrint('For - In 循环的 $count 次, 每次 $itemCount 个数据的测试的平均耗时: ${timeList.average} 微妙。');
  });

  test('forEach 循环的性能测试', () {
    final List<int> timeList = [];
    for (var i = 0; i < count; i++) {
      final Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      testList.forEach((element) {});
      stopwatch.stop();
      timeList.add(stopwatch.elapsedMicroseconds);
    }
    debugPrint('forEach 循环的 $count 次, 每次 $itemCount 个数据的测试的平均耗时: ${timeList.average} 微妙。');
  });

  test('While 循环的性能测试', () {
    final List<int> timeList = [];
    for (var i = 0; i < count; i++) {
      final Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      int j = 0;
      while (j < testList.length) {
        j++;
      }
      stopwatch.stop();
      timeList.add(stopwatch.elapsedMicroseconds);
    }
    debugPrint('While 循环的 $count 次, 每次 $itemCount 个数据的测试的平均耗时: ${timeList.average} 微妙。');
  });

  test('do - while 循环的性能测试', () {
    final List<int> timeList = [];
    for (var i = 0; i < count; i++) {
      final Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      int j = 0;
      do {
        j++;
      } while (j < testList.length);
      stopwatch.stop();
      timeList.add(stopwatch.elapsedMicroseconds);
    }
    debugPrint('do - while 循环的 $count 次, 每次 $itemCount 个数据, 测试的平均耗时: ${timeList.average} 微妙。');
  });
}
