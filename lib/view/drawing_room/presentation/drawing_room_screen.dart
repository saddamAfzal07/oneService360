import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:measurment_app/res/constant/colors.dart';
import 'package:measurment_app/view/drawing_room/model/drawing_point.dart';

import '../../measurment/add_measurnment.dart';

class DrawingRoomScreen extends StatefulWidget {
  const DrawingRoomScreen({super.key});

  @override
  State<DrawingRoomScreen> createState() => _DrawingRoomScreenState();
}

class _DrawingRoomScreenState extends State<DrawingRoomScreen> {
  var avaiableColor = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown,
  ];

  var historyDrawingPoints = <DrawingPoint>[];
  var drawingPoints = <DrawingPoint>[];
  List<Offset> drawingPointses = [];

  var selectedColor = Colors.black;
  var selectedWidth = 2.0;

  DrawingPoint? currentDrawingPoint;
  bool pencilColor = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          // height: 65,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(
                      color: AppColors.whitedColor,
                    ),
                    Text(
                      "New Measurnment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whitedColor,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (drawingPoints.isNotEmpty &&
                            historyDrawingPoints.isNotEmpty) {
                          setState(() {
                            drawingPoints.removeLast();
                          });
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.5),
                                color: AppColors.primaryColor),
                            child: SvgPicture.asset(
                              "assets/svg/eraser.svg",
                              height: 16,
                            ),
                            //  Image.asset("assets/images/redo.png"),
                          ),
                          const Text(
                            "Erase",
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
                        setState(() {
                          if (drawingPoints.length <
                              historyDrawingPoints.length) {
                            // 6 length 7
                            final index = drawingPoints.length;
                            drawingPoints.add(historyDrawingPoints[index]);
                          }
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.5),
                              color: AppColors.primaryColor,
                            ),
                            child: SvgPicture.asset(
                              "assets/svg/undo.svg",
                              height: 17,
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
                        setState(() {
                          drawingPoints.clear();
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.5),
                              color: AppColors.primaryColor,
                            ),
                            child: SvgPicture.asset(
                              "assets/svg/clear.svg",
                              height: 17,
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
                    InkWell(
                      onTap: () {
                        setState(() {
                          pencilColor = !pencilColor;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.5),
                              color: AppColors.primaryColor,
                            ),
                            child: SvgPicture.asset(
                              "assets/svg/colorfilter.svg",
                              height: 17,
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
                        log("Draweing Points$drawingPoints");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMeasurnment(
                              drawingData: drawingPoints,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.5),
                              color: AppColors.primaryColor,
                            ),
                            child: SvgPicture.asset(
                              "assets/svg/save.svg",
                              height: 17,
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
                )),
          ),
          SizedBox(
            width: width,
            height: height * 0.76,
            child: Stack(
              children: [
                /// Canvas
                GestureDetector(
                  // onPanStart: (details) {
                  //   setState(() {
                  //     currentDrawingPoint = DrawingPoint(
                  //       id: DateTime.now().microsecondsSinceEpoch,
                  //       offsets: [details.localPosition],
                  //       color: selectedColor,
                  //       width: selectedWidth,
                  //     );

                  //     if (currentDrawingPoint == null) return;
                  //     drawingPoints.add(currentDrawingPoint!);
                  //   });
                  // },
                  // onPanUpdate: (details) {
                  //   // Clear the existing points to ensure only a straight line
                  //   setState(() {
                  //     currentDrawingPoint?.offsets.clear();
                  //   });
                  // },

                  onPanStart: (details) {
                    setState(() {
                      currentDrawingPoint = DrawingPoint(
                        id: DateTime.now().microsecondsSinceEpoch,
                        offsets: [
                          details.localPosition,
                        ],
                        color: selectedColor,
                        width: selectedWidth,
                      );

                      if (currentDrawingPoint == null) return;
                      drawingPoints.add(currentDrawingPoint!);
                      historyDrawingPoints = List.of(drawingPoints);
                    });
                    log("Drawing ==>${drawingPoints}");

                    log("Drawing length==>${drawingPoints.length}");
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      if (currentDrawingPoint == null) return;

                      currentDrawingPoint = currentDrawingPoint?.copyWith(
                        offsets: currentDrawingPoint!.offsets
                          ..add(details.localPosition),
                      );
                      drawingPoints.last = currentDrawingPoint!;
                      historyDrawingPoints = List.of(drawingPoints);
                    });
                  },
                  onPanEnd: (_) {
                    currentDrawingPoint = null;
                  },
                  child: CustomPaint(
                    painter: DrawingPainter(
                      drawingPoints: drawingPoints,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
                // / color pallet
                // Positioned(
                //   top: MediaQuery.of(context).padding.top,
                //   left: 20,
                //   right: 20,
                //   child: SizedBox(
                //       height: 80,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           InkWell(
                //             onTap: () {
                //               if (drawingPoints.isNotEmpty &&
                //                   historyDrawingPoints.isNotEmpty) {
                //                 setState(() {
                //                   drawingPoints.removeLast();
                //                 });
                //               }
                //             },
                //             child: Column(
                //               children: [
                //                 Container(
                //                   alignment: Alignment.center,
                //                   width: 45,
                //                   height: 45,
                //                   decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(22.5),
                //                       color: AppColors.primaryColor),
                //                   child: SvgPicture.asset(
                //                     "assets/svg/eraser.svg",
                //                     height: 16,
                //                   ),
                //                   //  Image.asset("assets/images/redo.png"),
                //                 ),
                //                 const Text(
                //                   "Erase",
                //                   style: TextStyle(
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.w500,
                //                     color: AppColors.primaryColor,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //           InkWell(
                //             onTap: () {
                //               setState(() {
                //                 if (drawingPoints.length <
                //                     historyDrawingPoints.length) {
                //                   // 6 length 7
                //                   final index = drawingPoints.length;
                //                   drawingPoints
                //                       .add(historyDrawingPoints[index]);
                //                 }
                //               });
                //             },
                //             child: Column(
                //               children: [
                //                 Container(
                //                   alignment: Alignment.center,
                //                   width: 45,
                //                   height: 45,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(22.5),
                //                     color: AppColors.primaryColor,
                //                   ),
                //                   child: SvgPicture.asset(
                //                     "assets/svg/undo.svg",
                //                     height: 17,
                //                     color: AppColors.whitedColor,
                //                   ),
                //                 ),
                //                 const Text(
                //                   "Undo",
                //                   style: TextStyle(
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.w500,
                //                     color: AppColors.primaryColor,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //           InkWell(
                //             onTap: () {
                //               setState(() {
                //                 drawingPoints.clear();
                //               });
                //             },
                //             child: Column(
                //               children: [
                //                 Container(
                //                   alignment: Alignment.center,
                //                   width: 45,
                //                   height: 45,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(22.5),
                //                     color: AppColors.primaryColor,
                //                   ),
                //                   child: SvgPicture.asset(
                //                     "assets/svg/clear.svg",
                //                     height: 17,
                //                     color: AppColors.whitedColor,
                //                   ),
                //                 ),
                //                 const Text(
                //                   "Clear",
                //                   style: TextStyle(
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.w500,
                //                     color: AppColors.primaryColor,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //           InkWell(
                //             onTap: () {
                //               setState(() {
                //                 pencilColor = !pencilColor;
                //               });
                //             },
                //             child: Column(
                //               children: [
                //                 Container(
                //                   alignment: Alignment.center,
                //                   width: 45,
                //                   height: 45,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(22.5),
                //                     color: AppColors.primaryColor,
                //                   ),
                //                   child: SvgPicture.asset(
                //                     "assets/svg/colorfilter.svg",
                //                     height: 17,
                //                   ),
                //                 ),
                //                 const Text(
                //                   "Pen",
                //                   style: TextStyle(
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.w500,
                //                     color: AppColors.primaryColor,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //           InkWell(
                //             onTap: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => const AddMeasurnment(),
                //                 ),
                //               );
                //             },
                //             child: Column(
                //               children: [
                //                 Container(
                //                   alignment: Alignment.center,
                //                   width: 45,
                //                   height: 45,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(22.5),
                //                     color: AppColors.primaryColor,
                //                   ),
                //                   child: SvgPicture.asset(
                //                     "assets/svg/save.svg",
                //                     height: 17,
                //                     color: AppColors.whitedColor,
                //                   ),
                //                 ),
                //                 const Text(
                //                   "Save",
                //                   style: TextStyle(
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.w500,
                //                     color: AppColors.primaryColor,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ],
                //       )),
                // ),

                // / color pallet
                Visibility(
                  visible: pencilColor,
                  child: Positioned(
                    top: 0,
                    left: 16,
                    right: 16,
                    child: SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: avaiableColor.length,
                        separatorBuilder: (_, __) {
                          return const SizedBox(width: 8);
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = avaiableColor[index];
                              });
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: avaiableColor[index],
                                shape: BoxShape.circle,
                              ),
                              foregroundDecoration: BoxDecoration(
                                border: selectedColor == avaiableColor[index]
                                    ? Border.all(
                                        color: AppColors.primaryColor, width: 4)
                                    : null,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                /// pencil size
                Positioned(
                  top: MediaQuery.of(context).padding.top + 80,
                  right: 0,
                  bottom: 150,
                  child: RotatedBox(
                    quarterTurns: 3, // 270 degree
                    child: Slider(
                      value: selectedWidth,
                      min: 1,
                      max: 20,
                      onChanged: (value) {
                        setState(() {
                          selectedWidth = value;
                        });
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

// class DrawingPainter extends CustomPainter {
//   final List<DrawingPoint> drawingPoints;

//   DrawingPainter({required this.drawingPoints});

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (var drawingPoint in drawingPoints) {
//       final paint = Paint()
//         ..color = drawingPoint.color
//         ..isAntiAlias = true
//         ..strokeCap = StrokeCap.round;

//       for (var offset in drawingPoint.offsets) {
//         canvas.drawCircle(offset, drawingPoint.width / 2, paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  DrawingPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < drawingPoint.offsets.length; i++) {
        var notLastOffset = i != drawingPoint.offsets.length - 1;

        if (notLastOffset) {
          final current = drawingPoint.offsets[i];
          final next = drawingPoint.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        } else {}
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
