import 'package:flutter/material.dart';

class PinPainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  PinPainter({required this.color, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2 - 5;

    // Glow effect
    if (isSelected) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        28,
        Paint()
          ..color = color.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    // Shadow
    canvas.drawCircle(
      Offset(centerX, centerY),
      18,
      Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Selection ring
    if (isSelected) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        22,
        Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // Pin head
    canvas.drawCircle(Offset(centerX, centerY), 16, Paint()..color = color);

    // Inner circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      8,
      Paint()..color = const Color(0xFF131318),
    );

    // Pin stem
    final path = Path()
      ..moveTo(centerX - 4, centerY + 10)
      ..lineTo(centerX, size.height - 2)
      ..lineTo(centerX + 4, centerY + 10)
      ..close();

    canvas.drawPath(path, Paint()..color = color.withOpacity(0.8));
  }

  @override
  bool shouldRepaint(covariant PinPainter oldDelegate) {
    return oldDelegate.isSelected != isSelected || oldDelegate.color != color;
  }
}
