import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idkit/idkit.dart' hide IImage;
import 'package:iimage/iimage.dart';

import 'fam/fam.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FImage Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter FImage Demo'),
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
  // image change stream
  final StreamController<ui.Image?> imageStreamAaController = StreamController.broadcast();

  // The original image.
  Future<ui.Image> getImageData(String key) async {
    final ImmutableBuffer immutableBuffer = await rootBundle.loadBuffer(key);
    final ui.Codec codec = await ui.instantiateImageCodecFromBuffer(immutableBuffer);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(FamManager.aa),
            20.vGap,
            GestureDetector(
              child: const Text('去色 - 最大小算法'),
              onTap: () async {
                final ui.Image image = await getImageData(FamManager.aa);
                final ui.Image? imageD = await IImage.desaturationFromImage(
                    image: image, desaturationAlgorithm: DesaturationAlgorithm.average);
                imageStreamAaController.add(imageD);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PS去色'),
                    Image.asset(FamManager.psAa),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('去色'),
                    StreamBuilder<ui.Image?>(
                      initialData: null,
                      stream: imageStreamAaController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('图像镜像失败!!!');
                        }
                        if (snapshot.data == null) {
                          return const Center(child: Text('去色站位'));
                        }
                        return IDKitImage.image(image: snapshot.data!);
                      },
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    imageStreamAaController.close();
    super.dispose();
  }
}
