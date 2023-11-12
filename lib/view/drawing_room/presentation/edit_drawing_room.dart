import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
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

import 'test_data.dart';

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

class EditDrawingRoomScreen extends StatefulWidget {
  final List<Map<String, dynamic>> drawingData;
  final String id;
  final String product;

  final String description;

  const EditDrawingRoomScreen(
      {Key? key,
      required this.drawingData,
      required this.id,
      required this.product,
      required this.description})
      : super(key: key);

  @override
  State<EditDrawingRoomScreen> createState() => _EditDrawingRoomScreenState();
}

class _EditDrawingRoomScreenState extends State<EditDrawingRoomScreen> {
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

  /// 获取画板内容 Json `getJsonList()`
  Future<void> _getJson() async {
    showDialog<void>(
      context: context,
      builder: (BuildContext c) {
        return Center(
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => Navigator.pop(c),
              child: Container(
                constraints:
                    const BoxConstraints(maxWidth: 500, maxHeight: 800),
                padding: const EdgeInsets.all(20.0),
                child: SelectableText(
                  const JsonEncoder.withIndent('  ')
                      .convert(_drawingController.getJsonList()),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 添加Json测试内容
  void _addTestLine() {
    _drawingController.addContent(StraightLine.fromJson(_testLine1));
    _drawingController
        .addContents(<PaintContent>[StraightLine.fromJson(_testLine2)]);

    _drawingController.addContent(SimpleLine.fromJson(tData[0]));
    _drawingController.addContent(Eraser.fromJson(tData[1]));
  }

  List<Map<String, dynamic>> getDrawingData() {
    print("==>>Enter into getDrawingData");
    final List<Map<String, dynamic>> drawingData =
        _drawingController.getJsonList();
    return drawingData;
  }

  void sendDrawingData() {
    // Assuming you have drawing data in the format you want to send
    List<Map<String, dynamic>> drawingData = getDrawingData();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMeasurnment(
          id: widget.id,
          description: widget.description,
          product: widget.product,
          drawingData: drawingData,
        ),
      ),
    );
    // sendDrawingDataToServer(drawingData);
  }

  Future<void> sendDrawingDataToServer(
      List<Map<String, dynamic>> drawingData) async {
    final String jsonData = jsonEncode(drawingData);

    log("Json Data==>>${jsonData}");
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
    Future.delayed(const Duration(seconds: 5), () async {
      setState(() {
        isLoading = false;
      });
    });
  }

//
  List availableColors = ['black', 'red', 'blue', 'green'];
  Color selectedColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors
                .primaryColor, // Change the background color to your desired color.
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BackButton(
                  color: AppColors.whitedColor,
                ),
                Text(
                  "Measurements",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whitedColor,
                  ),
                ),
                SizedBox(),
                // InkWell(
                //   onTap: () {
                //     sendDrawingData();
                //   },
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Container(
                //         alignment: Alignment.center,
                //         width: 45,
                //         height: 45,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(22.5),
                //           color: AppColors.whitedColor,
                //         ),
                //         child: SvgPicture.asset(
                //           "assets/svg/save.svg",
                //           height: 17,
                //           color: AppColors.primaryColor,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),

      //  AppBar(
      //   title: const Text('Drawing Test'),
      //   systemOverlayStyle: SystemUiOverlayStyle.light,
      //   actions: <Widget>[
      //     IconButton(
      //         icon: const Icon(Icons.line_axis), onPressed: _addTestLine),
      //     IconButton(
      //         icon: const Icon(Icons.javascript_outlined), onPressed: _getJson),
      //     IconButton(icon: const Icon(Icons.check), onPressed: _getImageData),
      //     IconButton(icon: const Icon(Icons.send), onPressed: sendDrawingData),
      //   ],
      // ),

      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _drawingController.setPaintContent(SimpleLine());
                    _drawingController.setCustomColor(Colors.white);
                  },
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(27),
                            color: AppColors.primaryColor),
                        child: SvgPicture.asset(
                          "assets/svg/eraser.svg",
                          height: 16,
                        ),
                        //  Image.asset("assets/images/redo.png"),
                      ),
                      const Text(
                        "Eraser",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _drawingController.undo();
                  },
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          color: AppColors.primaryColor,
                        ),
                        child: SvgPicture.asset(
                          "assets/svg/undo.svg",
                          height: 20,
                          color: AppColors.whitedColor,
                        ),
                      ),
                      const Text(
                        "Undo",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _drawingController.clear();
                  },
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          color: AppColors.primaryColor,
                        ),
                        child: SvgPicture.asset(
                          "assets/svg/clear.svg",
                          height: 20,
                          color: AppColors.whitedColor,
                        ),
                      ),
                      const Text(
                        "Clear",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     _drawingController.setPaintContent(SimpleLine());
                //   },
                //   child: Column(
                //     children: [
                //       Container(
                //         alignment: Alignment.center,
                //         width: 45,
                //         height: 45,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(22.5),
                //           color: AppColors.primaryColor,
                //         ),
                //         child: SvgPicture.asset(
                //           "assets/svg/colorfilter.svg",
                //           height: 17,
                //         ),
                //       ),
                //       const Text(
                //         "Pen",
                //         style: TextStyle(
                //           fontSize: 16,
                //           fontWeight: FontWeight.w500,
                //           color: AppColors.primaryColor,
                //         ),
                //       )
                //     ],
                //   ),
                // ),

                InkWell(
                  onTap: () {
                    _drawingController.setPaintContent(SimpleLine());
                    _drawingController.setCustomColor(Colors.black);
                    print("click");
                  },
                  child: Column(
                    children: [
                      // Container(
                      //   alignment: Alignment.center,
                      //   width: 45,
                      //   height: 45,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(22.5),
                      //     color: AppColors.primaryColor,
                      //   ),
                      //   child: SvgPicture.asset(
                      //     "assets/svg/colorfilter.svg",
                      //     height: 17,
                      //   ),
                      // ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          customButton: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(13),

                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(27),
                              color: AppColors.primaryColor,
                            ),
                            // decoration: BoxDecoration(
                            //   color: selectedColor == Colors.white
                            //       ? Colors.black
                            //       : selectedColor == Colors.red
                            //           ? Colors.red
                            //           : selectedColor == Colors.blue
                            //               ? Colors.blue
                            //               : Colors.purple.shade200,
                            //   shape: BoxShape.circle,
                            // ),
                            child: SvgPicture.asset(
                              "assets/svg/colorfilter.svg",
                              height: 20,
                            ),
                          ),
                          items: availableColors
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: item == 'black'
                                            ? Colors.black
                                            : item == "green"
                                                ? Colors.green
                                                : item == 'red'
                                                    ? Colors.red
                                                    : Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      foregroundDecoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value.toString() == "red") {
                                _drawingController.setCustomColor(Colors.red);
                              } else if (value.toString() == "blue") {
                                _drawingController.setCustomColor(Colors.blue);
                              } else if (value.toString() == "green") {
                                _drawingController.setCustomColor(Colors.green);
                              } else {
                                _drawingController.setCustomColor(Colors.black);
                              }
                            });
                            setState(() {
                              _drawingController.setPaintContent(SimpleLine());
                            });
                          },
                        ),
                      ),
                      const Text(
                        "Pen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      )
                    ],
                  ),
                ),

                InkWell(
                  onTap: () {
                    sendDrawingData();
                  },
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: AppColors.primaryColor,
                        ),
                        child: SvgPicture.asset(
                          "assets/svg/save.svg",
                          height: 20,
                          color: AppColors.whitedColor,
                        ),
                      ),
                      const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? const SizedBox(
                  height: 200,
                  child: Center(
                    child: SpinKitFadingCircle(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : Expanded(
                  child: Stack(
                    children: [
                      // LayoutBuilder(
                      //   builder:
                      //       (BuildContext context, BoxConstraints constraints) {
                      //     return

                      DrawingBoard(
                        // colorValue: Colors.green,
                        controller: _drawingController,
                        background: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          // width: constraints.maxWidth,
                          // height: constraints.maxHeight,
                          color: Colors.white,
                          clipBehavior: Clip.none,
                        ),
                        // showDefaultActions: true,
                        // showDefaultTools: true,
                        // defaultToolsBuilder: (Type t, _) {
                        //   return DrawingBoard.defaultTools(
                        //       t, _drawingController)
                        //     ..insert(
                        //       1,
                        //       DefToolItem(
                        //         icon: Icons.change_history_rounded,
                        //         isActive: t == Triangle,
                        //       ),
                        //     );
                        // },
                      ),
                      //   },
                      // ),
                      Positioned(
                        top: 20,
                        right: 10,
                        child: SizedBox(
                          height:
                              300, // Set the height to adjust the length of the vertical slider
                          width:
                              24, // Set the width to adjust the thickness of the vertical slider
                          child: ExValueBuilder<DrawConfig>(
                            valueListenable: _drawingController.drawConfig,
                            shouldRebuild: (DrawConfig p, DrawConfig n) =>
                                p.strokeWidth != n.strokeWidth,
                            builder: (_, DrawConfig dc, ___) {
                              return RotatedBox(
                                quarterTurns:
                                    3, // Rotate the Slider 270 degrees (3 quarter-turns) for vertical orientation
                                child: Slider(
                                  value: dc.strokeWidth,
                                  max: 50,
                                  min: 1,
                                  onChanged: (double v) => _drawingController
                                      .setStyle(strokeWidth: v),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
