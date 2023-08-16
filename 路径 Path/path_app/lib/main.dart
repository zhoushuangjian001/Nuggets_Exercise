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
    relativeArcToPoint(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
