import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:measurment_app/model/get_measurnments.dart';
import 'package:measurment_app/res/app_url/app_url.dart';
import 'package:measurment_app/utils/dialoges.dart';
import 'package:measurment_app/view/measurment/measurment.dart';
import 'package:provider/provider.dart';

class MeasurementController extends ChangeNotifier {
  MeasurementController() {}

  Future<List<Measurement>>? getMeasurementList;
  // List<Products> filteredMasterCaseProducDetailtList = [];
  bool isLoading = false;

  Future<List<Measurement>> getMeasurementApi() async {
    print("Enter into get api ");
    final response = await http.get(
      Uri.parse("${AppUrl.baseurl}v1/get/measurements?tailor_id=1}"),
      // headers: <String, String>{
      //   'Authorization': 'Bearer ${AppConstant.token}',
      // },
    );
    // log("status code==>>${response.statusCode}");
    // log("Response Data==>>${response.body}");
    // print("Print::::::${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonResponse["data"];
        // print("Response body==>>${response.body}");
        return jsonList.map((json) => Measurement.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch products');
      }
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  //Add Measurnment Function
  void saveDrawing(
      drawingData, String description, String product, context) async {
    log("Product ${product}");
    log("drawingData ${drawingData}");
    log("Description ${description}");

    // Connect the points to form straight lines
    List<List<double>> pointsData = [];
    for (var drawingPoint in drawingData) {
      List<Offset> offsets = drawingPoint.offsets;
      for (int i = 0; i < offsets.length - 1; i++) {
        // Add the coordinates of connected points
        pointsData.add([offsets[i].dx, offsets[i].dy]);
        pointsData.add([offsets[i + 1].dx, offsets[i + 1].dy]);
      }
    }

    log("${pointsData}");
    String pointsDataString = jsonEncode(pointsData);

    isLoading = true;

    try {
      final apiEndpoint = "${AppUrl.baseurl}v1/store/measurements";

      final jsonData = jsonEncode({
        "tailor_id": 1,
        'canvas_points': pointsDataString,
        'description': description,
        'product_id': product,
      });

      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        print("Isloading=>>$isLoading");

        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Successfully Add Measurement"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MeasurementScreen()));
        log('Drawing saved successfully.');
      } else if (response.statusCode == 302) {
        // Handle redirection
        final redirectLocation = response.headers['location'];
        if (redirectLocation != null) {
          // Make a new request to the redirect location
          final redirectResponse = await http.post(
            Uri.parse(redirectLocation),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonData,
          );

          log('Redirect Response: ${redirectResponse.statusCode}');
          if (redirectResponse.statusCode == 200) {
            log('Drawing saved successfully after redirection.');
          } else {
            // Handle errors after redirection
            log('Failed to save drawing after redirection: ${redirectResponse.statusCode}');
          }
        }
        isLoading = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Something went wrong"),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
        // Handle other errors
        log('Failed to save drawing: ${response.statusCode}');
      }
      isLoading = false;
    } catch (e) {
      log('Error: $e');
      isLoading = false;
    }
    notifyListeners();
  }

  // void saveDrawing(
  //     drawingData, String description, String product, context) async {
  //   log("Product ${product}");
  //   log("drawingData ${drawingData}");

  //   log("Description ${description}");

  //   List pointsData = await drawingData.map((point) {
  //     return point.offsets.map((offset) {
  //       return [offset.dx, offset.dy];
  //     }).toList();
  //   }).toList();

  //   log("${pointsData}");
  //   String pointsDataString = jsonEncode(pointsData);

  //   isLoading = true;

  //   try {
  //     final apiEndpoint = "${AppUrl.baseurl}v1/store/measurements";

  //     final jsonData = jsonEncode({
  //       "tailor_id": 1,
  //       'canvas_points': pointsDataString,
  //       'description': description,
  //       'product_id': product,
  //     });

  //     final response = await http.post(
  //       Uri.parse(apiEndpoint),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonData,
  //     );

