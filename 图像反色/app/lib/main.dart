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
  final StreamController<ui.Image?> imageStreamHdController = StreamController.broadcast();
  final StreamController<ui.Image?> imageStreamFSController = StreamController.broadcast();

  // 灰度
  ui.Image? hdImage;

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
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('原图'),
                      Image.asset(FamManager.aa),
                    ],
                  ),
                ),
                GestureDetector(
                  child: const Text('原图 => 反色'),
                  onTap: () async {
                    final ui.Image image = await getImageData(FamManager.aa);
                    final ui.Image? imageD = await IImage.invertFromImage(image: image);
                    imageStreamAaController.add(imageD);
                  },
                ).insetsSymmetric(horizontal: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('反色图像'),
                      StreamBuilder<ui.Image?>(
                        initialData: null,
                        stream: imageStreamAaController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('图像镜像失败!!!');
                          }
                          if (snapshot.data == null) {
                            return const Center(child: Text('图像反色占位'));
                          }
                          return IDKitImage.image(image: snapshot.data!);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ).insetsSymmetric(horizontal: 10),
            20.vGap,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('原图'),
                      Image.asset(FamManager.bb),
                    ],
                  ),
                ),
                GestureDetector(
                  child: const Text('原图 => 灰度'),
                  onTap: () async {
                    final ui.Image image = await getImageData(FamManager.bb);
                    final ui.Image? imageD = await IImage.desaturationFromImage(image: image);
                    hdImage = imageD;
                    imageStreamHdController.add(imageD);
                  },
                ).insetsSymmetric(horizontal: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('灰度图'),
                      StreamBuilder<ui.Image?>(
                        initialData: null,
                        stream: imageStreamHdController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('图像灰度失败!!!');
                          }
                          if (snapshot.data == null) {
                            return const Center(child: Text('灰度图占位'));
                          }
                          return IDKitImage.image(image: snapshot.data!);
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: const Text('灰度 => 反色'),
                  onTap: () async {
                    if (hdImage != null) {
                      final ui.Image? imageD = await IImage.invertFromImage(image: hdImage!);
                      imageStreamFSController.add(imageD);
                    }
                  },
                ).insetsSymmetric(horizontal: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('灰度反色图'),
                      StreamBuilder<ui.Image?>(
                        initialData: null,
                        stream: imageStreamFSController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('灰度图像反色失败!!!');
                          }
                          if (snapshot.data == null) {
                            return const Center(child: Text('反色图占位'));
                          }
                          return IDKitImage.image(image: snapshot.data!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ).insetsSymmetric(horizontal: 10)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    imageStreamAaController.close();
    imageStreamHdController.close();
    imageStreamFSController.close();
    super.dispose();
  }
}
