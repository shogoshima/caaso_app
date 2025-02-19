import 'package:flutter/material.dart';

class OverlayWithHole extends StatelessWidget {
  const OverlayWithHole({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final squareSize = size.width * 0.8;
    final holeRect = Rect.fromLTWH(
      (size.width - squareSize) / 2,
      (size.height - squareSize) / 10,
      squareSize,
      squareSize,
    );
    // Define the border radius
    final borderRadius = BorderRadius.circular(30.0);
    final holeRRect = RRect.fromRectAndCorners(
      holeRect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    return CustomPaint(
      size: size,
      painter: HolePainter(holeRRect: holeRRect),
    );
  }
}

class HolePainter extends CustomPainter {
  final RRect holeRRect;
  HolePainter({required this.holeRRect});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black45;
    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()..addRRect(holeRRect);
    final overlayPath =
        Path.combine(PathOperation.difference, fullPath, holePath);
    canvas.drawPath(overlayPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
