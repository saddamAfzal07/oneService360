import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:measurment_app/controller/measurment_controller.dart';
import 'package:measurment_app/res/constant/colors.dart';
import 'package:measurment_app/utils/fading_circular_indicator.dart';
import 'package:measurment_app/view/drawing_room/model/drawing_point.dart';
import 'package:provider/provider.dart';

class AddMeasurnment extends StatefulWidget {
  // List<DrawingPoint> drawingData;
  List<Map<String, dynamic>> drawingData;
  AddMeasurnment({super.key, required this.drawingData});

  @override
  State<AddMeasurnment> createState() => _AddMeasurnmentState();
}

class _AddMeasurnmentState extends State<AddMeasurnment> {
  List category = ["Shirt", "Kameez", "Shalwar"];
  bool dropDownVisibility = false;
  String productName = "Product Name";
  TextEditingController descriptionController = TextEditingController();
  TextEditingController productController = TextEditingController();
  bool selectValue = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final dataProvider = Provider.of<MeasurementController>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          // height: 65,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(
                  height: 14,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: AppColors.textGreyColor,
                      width: 2.0,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Measurements\n     Details",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    "New Measurement Details!",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    dropDownVisibility = !dropDownVisibility;
                  },
                  child: Padding(
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
                              padding:
                                  const EdgeInsets.only(left: 16, right: 6),
                              child: SvgPicture.asset(
                                "assets/svg/tag.svg",
                                height: 25,
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
                            Expanded(child: Text(productName.toString())),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                "assets/svg/arrow_down.svg",
                                height: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: dropDownVisibility,
                  child: Card(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerLeft,
                      width: width,
                      decoration: BoxDecoration(
                        color: AppColors.whitedColor,
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card(
                          //   elevation: 4,
                          //   child: Container(
                          //     height: 55,
                          //     decoration: BoxDecoration(
                          //       color: AppColors.whitedColor,
                          //       borderRadius: BorderRadius.circular(
                          //         6,
                          //       ),
                          //     ),
                          //     child: Row(
                          //       children: [
                          //         Expanded(
                          //           child: TextField(
                          //             cursorColor: AppColors.primaryColor,
                          //             style: const TextStyle(
                          //                 color: AppColors.whitedColor),
                          //             decoration: const InputDecoration(
                          //               hintText: 'Search',
                          //               border: InputBorder.none,
                          //               hintStyle: TextStyle(
                          //                 color: AppColors.textGreyColor,
                          //                 fontSize: 14,
                          //               ),
                          //               labelStyle: TextStyle(
                          //                   color: AppColors.whitedColor),
                          //               contentPadding: EdgeInsets.all(12),
                          //             ),
                          //             onChanged: (value) {},
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: category.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    dropDownVisibility = !dropDownVisibility;
                                    setState(() {});
                                    productName = category[index].toString();
                                    selectValue = true;
                                  },
                                  child: Text(
                                    category[index].toString(),
                                    style: const TextStyle(
                                      height: 2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                              "assets/svg/notebook.svg",
                              height: 25,
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
                          selectValue
                              ? Text(productName)
                              : Expanded(
                                  child: TextField(
                                    controller: productController,
                                    cursorColor: AppColors.primaryColor,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Type product name  if not found ',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(12),
                                    ),
                                    onChanged: (value) {},
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                              "assets/svg/document.svg",
                              height: 25,
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
                              controller: descriptionController,
                              cursorColor: AppColors.primaryColor,
                              decoration: const InputDecoration(
                                hintText: 'Write Description',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                labelStyle:
                                    TextStyle(color: AppColors.whitedColor),
                                contentPadding: EdgeInsets.all(12),
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer<MeasurementController>(
                  builder: (context, controller, child) {
                    return InkWell(
                      onTap: () {
                        if (productController.text.isNotEmpty) {
                          productName = "";
                          productName = productController.text;
                        } else {}
                        if (productName == "Product Name") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Product Name Required"),
                              backgroundColor: Colors.red.shade400,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        } else if (productName == "Product Name" &&
                            productController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Product Name Required"),
                              backgroundColor: Colors.red.shade400,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        } else if (descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Description Required"),
                              backgroundColor: Colors.red.shade400,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        } else {
                          controller.saveDrawing(
                            // widget.drawingData,
                            widget.drawingData,
                            descriptionController.text,
                            productName.toLowerCase().toString(),
                            context,
                          );
                        }
                      },
                      child: controller.isLoading
                          ? const SpinKitFadingCircle(
                              color: AppColors.primaryColor,
                            )
                          : Container(
                              alignment: Alignment.center,
                              height: height * 0.07,
                              width: width * 0.6,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(
                                  6,
                                ),
                              ),
                              child: const FittedBox(
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.whitedColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Container(
                //   alignment: Alignment.center,
                //   height: height * 0.07,
                //   width: width * 0.6,
                //   decoration: BoxDecoration(
                //     color: AppColors.primaryColor,
                //     borderRadius: BorderRadius.circular(
                //       6,
                //     ),
                //   ),
                //   child: const FittedBox(
                //     child: Text(
                //       "Save and New Measurement",
                //       style: TextStyle(
                //           fontSize: 14,
                //           color: AppColors.whitedColor,
                //           fontWeight: FontWeight.w600),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
