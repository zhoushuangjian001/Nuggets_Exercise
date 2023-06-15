import 'dart:async';

import 'dart:ui' as ui;

import 'package:app/fam/fam.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:idkit/idkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter 泛洪算法'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _key = GlobalKey();
  ui.Image? image;
  Color? selectColor;
  StreamController<ui.Image?> controller = StreamController.broadcast();
  late double pixel = ui.window.devicePixelRatio * 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: IDKitChoice<String>.warp(
              sources: const <String>['#DC143C', '#DA70D6', '#0000FF', '#00FF00', '#FFFF00', '#FF0000'],
              itemBuilder: (context, state, data) {
                return Draggable(
                  feedback: SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        color: data.color,
                      ),
                    ),
                  ),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: data.color,
                  ).insetsOnly(right: 10),
                  onDragStarted: () => selectColor = data.color,
                  onDraggableCanceled: (velocity, offset) {
                    offset = offset.translate(30, -25);
                    final RenderRepaintBoundary? renderRepaintBoundary =
                        _key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
                    if (renderRepaintBoundary.isNoNull) {
                      final Offset imageOffset = offset.translate(0, -60);
                      ui.Image image = renderRepaintBoundary!.toImageSync(pixelRatio: pixel);
                      rednessTreatment(image, imageOffset * pixel, selectColor);
                    } else {
                      IDKitLog.value('截图失败!!!');
                    }
                  },
                );
              },
            ),
          ),
          Expanded(
            child: RepaintBoundary(
              key: _key,
              child: StreamBuilder<ui.Image?>(
                  initialData: image,
                  stream: controller.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data.isNoNull) {
                      return IDKitImage.image(image: snapshot.data!);
                    }
                    return ColoredBox(
                      color: Colors.black,
                      child: Center(child: Image.asset(FamManager.ab)),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  /// 泛红处理
  void rednessTreatment(ui.Image image, Offset offset, Color? fColor) async {
    if (fColor.isNull) return;
    final ui.Image image1 =
        await image.ciede2000Flooding(offset: offset, fillColor: fColor!, isDispose: true, tolerance: 2.3);
    if (image1.isNoNull) {
      controller.add(image1);
    }
  }
}
