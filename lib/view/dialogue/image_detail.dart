import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';
import 'package:flutter_svg/svg.dart';
import 'package:measurment_app/res/constant/colors.dart';
import 'package:measurment_app/utils/fading_circular_indicator.dart';
// import 'package:measurment_app/view/drawing_class.dart/drawing_class.dart';

import 'package:measurment_app/view/measurment/edit_add_measurnment.dart';

const Map<String, dynamic> _testLine1 = <String, dynamic>{
  'type': 'StraightLine',
  'startPoint': <String, dynamic>{
    'dx': 68.94337550070736,
    'dy': 62.05980083656557
  },
  'endPoint': <String, dynamic>{
    'dx': 277.1373386828114,
    'dy': 277.32029957032194
  },
  'paint': <String, dynamic>{
    'blendMode': 3,
    'color': 4294198070,
    'filterQuality': 3,
    'invertColors': false,
    'isAntiAlias': false,
    'strokeCap': 1,
    'strokeJoin': 1,
    'strokeWidth': 4.0,
    'style': 1
  }
};

const Map<String, dynamic> _testLine2 = <String, dynamic>{
  'type': 'Eraser',
  'startPoint': <String, dynamic>{
    'dx': 106.35164817830423,
    'dy': 255.9575653134524
  },
  'endPoint': <String, dynamic>{
    'dx': 292.76034659254094,
    'dy': 92.125586665872
  },
  'paint': <String, dynamic>{
    'blendMode': 3,
    'color': 4294967295,
    'filterQuality': 3,
    'invertColors': false,
    'isAntiAlias': false,
    'strokeCap': 1,
    'strokeJoin': 1,
    'strokeWidth': 4.0,
    'style': 1
  }
};

/// 自定义绘制三角形
class Triangle extends PaintContent {
  Triangle();

  Triangle.data({
    required this.startPoint,
    required this.A,
    required this.B,
    required this.C,
    required Paint paint,
  }) : super.paint(paint);

  factory Triangle.fromJson(Map<String, dynamic> data) {
    return Triangle.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      A: jsonToOffset(data['A'] as Map<String, dynamic>),
      B: jsonToOffset(data['B'] as Map<String, dynamic>),
      C: jsonToOffset(data['C'] as Map<String, dynamic>),
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  Offset startPoint = Offset.zero;

  Offset A = Offset.zero;
  Offset B = Offset.zero;
  Offset C = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) {
    A = Offset(
        startPoint.dx + (nowPoint.dx - startPoint.dx) / 2, startPoint.dy);
    B = Offset(startPoint.dx, nowPoint.dy);
    C = nowPoint;
  }

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final Path path = Path()
      ..moveTo(A.dx, A.dy)
      ..lineTo(B.dx, B.dy)
      ..lineTo(C.dx, C.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  Triangle copy() => Triangle();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'A': A.toJson(),
      'B': B.toJson(),
      'C': C.toJson(),
      'paint': paint.toJson(),
    };
  }
}

class ImageRoomScreen extends StatefulWidget {
  final List<Map<String, dynamic>> drawingData;

  const ImageRoomScreen({
    Key? key,
    required this.drawingData,
  }) : super(key: key);

  @override
  State<ImageRoomScreen> createState() => _ImageRoomScreenState();
}

class _ImageRoomScreenState extends State<ImageRoomScreen> {
  final DrawingController _drawingController = DrawingController();

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  /// 获取画板数据 `getImageData()`
  Future<void> _getImageData() async {
    final Uint8List? data =
        (await _drawingController.getImageData())?.buffer.asUint8List();
    if (data == null) {
      debugPrint('获取图片数据失败');
      return;
    }

    if (mounted) {
      showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => Navigator.pop(c), child: Image.memory(data)),
          );
        },
      );
    }
  }

  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    log("Drawing Data==>>>${widget.drawingData}");

    Future.delayed(const Duration(seconds: 1), () async {
      stopLoader();
      List<Map<String, dynamic>> jsonData = widget.drawingData;

      List<PaintContent> originalDrawingContents = [];
      List<PaintContent> eraserContents = [];

      jsonData.forEach((data) {
        if (data['type'] == 'Eraser') {
          print("===>>>If");
          eraserContents.add(Eraser.fromJson(data));
          _drawingController.addContents(eraserContents);

          // setState(() {
          //   isLoading = false;
          // });
        } else {
          print("==>>>Else");

          originalDrawingContents.add(SimpleLine.fromJson(data));
          _drawingController.addContents(originalDrawingContents);
          // setState(() {
          //   isLoading = false;
          // });
        }
      });
    });
  }

  stopLoader() {
    print("Enter into stop loader");
    Future.delayed(const Duration(seconds: 3), () async {
      setState(() {
        isLoading = false;
      });
      // _drawingController.getImageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: SizedBox(
              height: 200,
              child: Center(
                child: SpinKitFadingCircle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Stack(
              children: [
                DrawingBoard(
                  controller: _drawingController,
                  background: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    clipBehavior: Clip.none,
                  ),
                ),
                Positioned(
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.cancel,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
