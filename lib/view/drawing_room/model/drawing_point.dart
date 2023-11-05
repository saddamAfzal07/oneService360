import 'package:flutter/material.dart';

// class DrawingPoint {
//   int id;
//   List<Offset> offsets;
//   Color color;
//   double width;

//   DrawingPoint({
//     this.id = -1,
//     this.offsets = const [],
//     this.color = Colors.black,
//     this.width = 2,
//   });

//   DrawingPoint copyWith({List<Offset>? offsets}) {
//     return DrawingPoint(
//       id: id,
//       color: color,
//       width: width,
//       offsets: offsets ?? this.offsets,
//     );
//   }
// }
class DrawingPoint {
  final int id;
  final List<Offset> offsets;
  final Color color;
  final double width;

  DrawingPoint({
    required this.id,
    required this.offsets,
    required this.color,
    required this.width,
  });

  DrawingPoint copyWith({
    List<Offset>? offsets,
  }) {
    return DrawingPoint(
      id: this.id,
      offsets: offsets ?? this.offsets,
      color: this.color,
      width: this.width,
    );
  }
}
