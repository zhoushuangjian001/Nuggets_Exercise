import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
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
      home: const MyHomePage(title: 'Flutter 泛红算法'),
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
  Image? image;
  StreamController<Image?> controller = StreamController.broadcast();

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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: data.color,
                        ),
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: data.color,
                  ).insetsOnly(right: 10),
                  onDraggableCanceled: (velocity, offset) {
                    final RenderRepaintBoundary? renderRepaintBoundary =
                        _key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
                    if (renderRepaintBoundary.isNoNull) {
                      final Offset imageOffset = renderRepaintBoundary!.globalToLocal(offset);
                      Image image = renderRepaintBoundary.toImageSync(pixelRatio: window.devicePixelRatio);
                      rednessTreatment(image, imageOffset);
                    } else {
                      IDKitLog.value('截图失败!!!');
                    }
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Listener(
              onPointerMove: (event) {
                // IDKitLog.value(event);
              },
              child: RepaintBoundary(
                key: _key,
                child: StreamBuilder<Image?>(
                    initialData: image,
                    stream: controller.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data.isNoNull) {
                        return IDKitImage.image(image: snapshot.data!);
                      }
                      return Container(
                        color: Colors.red,
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 泛红处理
  void rednessTreatment(Image image, Offset offset) async {
    final int width = image.width;
    final int height = image.height;
    final bool isContent = offset.dx <= width && offset.dx >= 0 && offset.dy <= height && offset.dy >= 0;
    Uint32List? uint32list = await image.uint32List();
    if (uint32list.isNoNull && isContent) {
      final int index = width * offset.dy.floor() + offset.dx.floor();
      final Color color = uint32list![index].int32toColor;
      uint32list[index] = 981170690;
      distributed(offset, color, width, height, uint32list);
      print('--');
      decodeImageFromPixels(uint32list.buffer.asUint8List(), width, height, PixelFormat.rgba8888, (result) {
        controller.add(result);
      });
    }
  }

  void distributed(Offset offset, Color color, int width, int height, Uint32List uint32list) {
    int dy = offset.dy.floor();
    int dx = offset.dx.floor();
    for (int iy = dy; iy >= 0; iy--) {
      for (int i = dx; i < width; i++) {
        final int index = width * iy + i;
        final Color c = uint32list[index].int32toColor;
        if (!c.euclideanDistanceColorDifference(color)) {
          uint32list[index] = 981170690;
        } else {
          break;
        }
      }

      for (int i = dx; i >= 0; i--) {
        final int index = width * iy + i;
        final Color c = uint32list[index].int32toColor;
        if (!c.euclideanDistanceColorDifference(color)) {
          uint32list[index] = 981170690;
        } else {
          break;
        }
      }
    }

    for (var i = offset.dy; i < height; i++) {
      for (var i = offset.dx; i < width; i++) {}

      for (var i = offset.dx; i >= 0; i--) {}
    }
  }

  void aa(Offset offset, Color color, int width, int height, Uint32List uint32list, String mark) {
    // print('xxx - $mark');

    final Offset offset1 = offset + const Offset(0, -1);
    final int index1 = width * offset.dy.floor() + offset.dx.floor();
    final Color color1 = uint32list[index1].int32toColor;
    if (!color1.euclideanDistanceColorDifference(color) &&
        offset1.dx <= width &&
        offset1.dx >= 0 &&
        offset1.dy <= height &&
        offset1.dy >= 0) {
      uint32list[index1] = 981170690;
      aa(offset1, color, width, height, uint32list, 'offset1');
      // print('aa1 - $mark');
    } else {
      // print('oo----- $mark');
    }

    // final Offset offset2 = offset + const Offset(1, -1);
    // final int index2 = width * offset.dy.floor() + offset.dx.floor();
    // final Color color2 = uint32list[index2].int32toColor;
    // if (!color2.euclideanDistanceColorDifference(color) &&
    //     offset2.dx <= width &&
    //     offset2.dx >= 0 &&
    //     offset2.dy <= height &&
    //     offset2.dy >= 0) {
    //   uint32list[index2] = 981170690;

    //   aa(offset2, color, width, height, uint32list, 'offset2');
    //   // print('aa2 - $mark');
    // } else {
    //   // print('oo----- $mark');
    // }

    // final Offset offset3 = offset + const Offset(1, 0);
    // final int index3 = width * offset.dy.floor() + offset.dx.floor();
    // final Color color3 = uint32list[index3].int32toColor;
    // if (!color3.euclideanDistanceColorDifference(color) &&
    //     offset3.dx <= width &&
    //     offset3.dx >= 0 &&
    //     offset3.dy <= height &&
    //     offset3.dy >= 0) {
    //   uint32list[index3] = 981170690;

    //   aa(offset3, color, width, height, uint32list, 'offset3');
    //   // print('aa3 - $mark');
    // } else {
    //   // print('oo----- $mark');
    // }

    // final Offset offset4 = offset + const Offset(1, 1);
    // final int index4 = width * offset.dy.floor() + offset.dx.floor();
    // final Color color4 = uint32list[index4].int32toColor;
    // if (!color4.euclideanDistanceColorDifference(color) &&
    //     offset4.dx <= width &&
    //     offset4.dx >= 0 &&
    //     offset4.dy <= height &&
    //     offset4.dy >= 0) {
    //   uint32list[index4] = 981170690;
    //   aa(offset4, color, width, height, uint32list, 'offset4');
    //   // print('aa4 - $mark');
    // } else {
    //   // print('oo----- $mark');
    // }

    final Offset offset5 = offset + const Offset(0, 1);
    final int index5 = width * offset.dy.floor() + offset.dx.floor();
    final Color color5 = uint32list[index5].int32toColor;
    if (!color5.euclideanDistanceColorDifference(color) &&
        offset5.dx < width &&
        offset5.dx >= 0 &&
        offset5.dy < height &&
        offset5.dy >= 0) {
      uint32list[index5] = 981170690;
      aa(offset5, color, width, height, uint32list, 'offset5');
      // print('aa5 - $mark');
    } else {
      // print('oo----- $mark');
    }
    // final Offset offset6 = offset + const Offset(-1, 1);
    // final int index6 = width * offset.dy.floor() + offset.dx.floor();
    // final Color color6 = uint32list[index6].int32toColor;
    // if (!color6.euclideanDistanceColorDifference(color) &&
    //     offset6.dx <= width &&
    //     offset6.dx >= 0 &&
    //     offset6.dy <= height &&
    //     offset6.dy >= 0) {
    //   uint32list[index6] = 981170690;
    //   aa(offset6, color, width, height, uint32list, 'offset6');
    //   // print('aa6 - $mark');
    // } else {
    //   // print('oo----- $mark');
    // }

    // final Offset offset7 = offset + const Offset(-1, 0);
    // final int index7 = width * offset.dy.floor() + offset.dx.floor();
    // final Color color7 = uint32list[index7].int32toColor;
    // if (!color7.euclideanDistanceColorDifference(color) &&
    //     offset7.dx <= width &&
    //     offset7.dx >= 0 &&
    //     offset7.dy <= height &&
    //     offset7.dy >= 0) {
    //   uint32list[index7] = 981170690;
    //   aa(offset7, color, width, height, uint32list, 'offset7');
    //   // print('aa7 - $mark');
    // } else {
    //   // print('oo----- $mark');
    // }

    // final Offset offset8 = offset + const Offset(-1, -1);
    // final int index8 = width * offset.dy.floor() + offset.dx.floor();
    // final Color color8 = uint32list[index6].int32toColor;
    // if (!color8.euclideanDistanceColorDifference(color) &&
    //     offset8.dx <= width &&
    //     offset8.dx >= 0 &&
    //     offset8.dy <= height &&
    //     offset8.dy >= 0) {
    //   uint32list[index8] = 981170690;
    //   aa(offset8, color, width, height, uint32list, 'offset8');
    //   // print('aa8 - $mark');
    // } else {
    //   // print('oo----- $mark');
    // }

    [offset1, offset5].iFor((index, element) {
      aa(element, color, width, height, uint32list, mark);
    });
  }
}
