// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: unused_local_variable

import 'dart:core';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Flutter-Record-0', () {
    // 1. 在记录表达式中位置字段是`前面没有冒号(:)的对象`；命名字段是`前面带冒号（:）的对象。
    (110, name: '王昭君', ['1', 1], info: {'a': 1});

    // 2. 在声明记录变量时注释中，`位置字段在大括号外；
    // 命名字段在大括号内，且命名字段要在所有位置字段之后`
    (int, bool, {int age, String name}) ageAndName;
  });
  test('Flutter-Record-1', () {
    // 1. 记录表达式是以逗号分隔的命名或位置字段列表，括在括号中。
    var record = ('first', a: 110, {'a': 220}, true);
    print(record.runtimeType);
    // (String, _Map<String, int>, bool, {int a})
  });

  test('Flutter-Record-2', () {
    // 2. 记录类型注释是括在括号中的以逗号分隔的类型列表。您可以使用记录类型注释来定义返回类型和参数类型。例如，以下(int, String) 或者 (String, int) 语句是记录类型注释。
    (int, String) swapItem((String, int) records) {
      return (records.$2, records.$1);
    }

    print(swapItem(('火警', 119)));
  });

  test('Flutter-Record-3', () {
    // 3. 记录表达式和类型注释中的字段反映了参数和参数在函数中的工作方式。位置字段直接位于括号内。
    (int, String) ageAndName;
    ageAndName = (20, '王昭君');
    print(ageAndName);
  });

  test('Flutter-Record-4', () {
    // 4. 在记录类型注释中，命名字段位于类型和名称对的大括号分隔部分内，
    // 位于所有位置字段之后。在记录表达式中，名称位于每个字段值之前，后面带有冒号。
    (bool, {int age, String name}) ageAndName;
    ageAndName = (true, age: 18, name: '王昭君');
    print(ageAndName);
  });

  test('Flutter-Record-4:1', () {
    // 4. 在记录类型注释中，命名字段位于类型和名称对的大括号分隔部分内，
    // 位于所有位置字段之后。在记录表达式中，名称位于每个字段值之前，后面带有冒号。
    (int, bool, {int age, String name}) ageAndName;
    ageAndName = (10, true, age: 18, name: '王昭君');
    print(ageAndName);
  });

  test('Flutter-Record-5', () {
    // 5. 记录类型中命名字段的名称是记录类型定义或其形状的一部分。
    // `具有不同名称的命名字段的两条记录具有不同的类型`
    ({int age, String name}) ageAndName = (age: 10, name: '王昭君');
    ({int weight, String nick}) weightAndNick = (weight: 10, nick: '王昭君');
    print(ageAndName.runtimeType); // ({int age, String name})
    print(weightAndNick.runtimeType); // ({String nick, int weight})
  });

  test('Flutter-Record-6', () {
    // 6. 在记录类型注释中，您还可以命名位置字段，但这些名称纯粹用于文档，不会影响记录的类型。
    (int age, String name) ageAndName = (10, '王昭君');
    (int weight, String nick) weightAndNick = (10, '王昭君');
    print(ageAndName.runtimeType); // (int, String)
    print(weightAndNick.runtimeType); // (int, String)
  });

  test('Flutter-Record-访问', () {
    var infoRecord = ('王昭君', age: 18, sex: true, 1000);
    print(infoRecord.$1);
    print(infoRecord.$2);
    print(infoRecord.age);
    print(infoRecord.sex);
  });

  test('Flutter-Record-访问', () {
    (String, int, {int age, bool sex}) infoRecord = ('王昭君', age: 18, sex: true, 1000);
    print(infoRecord.$1);
    print(infoRecord.$2);
    print(infoRecord.age);
    print(infoRecord.sex);
  });

  test('Flutter-Record-类型', () {
    // var record = (10, '10.0', null);
    // var record = (10, a: '10.0', null, b: 2.0);
    // var record = (a: '10.0', b: 2.0);
    var record = (10, a: 10, b: '2', true);
    print(record.runtimeType);
  });

  test('Flutter-Record-应用', () {
    (int, String) getTickInfo() {
      return (10, '郑州');
    }

    var (count, name) = getTickInfo();
    print(count);
    print(name);

    var record = getTickInfo();
    print(record.$1);
    print(record.$2);
  });
}
