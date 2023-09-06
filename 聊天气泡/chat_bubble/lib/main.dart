import 'dart:ui' as ui;

import 'package:chat_bubble/fam/fam.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
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
      home: const MyWidgetCanvas(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
          decoration: const BoxDecoration(
            image: DecorationImage(
              centerSlice: Rect.fromLTWH(10 / 2, 15 / 2, 3 / 2, 3 / 2),
              image: AssetImage(FamManager.db),
              scale: 2,
            ),
          ),
          child: const Text(
            'Flutter 聊化聊化聊化聊化聊化化聊化聊化聊化聊化聊化聊化聊化',
            style: TextStyle(color: Colors.red),
          ).insetsSymmetric(vertical: 20, horizontal: 20),
        ),
      ),
    );
  }
}

class MyWidgetCanvas extends StatelessWidget {
  const MyWidgetCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder(
          future: getImageFromAssets(FamManager.db),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.active) {
              return const Text('加载中');
            }
            return CustomPaint(
              painter: ChatBubblePainter(snapshot.data!),
              child: const Text(
                'Flutter 聊化聊化聊化聊化聊化聊化化聊化聊化聊化化聊化聊化聊化化聊聊化',
                style: TextStyle(color: Colors.red),
              ).insetsSymmetric(vertical: 20, horizontal: 20),
            );
          },
        ),
      ),
    );
  }

  Future<ui.Image> getImageFromAssets(String path) async {
    final ImmutableBuffer immutableBuffer = await rootBundle.loadBuffer(path);
    final ui.Codec codec = await ui.instantiateImageCodecFromBuffer(
      immutableBuffer,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

class ChatBubblePainter extends CustomPainter {
  const ChatBubblePainter(this.image);
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageNine(image, const Rect.fromLTWH(10 / 2, 15 / 2, 3 / 2, 3 / 2), Offset.zero & size, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
