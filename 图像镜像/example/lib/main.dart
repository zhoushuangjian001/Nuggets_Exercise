import 'dart:async';
import 'dart:ui' as ui;
import 'package:example/fam/fam.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idkit/idkit.dart' hide IImage;
import 'package:iimage/iimage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter IImage Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter IImage Demo'),
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
  final StreamController<ui.Image> imageStreamController = StreamController.broadcast();

  // change image
  ui.Image? image;

  // The original image.
  Future<ui.Image> getImageData() async {
    final ImmutableBuffer immutableBuffer = await rootBundle.loadBuffer(FamManager.aa);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  hoverColor: Colors.transparent,
                  onPressed: () async {
                    if (image == null) return;
                    final ByteData? byteData = await image!.toByteData();
                    if (byteData == null) return;
                    image = await IImage.mirrorFromUint32List(
                      uint32list: byteData.buffer.asUint32List(),
                      imageWidth: image!.width,
                      imageHeight: image!.height,
                      mirrorType: MirrorType.lr,
                    );
                    imageStreamController.add(image!);
                  },
                  icon: Image.asset(FamManager.zy),
                ),
                IconButton(
                  hoverColor: Colors.transparent,
                  onPressed: () async {
                    if (image == null) return;
                    final ByteData? byteData = await image!.toByteData();
                    if (byteData == null) return;
                    image = await IImage.mirrorFromImage(
                      image: image!,
                      mirrorType: MirrorType.td,
                    );
                    imageStreamController.add(image!);
                  },
                  icon: Image.asset(FamManager.sx),
                ),
              ],
            ),
            10.vGap,
            FutureBuilder(
              future: getImageData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('图像加载中...');
                }
                if (snapshot.hasError) {
                  return const Text('图像加载失败!');
                }
                image = snapshot.data;
                return StreamBuilder<ui.Image>(
                  initialData: image,
                  stream: imageStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('图像镜像失败!!!');
                    }
                    if (snapshot.data == null) {
                      return const Text('图像镜像图为 null');
                    }
                    return IDKitImage.image(image: snapshot.data!);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    imageStreamController.close();
    super.dispose();
  }
}