  //     log(response.statusCode.toString());

  //     if (response.statusCode == 200) {
  //       print("Isloading=>>$isLoading");

  //       isLoading = false;
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Successfully Add  Measurement"),
  //         backgroundColor: Colors.green,
  //         behavior: SnackBarBehavior.floating,
  //         duration: Duration(seconds: 1),
  //       ));
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) => const MeasurementScreen()));
  //       log('Drawing saved successfully.');
  //     } else if (response.statusCode == 302) {
  //       // Handle redirection
  //       final redirectLocation = response.headers['location'];
  //       if (redirectLocation != null) {
  //         // Make a new request to the redirect location
  //         final redirectResponse = await http.post(
  //           Uri.parse(redirectLocation),
  //           headers: <String, String>{
  //             'Content-Type': 'application/json; charset=UTF-8',
  //           },
  //           body: jsonData,
  //         );

  //         log('Redirect Response: ${redirectResponse.statusCode}');
  //         if (redirectResponse.statusCode == 200) {
  //           log('Drawing saved successfully after redirection.');
  //         } else {
  //           // Handle errors after redirection
  //           log('Failed to save drawing after redirection: ${redirectResponse.statusCode}');
  //         }
  //       }
  //       isLoading = false;
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Text("Something went wrong"),
  //           backgroundColor: Colors.red.shade400,
  //           behavior: SnackBarBehavior.floating,
  //           duration: const Duration(seconds: 1),
  //         ),
  //       );
  //       // Handle other errors
  //       log('Failed to save drawing: ${response.statusCode}');
  //     }
  //     isLoading = false;
  //   } catch (e) {
  //     log('Error: $e');
  //     isLoading = false;
  //   }
  //   notifyListeners();
  // }

//Update
  void updateDrawing({
    required String id,
    drawingData,
    required String description,
    required String product,
    context,
  }) async {
    print("Enterinto update");
    print("id $id");

    print("drawingData $hasListeners");
    print("description $description");
    print("product $product");

    List pointsData = await drawingData.map((point) {
      return point.offsets.map((offset) {
        return [offset.dx, offset.dy];
      }).toList();
    }).toList();

    log("${pointsData}");
    String pointsDataString = jsonEncode(pointsData);

    print("dex>${description}");

    print("products>${product}");
    print("pointsDataString>${pointsDataString}");
    try {
      final apiEndpoint = "${AppUrl.baseurl}v1/update/measurement";

      final jsonData = jsonEncode({
        "id": id,
        "tailor_id": 1,
        'canvas_points': pointsDataString,
        'description': description,
        'product_id': product,
      });

      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        // Drawing successfully saved on the server.
        log('Drawing saved successfully.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Successfully Add  Measurement"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MeasurementScreen()));
      } else if (response.statusCode == 302) {
        // Handle redirection
        final redirectLocation = response.headers['location'];
        if (redirectLocation != null) {
          // Make a new request to the redirect location
          final redirectResponse = await http.post(
            Uri.parse(redirectLocation),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonData,
          );

          log('Redirect Response: ${redirectResponse.statusCode}');
          if (redirectResponse.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Successfully update  Measurement"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MeasurementScreen()));
            log('Drawing saved successfully after redirection.');
          } else {
            // Handle errors after redirection
            log('Failed to save drawing after redirection: ${redirectResponse.statusCode}');
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Something went wrong "),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ));
        // Handle other errors
        log('Failed to save drawing: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }
  //Delete Measurnment

  void deleteItem({
    required String id,
    context,
  }) async {
    try {
      final apiEndpoint = "${AppUrl.baseurl}v1/destroy/measurement";

      final jsonData = jsonEncode({
        "id": id,
      });

      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        Navigator.pop(context);
        print('===>>>>Item Delete successfully.');
        // getMeasurementApi();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Delete Successflly"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ));

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MeasurementScreen()));
      } else {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Something went wrong"),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ));
        log('Failed to save drawing: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
    // notifyListeners();
  }
}
