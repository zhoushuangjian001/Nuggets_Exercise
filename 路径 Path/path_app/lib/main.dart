import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Path Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Path'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CustomPaint(
          painter: PathCustomPainter(),
          child: Container(),
        ),
      ),
    );
  }
}

class PathCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    computeMetrics(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void computeMetrics(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 200);

  final Path path1 = Path();
  path1.moveTo(300, 300);
  path1.lineTo(400, 400);

  path.extendWithPath(path1, Offset.zero);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
  final PathMetrics pathMetrics = path.computeMetrics();
  final PathMetric pathMetric = pathMetrics.first;
  // 路径索引
  print(pathMetric.contourIndex);
  // 路径是否关闭
  print(pathMetric.isClosed);
  // 路径的长度
  print(pathMetric.length);
  // 扩展新的路径
  print(pathMetric.extractPath(10, 20));
  // 计算给定路径偏移的位置以及切角
  print(pathMetric.getTangentForOffset(10));
}

void combine(Canvas canvas) {
  final Path path1 = Path();
  path1.moveTo(200, 100);
  path1.lineTo(100, 300);
  path1.lineTo(300, 300);
  path1.close();

  // canvas.drawPath(
  //   path1,
  //   Paint()
  //     ..color = Colors.red
  //     ..style = PaintingStyle.stroke
  //     ..strokeWidth = 2,
  // );

  final Path path2 = Path();
  path2.moveTo(250, 200);
  path2.lineTo(400, 200);
  path2.lineTo(300, 400);
  path2.lineTo(150, 400);
  path2.close();
  // canvas.drawPath(
  //   path2,
  //   Paint()
  //     ..color = Colors.green
  //     ..style = PaintingStyle.stroke
  //     ..strokeWidth = 2,
  // );
  final Path path = Path.combine(PathOperation.reverseDifference, path1, path2);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill
      ..strokeWidth = 2,
  );
}

