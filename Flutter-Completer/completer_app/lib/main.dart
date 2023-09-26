import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:math' hide log;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // getCountOfTicket().then((value) => print(value));

  final Stopwatch stopwatch = Stopwatch();

  void _incrementCounter() {
    syncCompleter();
  }

  // MARK: -- 同步
  void syncCompleter() {
    log('sync: 0');
    syncCompleterMethod()
        .then((value) {
          stopwatch.stop();
          log(stopwatch.elapsedMicroseconds.toString());
          log('返回数据:$value');
        })
        .whenComplete(() => log('请求完成'))
        .catchError((err) => log('请求失败:${err.toString()}'));
    log('sync: 4');
  }

  Future<int> syncCompleterMethod() {
    // final Completer<int> syncCompleter = Completer();
    final Completer<int> syncCompleter = Completer.sync();

    log('sync: 1');
    syncCompleter.future.then((value) => log('sync: 2'));
    syncCompleter.complete(1);
    log('sync: 3');
    stopwatch.start();
    return syncCompleter.future;
  }

  // MARK: -- 嵌套
  void nestedCompleter() {
    nestedMethod()
        .then((value) => log('返回数据:$value'))
        .whenComplete(() => log('请求完成'))
        .catchError((err) => log('请求失败:${err.toString()}'));
  }

  Future<String> nestedMethod() {
    final Completer<int> countCompleter = Completer();
    final Completer<String> markCompleter = Completer();
    countCompleter.complete(10);
    countCompleter.future.then((value) => markCompleter.complete('票数:$value'));
    return markCompleter.future;
  }

  // MARK: -- 基础
  void baseMethod() {
    completerDemo()
        .then((value) => log('返回数据:$value'))
        .whenComplete(() => log('请求完成'))
        .catchError((err) => log('请求失败:${err.toString()}'));
  }

  Future<int> completerDemo() {
    final Completer<int> completer = Completer();
    Future.delayed(const Duration(seconds: 5), () {
      final int value = Random().nextInt(10);
      if (value < 5) {
        completer.complete(value);
      } else {
        completer.completeError('失败');
      }
    });
    return completer.future;
  }

  // MARK: -- 小明买票
  void bayTicket() {
    getCountOfTicket()
        .then((value) => log('返回数据:$value'))
        .whenComplete(() => log('请求完成'))
        .catchError((err) => log('请求失败:${err.toString()}'));
  }

  Future<String> getCountOfTicket() {
    final Completer<String> completer = Completer();
    findLastTicket('北京').then((value) {
      if (!completer.isCompleted) {
        completer.complete('${value['city']} - ${value['count']}');
      }
    });
    findLastTicket('上海').then((value) {
      completer.complete('${value['city']} - ${value['count']}');
      if (!completer.isCompleted) {
        completer.complete('${value['city']} - ${value['count']}');
      }
    });
    findLastTicket('郑州').then((value) {
      if (!completer.isCompleted) {
        completer.complete('${value['city']} - ${value['count']}');
      }
    });
    return completer.future;
  }

  Future<Map> findLastTicket(String value) {
    final int count = Random().nextInt(4) + 1;
    return Future.delayed(Duration(seconds: count), () {
      return {
        'count': count,
        'city': value,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
