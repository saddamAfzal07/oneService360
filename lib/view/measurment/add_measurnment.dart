import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:measurment_app/controller/measurment_controller.dart';
import 'package:measurment_app/model/product_model.dart';
import 'package:measurment_app/res/constant/colors.dart';
import 'package:measurment_app/utils/fading_circular_indicator.dart';
import 'package:measurment_app/view/measurment/measurment.dart';

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
  List<Data> filteredProductsList = [];
  TextEditingController searhController = TextEditingController();
  final TextEditingController search = TextEditingController();
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
                      height: 250,
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerLeft,
                      width: width,
                      decoration: BoxDecoration(
                        color: AppColors.whitedColor,
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                      // Padding(
                                      //   padding: const EdgeInsets.only(left: 16, right: 6),
                                      //   child: SvgPicture.asset(
                                      //     "assets/svg/search.svg",
                                      //     height: 30,
                                      //   ),
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       vertical: 5, horizontal: 5),
                                      //   child: Container(
                                      //     width: 2,
                                      //     color: AppColors.lightBlue,
                                      //   ),
                                      // ),
                                      Expanded(
                                        child: TextField(
                                          controller: searhController,
                                          cursorColor: AppColors.primaryColor,
                                          decoration: const InputDecoration(
                                            hintText: 'Search ',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              color: AppColors.textGreyColor,
                                              fontSize: 14,
                                            ),
                                            labelStyle: TextStyle(
                                                color: AppColors.whitedColor),
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

                            FutureBuilder<List<Data>>(
                              future: dataProvider.getProductApi(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox(
                                    height: height * 0.2,
                                    child: const Center(
                                        child: SpinKitFadingCircle(
                                      color: AppColors.primaryColor,
                                    )),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Nothing Found'));
                                } else {
                                  filteredProductsList = snapshot.data!;

                                  if (searhController.text.isNotEmpty) {
                                    filteredProductsList = filteredProductsList
                                        .where((product) => product.name
                                            .toString()
                                            .toLowerCase()
                                            .contains(search.text))
                                        .toList();
                                  }

                                  return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: filteredProductsList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          dropDownVisibility =
                                              !dropDownVisibility;
                                          setState(() {});
                                          productName =
                                              filteredProductsList[index]
                                                  .name
                                                  .toString();
                                          selectValue = true;
                                        },
                                        child: Text(
                                          filteredProductsList[index]
                                              .name
                                              .toString(),
                                          style: const TextStyle(
                                            height: 2,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            // ListView.builder(
                            //     shrinkWrap: true,
                            //     itemCount: category.length,
                            //     itemBuilder: (context, index) {
                            //       return InkWell(
                            //         onTap: () {
                            //           dropDownVisibility = !dropDownVisibility;
                            //           setState(() {});
                            //           productName = category[index].toString();
                            //           selectValue = true;
                            //         },
                            //         child: Text(
                            //           category[index].toString(),
                            //           style: const TextStyle(
                            //             height: 2,
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.w500,
                            //             color: AppColors.blackColor,
                            //           ),
                            //         ),
                            //       );
                            //     })
                          ],
                        ),
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
                                    onChanged: (value) {
                                      dropDownVisibility = false;
                                      setState(() {});
                                    },
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
                    return Column(
                      children: [
                        InkWell(
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
                              // setState(() {});
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
                                          fontSize: 16,
                                          color: AppColors.whitedColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
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
                              controller.saveAndAddNewMeasurnment(
                                // widget.drawingData,
                                widget.drawingData,
                                descriptionController.text,
                                productName.toLowerCase().toString(),
                                context,
                              );
                              // setState(() {});
                            }
                          },
                          child: controller.isLoadingSaveNew
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
                                      "Save and New Measurement",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.whitedColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                        ),
                      ],
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
