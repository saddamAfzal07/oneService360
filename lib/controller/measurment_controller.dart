import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:measurment_app/model/get_measurnments.dart';
import 'package:measurment_app/model/product_model.dart';
import 'package:measurment_app/res/app_url/app_url.dart';
import 'package:measurment_app/utils/dialoges.dart';
import 'package:measurment_app/view/drawing_room/presentation/drawing_room_screen.dart';
import 'package:measurment_app/view/measurment/measurment.dart';
import 'package:provider/provider.dart';

class MeasurementController extends ChangeNotifier {
  MeasurementController() {}

  Future<List<Measurement>>? getMeasurementList;

  bool isLoading = false;
  isLoadingCall(value) {
    isLoading = value;
    notifyListeners();
  }

  bool isLoadingSaveNew = false;
  isLoadingNew(value) {
    isLoadingSaveNew = value;
    notifyListeners();
  }

  Future<List<Measurement>> getMeasurementApi() async {
    print("Enter into get api ");
    final response = await http.get(
      Uri.parse("${AppUrl.baseurl}v1/get/measurements?tailor_id=1}"),
    );
    log("Response${response.body}");
    if (response.statusCode == 200) {
      log("Enter into 200 ");
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        log("Enter into 200 Data ");
        final List<dynamic> jsonList = jsonResponse["data"];
        // print("Response body==>>${response.body}");
        return jsonList.map((json) => Measurement.fromJson(json)).toList();
      } else {
        log("Else Response Failed to fetch products ");

        throw Exception('Failed to fetch products');
      }
    } else {
      log("Response Failed to fetch products ");

      throw Exception('Failed to fetch products');
    }
  }

  void saveDrawing(List<Map<String, dynamic>> drawingData, String description,
      String product, context) async {
    log("Product ${product}");
    log("Drawing ${drawingData}");

    log("Description ${description}");

    // isLoading = true;
    isLoadingCall(true);

    try {
      final apiEndpoint = "${AppUrl.baseurl}v1/store/measurements";
      final String jsonData = jsonEncode(drawingData);
      log("jsonData ${jsonData}");
      // Convert your data to a Map
      Map<String, dynamic> requestData = {
        "tailor_id": "1",
        'canvas_points': jsonData,
        'description': description,
        'product_id': product,
      };

      final response = await http.post(
        Uri.parse(apiEndpoint),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        // },
        body: requestData,
      );

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        print("Isloading=>>$isLoading");

        isLoadingCall(false);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Successfully Add  Measurement"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MeasurementScreen()));
        log('Drawing saved successfully.');
      } else if (response.statusCode == 302) {
        isLoadingCall(false);

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
              content: Text("Successfully Add  Measurement"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MeasurementScreen()));
            log('Drawing saved successfully.');
            isLoadingCall(false);

            log('Drawing saved successfully after redirection.');
          } else {
            // Handle errors after redirection
            log('Failed to save drawing after redirection: ${redirectResponse.statusCode}');
          }
        }
        isLoadingCall(false);
      } else {
        isLoadingCall(false);

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
      isLoadingCall(false);
    } catch (e) {
      log('Error: $e');
      isLoadingCall(false);
    }
    notifyListeners();
  }

  //Save and Add new Measurnment
  void saveAndAddNewMeasurnment(List<Map<String, dynamic>> drawingData,
      String description, String product, context) async {
    log("Product ${product}");
    log("Drawing ${drawingData}");

    log("Description ${description}");

    // isLoading = true;
    isLoadingNew(true);

    try {
      final apiEndpoint = "${AppUrl.baseurl}v1/store/measurements";
      final String jsonData = jsonEncode(drawingData);
      log("jsonData ${jsonData}");
      // Convert your data to a Map
      Map<String, dynamic> requestData = {
        "tailor_id": "1",
        'canvas_points': jsonData,
        'description': description,
        'product_id': product,
      };

      final response = await http.post(
        Uri.parse(apiEndpoint),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        // },
        body: requestData,
      );

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        print("Isloading=>>$isLoading");

        isLoadingNew(false);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Successfully Add  Measurement"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DrawingRoomScreen()));
        log('Drawing saved successfully.');
      } else if (response.statusCode == 302) {
        isLoadingNew(false);

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
              content: Text("Successfully Add  Measurement"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ));
            isLoadingNew(false);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DrawingRoomScreen()));

            log('Drawing saved successfully after redirection.');
          } else {
            log('Failed to save drawing after redirection: ${redirectResponse.statusCode}');
          }
        }
        isLoadingNew(false);
      } else {
        isLoadingNew(false);

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
      isLoadingNew(false);
    } catch (e) {
      log('Error: $e');
      isLoadingNew(false);
    }
    notifyListeners();
  }

