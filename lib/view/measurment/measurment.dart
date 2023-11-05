import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:typed_data'; // To convert ui.Image to Uint8List
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:measurment_app/controller/measurment_controller.dart';
import 'package:measurment_app/model/get_measurnments.dart';
import 'package:measurment_app/res/constant/colors.dart';
import 'package:measurment_app/utils/custom_appbar.dart';
import 'package:measurment_app/utils/fading_circular_indicator.dart';
import 'package:measurment_app/view/drawing_room/presentation/drawing_room_screen.dart';
import 'package:measurment_app/view/drawing_room/presentation/edit_drawing_room.dart';
import 'package:provider/provider.dart';

import '../drawing_room/model/drawing_point.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';
import 'package:image/image.dart' as img;

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Measurement> filteredProductsList = [];
  TextEditingController searhController = TextEditingController();
  final TextEditingController search = TextEditingController();
  // Future<ui.Image> createImageFromOffsets(String jsonString) async {
  //   final offsets = parsePointsString(jsonString);

  //   final recorder = ui.PictureRecorder();
  //   final paint = ui.Paint()
  //     ..color = const ui.Color(0xFF000000) // Set your desired color
  //     ..strokeWidth = 2.0; // Set your desired stroke width

  //   final canvas = ui.Canvas(recorder);

  //   for (final offset in offsets) {
  //     canvas.drawPoints(ui.PointMode.points, [offset], paint);
  //   }

  //   final picture = recorder.endRecording();

  //   final img = await picture.toImage(300, 300); // Set the image dimensions
  //   return img;
  // }

  // Future<Uint8List> convertImageToUint8List(
  //     Future<ui.Image> imageFuture) async {
  //   final ui.Image image = await imageFuture;
  //   final ByteData? byteData =
  //       await image.toByteData(format: ui.ImageByteFormat.png);
  //   if (byteData != null && byteData.buffer.asUint8List().isNotEmpty) {
  //     return byteData.buffer.asUint8List();
  //   }
  //   throw Exception("Failed to convert image to Uint8List");
  // }
  DrawingController _drawingController = DrawingController();

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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final dataProvider =
        Provider.of<MeasurementController>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppBar("Measurements"),
        ),
        body: SingleChildScrollView(
          key: _scaffoldKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 4,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColors.whitedColor,
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 6),
                            child: SvgPicture.asset(
                              "assets/svg/search.svg",
                              height: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Container(
                              width: 2,
                              color: AppColors.lightBlue,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: searhController,
                              cursorColor: AppColors.primaryColor,
                              decoration: const InputDecoration(
                                hintText:
                                    'Search measurement by name or description',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: AppColors.textGreyColor,
                                  fontSize: 14,
                                ),
                                labelStyle:
                                    TextStyle(color: AppColors.whitedColor),
                                contentPadding: EdgeInsets.all(12),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  search.text = value.toLowerCase();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DrawingRoomScreen()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      alignment: Alignment.center,
                      height: height * 0.05,
                      width: width * 0.43,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/plus.png",
                            height: 25,
                            width: 25,
                            color: AppColors.whitedColor,
                          ),
                          const FittedBox(
                            child: Text(
                              "Add new measuremnt",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.whitedColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                FutureBuilder<List<Measurement>>(
                  future: dataProvider.getMeasurementApi(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: height * 0.5,
                        child: const Center(
                            child: SpinKitFadingCircle(
                          color: AppColors.primaryColor,
                        )),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Nothing Found'));
                    } else {
                      filteredProductsList = snapshot.data!;

                      if (searhController.text.isNotEmpty) {
                        filteredProductsList = filteredProductsList
                            .where(
                              (product) =>
                                  product.measurementProduct!.name
                                      .toString()
                                      .toLowerCase()
                                      .contains(search.text) ||
                                  product.description!
                                      .toLowerCase()
                                      .contains(search.text),
                            )
                            .toList();
                      }

                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredProductsList.length,
                        itemBuilder: (context, index) {
                          // final List<Map<String, dynamic>> drawingData =
                          //     (jsonDecode(filteredProductsList[index]
                          //             .canvasPoints
                          //             .toString()) as List<dynamic>)
                          //         .map((element) =>
                          //             element as Map<String, dynamic>)
                          //         .toList();
                          // log("List Data==>${drawingData}");
                          // List<DrawingPoint> drawingPoints =
                          //     convertOffsetsToDrawingPoints(
                          //   parsePointsString(
                          //     filteredProductsList[index]
                          //         .canvasPoints
                          //         .toString(),
                          //   ),
                          //   AppColors.blackColor,
                          //   5.0,
                          // );
                          // final image = createImageFromOffsets(
                          //     filteredProductsList[index]
                          //         .canvasPoints
                          //         .toString());

                          return Column(
                            children: [
                              Card(
                                elevation: 4,
                                child: Container(
                                  width: width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  height: height * 0.16,
                                  decoration: BoxDecoration(
                                    color: AppColors.whitedColor,
                                    borderRadius: BorderRadius.circular(
                                      6,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                              color: AppColors.textGreyColor,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              final List<Map<String, dynamic>>
                                                  drawingData = (jsonDecode(
                                                              filteredProductsList[
                                                                      index]
                                                                  .canvasPoints
                                                                  .toString())
                                                          as List<dynamic>)
                                                      .map((element) => element
                                                          as Map<String,
                                                              dynamic>)
                                                      .toList();
                                              log("List Data==>${drawingData}");

                                              ///show image
                                              List<Map<String, dynamic>>
                                                  simplifiedDrawingData =
                                                  drawingData.where((data) {
                                                return data['type'] ==
                                                    'SimpleLine';
                                              }).toList();

                                              imagePreviewDialog(
                                                  simplifiedDrawingData);
                                            },
                                            child: const Center(
                                              child:
                                                  //  CustomPaint(
                                                  //   size: Size(2, 2),
                                                  //   painter:
                                                  //       DrawingPainter(drawingData),
                                                  // ),

                                                  Text(
                                                "Measurements\n     Details",
                                                style: TextStyle(fontSize: 6),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.45,
                                            child: RichText(
                                              maxLines: 1,
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: "Product Name : ",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: filteredProductsList[
                                                            index]
                                                        .measurementProduct!
                                                        .name
                                                        .toString(),
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 12,
                                                      color:
                                                          AppColors.blackColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Container(
                                            width: width * 0.45,
                                            child: RichText(
                                              maxLines: 1,
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: "Description : ",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: filteredProductsList[
                                                            index]
                                                        .description,
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 12,
                                                      color:
                                                          AppColors.blackColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              final List<Map<String, dynamic>>
                                                  drawingData =
                                                  await (jsonDecode(
                                                              filteredProductsList[
                                                                      index]
                                                                  .canvasPoints
                                                                  .toString())
                                                          as List<dynamic>)
                                                      .map((element) => element
                                                          as Map<String,
                                                              dynamic>)
                                                      .toList();
                                              log("List Data==>${drawingData}");
                                              // ignore: use_build_context_synchronously
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditDrawingRoomScreen(
                                                    id: filteredProductsList[
                                                            index]
                                                        .id
                                                        .toString(),
                                                    product:
                                                        filteredProductsList[
                                                                index]
                                                            .measurementProduct!
                                                            .name
                                                            .toString(),
                                                    description:
                                                        filteredProductsList[
                                                                index]
                                                            .description
                                                            .toString(),
                                                    drawingData: drawingData,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: height * 0.05,
                                              width: width * 0.17,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  6,
                                                ),
                                              ),
                                              child: const FittedBox(
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.whitedColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _showCustomDialog(
                                                  _scaffoldKey,
                                                  context,
                                                  filteredProductsList[index]
                                                      .id
                                                      .toString(),
                                                  filteredProductsList[index]
                                                      .canvasPoints
                                                      .toString(),
                                                  filteredProductsList[index]
                                                      .measurementProduct!
                                                      .name
                                                      .toString(),
                                                  filteredProductsList[index]
                                                      .description
                                                      .toString());
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: height * 0.05,
                                              width: width * 0.17,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  6,
                                                ),
                                              ),
                                              child: const FittedBox(
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.whitedColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> imagePreviewDialog(
      List<Map<String, dynamic>> drawingData) async {
    final Uint8List imageBytes = convertDrawingToImage(drawingData);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 350,
            width: 500,
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Image.memory(imageBytes),
            ),
          ),
        );
      },
    );
  }

  Uint8List convertDrawingToImage(List<Map<String, dynamic>> drawingData) {
    // Create a blank canvas
    final img.Image image = img.Image(500, 500);

    // Define a color for drawing (you can customize this)
    final drawingColor = img.getColor(255, 0, 0);
    final eraserColor =
        img.getColor(255, 255, 255); // Set eraser color to white

    for (final data in drawingData) {
      final type = data['type'];

      if (type == 'SimpleLine') {
        // Handle SimpleLine data
        final pathData = data['path'];
        final steps = pathData['steps'];

        for (var i = 1; i < steps.length; i++) {
          final x1 = steps[i - 1]['x'].toDouble();
          final y1 = steps[i - 1]['y'].toDouble();
          final x2 = steps[i]['x'].toDouble();
          final y2 = steps[i]['y'].toDouble();

          img.drawLine(
            image,
            x1.round(),
            y1.round(),
            x2.round(),
            y2.round(),
            drawingColor,
          );
        }
      } else if (type == 'Eraser') {
        // Handle Eraser data
        final pathData = data['path'];
        final steps = pathData['steps'];

        for (var i = 1; i < steps.length; i++) {
          final x1 = steps[i - 1]['x'].toDouble();
          final y1 = steps[i - 1]['y'].toDouble();
          final x2 = steps[i]['x'].toDouble();
          final y2 = steps[i]['y'].toDouble();

          img.drawLine(image, x1.round(), y1.round(), x2.round(), y2.round(),
              eraserColor);
        }
      }
    }

    // Encode the image to bytes
    return Uint8List.fromList(img.encodePng(image));
  }

  Future<void> _showCustomDialog(_scaffoldKey, BuildContext context, String id,
      String drawing, String product, String description) async {
    final dataProvider =
        Provider.of<MeasurementController>(context, listen: false);

    print("gET THE CANVAS DATA==>>>$drawing");
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return showDialog(
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 200,
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  'Delete',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text('Are you sure to delete this measurement ?'),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Navigator.pop(context);
                          // Navigator.of(context, rootNavigator: true).pop();
                          dataProvider.deleteItem(
                            id: id,
                            context: context,
                          );
                          dataProvider.getMeasurementApi();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.textGreyColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(width * 0.35, height * 0.07),
                          ),
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primaryColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(width * 0.35, height * 0.07),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
