import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:idkit/idkit.dart';

void main() {
  /// For 循环的性能测试
  test('For 循环的性能测试', () {
    const count = 100;
    final List<String> testList = List.generate(100000, (index) => '循环测试-$index');
    final List<int> timeList = [];
    for (var i = 0; i < count; i++) {
      final Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      for (var i = 0; i < testList.length; i++) {
        testList[i];
      }
      stopwatch.stop();
      timeList.add(stopwatch.elapsedMicroseconds);
    }
    debugPrint('For 循环的 $count 次测试的平均耗时: ${timeList.average} 微妙。');
  });

  /// For-In 循环的性能测试
  test('For-In 循环的性能测试', () {
    const int count = 100;
    const int itemCount = 100000;
    final List<String> testList = List.generate(itemCount, (index) => '循环测试-$index');
    final List<int> timeList = [];
    for (var i = 0; i < count; i++) {
      final Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      for (var element in testList) {
        element;
      }
      stopwatch.stop();
      timeList.add(stopwatch.elapsedMicroseconds);
    }
    debugPrint('For - In 循环的 $count 次, 每次 $itemCount 个数据的测试的平均耗时: ${timeList.average} 微妙。');
  });

  test('forEach 循环的性能测试', () {
    const int count = 100;
    const int itemCount = 100000;
    final List<String> testList = List.generate(itemCount, (index) => '循环测试-$index');
    final List<int> timeList = [];
    for (var i = 0; i < count; i++) {
      final Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      testList.forEach((element) {
        element;
      });
      stopwatch.stop();
      timeList.add(stopwatch.elapsedMicroseconds);
    }
    debugPrint('forEach 循环的 $count 次, 每次 $itemCount 个数据的测试的平均耗时: ${timeList.average} 微妙。');
  });

  test('do - while 循环的性能测试', () {
    const count = 100;
    const itemCount = 100000;
    final List<String> testList = List.generate(itemCount, (index) => '循环测试-$index');
    final List<int> timeList = [];
    for (var i = 0; i < count; i++) {
      final Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      int j = 0;
      do {
        testList[j];
        j++;
      } while (j < testList.length);
      stopwatch.stop();
      timeList.add(stopwatch.elapsedMicroseconds);
    }
    debugPrint('do - while 循环的 $count 次, 每次 $itemCount 个数据, 测试的平均耗时: ${timeList.average} 微妙。');
  });

  test('While 循环的性能测试', () {
    const int count = 100;
    const int itemCount = 100000;
    final List<String> testList = List.generate(itemCount, (index) => '循环测试-$index');
    final List<int> timeList = [];
    for (var i = 0; i < count; i++) {
      final Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      int j = 0;
      while (j < testList.length) {
        testList[j];
        j++;
      }
      stopwatch.stop();
      timeList.add(stopwatch.elapsedMicroseconds);
    }
    debugPrint('While 循环的 $count 次, 每次 $itemCount 个数据的测试的平均耗时: ${timeList.average} 微妙。');
  });

  // test('数据转换 map - 性能测试', () {
  //   final List<int> testList = List.generate(10, (index) => index);
  //   final List<int> timeList = [];
  //   for (var i = 0; i < cycleCount; i++) {
  //     List<String> l = [];
  //     final Stopwatch stopwatch = Stopwatch();
  //     stopwatch.start();
  //     l = testList.map((e) => '$e').toList();
  //     debugPrint(l.toString());
  //     stopwatch.stop();
  //     timeList.add(stopwatch.elapsedMicroseconds);
  //   }
  //   debugPrint('数据转换 map 性能测试的 $cycleCount 次测试的平均耗时: ${timeList.average} 微妙。');
  // });

  // test('数据转换 forEach - 性能测试', () {
  //   final List<int> testList = List.generate(10, (index) => index);
  //   final List<int> timeList = [];
  //   for (var i = 0; i < cycleCount; i++) {
  //     List<String> l = [];
  //     final Stopwatch stopwatch = Stopwatch();
  //     stopwatch.start();
  //     testList.forEach((element) {
  //       l.add('$element');
  //     });
  //     debugPrint(l.toString());
  //     stopwatch.stop();
  //     timeList.add(stopwatch.elapsedMicroseconds);
  //   }
  //   debugPrint('数据转换 forEach 性能测试的 $cycleCount 次测试的平均耗时: ${timeList.average} 微妙。');
  // });

  // test('数据转换 For - 性能测试', () {
  //   final List<int> testList = List.generate(10, (index) => index);
  //   final List<int> timeList = [];
  //   for (var i = 0; i < cycleCount; i++) {
  //     List<String> l = [];
  //     final Stopwatch stopwatch = Stopwatch();
  //     stopwatch.start();
  //     for (var i = 0; i < testList.length; i++) {
  //       l.add('${testList[i]}');
  //     }
  //     debugPrint(l.toString());
  //     stopwatch.stop();
  //     timeList.add(stopwatch.elapsedMicroseconds);
  //   }
  //   debugPrint('数据转换 For 性能测试的 $cycleCount 次测试的平均耗时: ${timeList.average} 微妙。');
  // });

  // test('数据转换 For-In - 性能测试', () {
  //   final List<int> testList = List.generate(10, (index) => index);
  //   final List<int> timeList = [];
  //   for (var i = 0; i < cycleCount; i++) {
  //     List<String> l = [];
  //     final Stopwatch stopwatch = Stopwatch();
  //     stopwatch.start();
  //     for (var element in testList) {
  //       l.add('$element');
  //     }
  //     debugPrint(l.toString());
  //     stopwatch.stop();
  //     timeList.add(stopwatch.elapsedMicroseconds);
  //   }
  //   debugPrint('数据转换 For-In 性能测试的 $cycleCount 次测试的平均耗时: ${timeList.average} 微妙。');
  // });
}