//Update
  void updateDrawing({
    required String id,
    required List<Map<String, dynamic>> drawingData,
    required String description,
    required String product,
    context,
  }) async {
    isLoadingCall(true);
    print("Enterinto update");

    final String jsonData = jsonEncode(drawingData);
    log("drawingData ${jsonData}");
    // Convert your data to a Map
    Map<String, dynamic> requestData = {
      "id": id,
      "tailor_id": "1",
      'canvas_points': jsonData,
      'description': description,
      'product_id': product,
    };
    try {
      final apiEndpoint = "${AppUrl.baseurl}v1/update/measurement";

      final response = await http.post(
        Uri.parse(apiEndpoint),
        body: requestData,
      );

      log("===>>>${response.statusCode.toString()}");

      if (response.statusCode == 200) {
        isLoadingCall(false);
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
        isLoadingCall(false);

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
            isLoadingCall(false);

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
        print("Enter==> 403");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Something went wrong Try Again"),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ));
        // Handle other errors
        log('Failed to save drawing: ${response.statusCode}');
      }
    } catch (e) {
      isLoadingCall(false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Something went wrong Try Again"),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ));

      log('Error: $e');
    }
  }

  //Update Save And New
  void updateSaveNewDrawing({
    required String id,
    required List<Map<String, dynamic>> drawingData,
    required String description,
    required String product,
    context,
  }) async {
    isLoadingNew(true);
    print("Enterinto update");

    final String jsonData = jsonEncode(drawingData);
    log("drawingData ${jsonData}");
    // Convert your data to a Map
    Map<String, dynamic> requestData = {
      "id": id,
      "tailor_id": "1",
      'canvas_points': jsonData,
      'description': description,
      'product_id': product,
    };
    try {
      final apiEndpoint = "${AppUrl.baseurl}v1/update/measurement";

      // final jsonData = jsonEncode({
      //   "id": id,
      //   "tailor_id": 1,
      //   'canvas_points': pointsDataString,
      //   'description': description,
      //   'product_id': product,
      // });

      final response = await http.post(
        Uri.parse(apiEndpoint),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        // },
        body: requestData,
      );

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        isLoadingNew(false);
        // Drawing successfully saved on the server.
        log('Drawing saved successfully.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Successfully Add  Measurement"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DrawingRoomScreen()));
      } else if (response.statusCode == 302) {
        isLoadingNew(false);

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
            isLoadingNew(false);

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Successfully update  Measurement"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DrawingRoomScreen()));
            log('Drawing saved successfully after redirection.');
          } else {
            // Handle errors after redirection
            log('Failed to save drawing after redirection: ${redirectResponse.statusCode}');
          }
        }
      } else {
        isLoadingNew(false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Something went wrong Try Again"),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ));
        // Handle other errors
        log('Failed to save drawing: ${response.statusCode}');
      }
    } catch (e) {
      isLoadingNew(false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Something went wrong Try Again"),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ));

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

  Future<List<Data>>? getProductList;
  Future<List<Data>> getProductApi() async {
    print("Enter into get Product ");
    final response = await http.get(
      Uri.parse("${AppUrl.baseurl}v1/get/user/products?user_id=1}"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonResponse["data"];
        // print("Response body==>>${response.body}");
        return jsonList.map((json) => Data.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch products');
      }
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