void getBounds(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 200);

  final Path path1 = Path();
  path1.moveTo(200, 100);
  path1.lineTo(300, 300);
  path.addPath(path1, Offset.zero);
  // path.extendWithPath(path1, Offset.zero);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  canvas.drawRect(
    path.getBounds(),
    Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void transform(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 200);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  final Matrix4 matrix4 = Matrix4.identity();
  // matrix4.translate(200.0);
  // matrix4.scale(2.0);
  matrix4.rotateZ(pi / 6);
  final Path path1 = path.transform(matrix4.storage);
  canvas.drawPath(
    path1,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void shift(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 200);
  final Path path1 = Path();
  path1.moveTo(200, 100);
  path1.lineTo(300, 200);
  path.addPath(path1, Offset.zero);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
  final Path path2 = path.shift(const Offset(200, 200));
  canvas.drawPath(
    path2,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void contains(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 200);

  final Path path1 = Path();
  path1.moveTo(300, 100);
  path1.lineTo(400, 100);
  path1.lineTo(300, 200);
  // path1.close();

  path.addPath(path1, Offset.zero);

  final bool isContains = path.contains(const Offset(200, 200));
  canvas.drawPath(
    path,
    Paint()
      ..color = isContains ? Colors.red : Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void reset(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 200);
  final Path path1 = Path();
  path1.moveTo(300, 100);
  path1.lineTo(400, 200);
  path.addPath(path1, Offset.zero);
  path.reset();
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void close(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 200);

  final Path path1 = Path();
  path1.moveTo(300, 100);
  path1.lineTo(400, 200);
  path1.lineTo(400, 500);
  // path1.close();

  path.extendWithPath(path1, Offset.zero);
  path.close();
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void extendWithPath(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 200);

  final Path path1 = Path();
  path1.moveTo(300, 100);
  path1.lineTo(400, 200);
  final Matrix4 matrix4 = Matrix4.identity();
  // matrix4.translate(100.0, 100.0);
  // matrix4.scale(2.0);
  matrix4.rotateZ(pi / 3);

  path.extendWithPath(path1, const Offset(0, 0), matrix4: matrix4.storage);

  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void addPath(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 200);

  final Path path1 = Path();
  path1.moveTo(300, 100);
  path1.lineTo(400, 200);
  final Matrix4 matrix4 = Matrix4.identity();
  // matrix4.translate(100.0, 100.0);
  // matrix4.scale(2.0);
  matrix4.rotateZ(pi / 3);

  path.addPath(path1, const Offset(0, 0), matrix4: matrix4.storage);

  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void addRRect(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 200);
  path.addRRect(RRect.fromLTRBR(300, 200, 500, 100, const Radius.circular(10)));
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void addPolygon(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(200, 100);
  path.addPolygon(const [Offset(300, 100), Offset(400, 200), Offset(300, 300)], false);
  path.addPolygon(const [Offset(500, 100), Offset(600, 100), Offset(500, 200)], true);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void addArc(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.lineTo(300, 100);
  path.addArc(Rect.fromCenter(center: const Offset(150, 200), width: 200, height: 100), pi * 0.5, pi);
  path.addArc(Rect.fromCenter(center: const Offset(500, 200), width: 200, height: 100), pi * 0.5, pi * 3);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void addOval(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 200);
  path.lineTo(200, 200);
  path.addOval(Rect.fromCenter(center: const Offset(150, 100), width: 200, height: 100));
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void addRect(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 200);
  path.lineTo(200, 300);
  path.addRect(const Rect.fromLTWH(100, 30, 100, 100));
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void relativeArcToPoint(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 200);
  path.lineTo(200, 200);
  path.relativeArcToPoint(const Offset(100, 100), radius: const Radius.circular(50));
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void arcToPoint(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 200);
  path.arcToPoint(
    const Offset(200, 200),
    radius: const Radius.circular(40),
    largeArc: true,
    clockwise: true,
    rotation: 660,
  );
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  final Path path1 = Path();
  path1.moveTo(400, 200);
  path1.arcToPoint(
    const Offset(500, 200),
    radius: const Radius.circular(60),
    largeArc: true,
    clockwise: true,
    rotation: 90080,
  );
  canvas.drawPath(
    path1,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  canvas.drawPoints(
    PointMode.points,
    [
      const Offset(100, 200),
      const Offset(200, 200),
      // const Offset(150, 200),
      const Offset(400, 200),
      const Offset(500, 200),
      // Offset(450, 200 - sqrt(pow(60, 2) - pow(50, 2)))
    ],
    Paint()
      ..color = Colors.red
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke,
  );
}

void arcTo(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.arcTo(Rect.fromCenter(center: const Offset(400, 200), width: 300, height: 200), 0, pi * 4, false);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
  canvas.drawRect(
    Rect.fromCenter(center: const Offset(400, 200), width: 300, height: 200),
    Paint()
      ..color = Colors.red.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  canvas.drawPoints(
    PointMode.points,
    [const Offset(100, 100)],
    Paint()
      ..color = Colors.red.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10,
  );
}

void relativeConicTo(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 200);
  path.relativeConicTo(100, -200, 200, 0, 2);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void conicTo(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.conicTo(250, 10, 400, 100, 6);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  final Path path1 = Path();
  path1.moveTo(100, 100);
  path1.conicTo(250, 10, 400, 100, 1);
  canvas.drawPath(
    path1,
    Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  final Path path2 = Path();
  path2.moveTo(100, 100);
  path2.conicTo(250, 10, 400, 100, 0.5);
  canvas.drawPath(
    path2,
    Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  final Path path3 = Path();
  path3.moveTo(100, 100);
  path3.conicTo(250, 10, 400, 100, 0);
  canvas.drawPath(
    path3,
    Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  canvas.drawPoints(
    PointMode.points,
    const [Offset(100, 100), Offset(250, 10), Offset(400, 100)],
    Paint()
      ..color = Colors.green
      ..strokeWidth = 6,
  );
}

void relativeCubicTo(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.relativeCubicTo(100, -80, 200, 80, 300, 0);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void cubicTo(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.cubicTo(200, 20, 300, 180, 400, 100);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );

  canvas.drawPoints(
    PointMode.points,
    const [Offset(100, 100), Offset(200, 20), Offset(300, 180), Offset(400, 100)],
    Paint()
      ..color = Colors.green
      ..strokeWidth = 6,
  );
}

void relativeQuadraticBezierTo(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 200);
  path.quadraticBezierTo(200, 300, 300, 200);
  path.relativeQuadraticBezierTo(100, -100, 200, 0);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void quadraticBezierTo(Canvas canvas) {
  final Path path = Path();
  path.moveTo(100, 100);
  path.quadraticBezierTo(200, 200, 300, 100);
  path.moveTo(400, 100);
  path.quadraticBezierTo(500, 200, 600, 100);
  path.moveTo(250, 200);
  path.quadraticBezierTo(350, 300, 450, 200);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void lineTo(Canvas canvas) {
  final Path path = Path();
  path.moveTo(10, 10);
  path.lineTo(100, 10);
  path.moveTo(10, 30);
  path.lineTo(100, 30);
  path.lineTo(100, 60);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3,
  );
}

void relativeMoveTo(Canvas canvas) {
  final Path path = Path();
  path.moveTo(10, 100);
  path.lineTo(100, 100);
  path.relativeMoveTo(100, 100);
  path.lineTo(200, 10);
  canvas.drawPath(
    path,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.red,
  );
}

void moveTo(Canvas canvas) {
// moveTo 移动画笔起始点
  final Path path = Path();
  // move1
  path.moveTo(100, 100);
  path.lineTo(200, 100);
  // move2
  path.moveTo(100, 200);
  path.lineTo(200, 200);
  // draw
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12,
  );
}

/// 路径创建方式
void createPath(Canvas canvas) {
  // 1. 创建一个空的 Path
  final Path path = Path();
  debugPrint(path.toString());

  // 2. Path.from
  // source path
  final Path path1 = Path();
  path.moveTo(10, 60);
  path.lineTo(200, 60);
  // from 构建
  final Path pathFrom = Path.from(path1);
  canvas.drawPath(
    pathFrom,
    Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12,
  );
}
