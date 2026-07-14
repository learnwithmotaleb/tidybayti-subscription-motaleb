import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:tidybayte/app/controller/owner_controller/add_employee_controller/add_employee_controller.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

class AddEmployee {
  ///==================================✅✅Add Employee✅✅=======================

  static Future<void> addEmployee({
    required BuildContext context, // Add this line
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required File profileImage,
    required String phoneNumber,
    required String jobType,
    required String designation,
    required String address,
    required String cprNumber,
    required String cprExpDate,
    required String passportNumber,
    required String passportExpDate,
    required String note,
    required String dutyTime,
    required String breakTimeStar,
    required String breakTimeEnd,
    required List workingDay,
    required String offDay,
  }) async {
    AddEmployeeController employeeController = Get.find();
    employeeController.setLoading(true);

    var url = Uri.parse(ApiUrl.addEmployee);

    var request = http.MultipartRequest("POST", url);

    request.fields["firstName"] = firstName;
    request.fields["lastName"] = lastName;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["phoneNumber"] = phoneNumber;
    request.fields["jobType"] = jobType;
    request.fields["designation"] = designation;
    request.fields["address"] = address;
    request.fields["CPRNumber"] = cprNumber;
    request.fields["CPRExpDate"] = cprExpDate;
    request.fields["passportNumber"] = passportNumber;
    request.fields["passportExpDate"] = passportExpDate;
    request.fields["note"] = note;
    request.fields["dutyTime"] = dutyTime;
    request.fields["breakTimeStart"] = breakTimeStar;
    request.fields["breakTimeEnd"] = breakTimeEnd;
    request.fields["workingDay"] = jsonEncode(workingDay);
    request.fields["offDay"] = offDay;

    request.files.add(await http.MultipartFile.fromPath(
      "profile_image",
      profileImage.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    String? savedToken = await SharePrefsHelper.getString(AppConstants.token);
    var token = savedToken;

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type": "multipart/form-data",
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      employeeController
          .setLoading(false); // Set loading to false after request

      if (response.statusCode == 200) {
        employeeController.addEmployeeFieldClear();
        employeeController.sendEmail(context);
        toastMessage(message: "✅ Employee added successfully!");
        print("✅ Employee added successfully!");
        print(responseData);
      } else {
        print("❌ Failed: ${response.statusCode}");
        print("❌ Error Response: $responseData");

        String errorMessage = "Something went wrong!";
        try {
          var decodedData = json.decode(responseData);
          if (decodedData["message"] != null) {
            errorMessage = decodedData["message"];
          }
        } catch (e) {
          print("❌ JSON Parsing Error: $e");
        }

        toastMessage(message: "❌ $errorMessage");
      }
    } catch (e) {
      employeeController.setLoading(false);
      toastMessage(
          message: "❌ An error occurred. Please check your connection.");
      print("❌ Error: $e");
    }
  }

  ///==================================✅✅Edit Employee✅✅=======================

  static Future<void> editEmployee({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String designation,
    required String address,
    File? profileImage,
    required String phoneNumber,
    required String jobType,
    required String cprNumber,
    required String cprExpDate,
    required String passportNumber,
    required String passportExpDate,
    required String note,
    required String dutyTime,
    required String breakTimeStart,
    required String breakTimeEnd,
    required List workingDay,
    required String offDay,
    required String authId,
    required String userId,
  }) async {
    AddEmployeeController employeeController = Get.find();
    employeeController.editLoading(true);

    var url = Uri.parse(ApiUrl.editEmployee);
    var request = http.MultipartRequest("PATCH", url);

    // Add all the text fields
    request.fields["firstName"] = firstName;
    request.fields["lastName"] = lastName;
    request.fields["designation"] = designation;
    request.fields["address"] = address;
    request.fields["phoneNumber"] = phoneNumber;
    request.fields["jobType"] = jobType;
    request.fields["CPRNumber"] = cprNumber;
    request.fields["CPRExpDate"] = cprExpDate;
    request.fields["passportNumber"] = passportNumber;
    request.fields["passportExpDate"] = passportExpDate;
    request.fields["note"] = note;
    request.fields["dutyTime"] = dutyTime;
    request.fields["breakTimeStart"] = breakTimeStart;
    request.fields["breakTimeEnd"] = breakTimeEnd;
    request.fields["workingDay"] = jsonEncode(workingDay);
    request.fields["offDay"] = offDay;
    request.fields["authId"] = authId;
    request.fields["userId"] = userId;

    // Only add profile image if a new one is provided and exists
    if (profileImage != null && await profileImage.exists()) {
      request.files.add(await http.MultipartFile.fromPath(
        "profile_image",
        profileImage.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    String? savedToken = await SharePrefsHelper.getString(AppConstants.token);
    var token = savedToken;

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type": "multipart/form-data",
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print("Response Status Code: ${response.statusCode}");
      print("Response Data: $responseData");

      if (response.statusCode == 200) {
        // Success handling - but wrap potentially problematic operations
        try {
          employeeController.editLoading(false);

          // Call getEmployee in a separate try-catch to isolate potential null errors
          try {
            employeeController.getEmployee();
          } catch (getEmployeeError) {
            print("Error in getEmployee: $getEmployeeError");
            // Continue execution even if getEmployee fails
          }

          toastMessage(message: "Employee updated successfully!");
          Get.back();
          print("Employee updated successfully!");
        } catch (successHandlingError) {
          print("Error in success handling: $successHandlingError");
          // Still show success message even if there are UI issues
          employeeController.editLoading(false);
          toastMessage(message: "Employee updated successfully!");
        }
      } else {
        employeeController.editLoading(false);
        print("Failed: ${response.statusCode}");
        print("Error Response: $responseData");

        String errorMessage = "Something went wrong!";
        try {
          var decodedData = json.decode(responseData);
          if (decodedData["message"] != null) {
            errorMessage = decodedData["message"];
          }
        } catch (e) {
          print("JSON Parsing Error: $e");
        }

        toastMessage(message: errorMessage);
      }
    } catch (e) {
      employeeController.editLoading(false);
      toastMessage(message: "An error occurred. Please check your connection.");
      print("Network/Request Error: $e");
    }
  }

  ///==========
  static RxBool isDeleteLoading = false.obs;

  static Future<void> deleteEmployee(
      {required String userId, required String authId}) async {
    try {
      isDeleteLoading.value = true;

      String? savedToken = await SharePrefsHelper.getString(AppConstants.token);
      // if (savedToken == null) {
      //   toastMessage(message: "❌ Authentication Failed! Please login again.");
      //   return;
      // }

      var body = jsonEncode({
        "userId": userId,
        "authId": authId,
      });

      var response = await http.delete(
        Uri.parse(ApiUrl.employeeDelete),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $savedToken",
        },
        body: body,
      );

      isDeleteLoading.value = false;

      if (response.statusCode == 200) {
        AddEmployeeController employeeController = Get.find();
        employeeController.getEmployee();
        var jsonResponse = jsonDecode(response.body);
        toastMessage(message: jsonResponse["message"]);

        print("${response.body}");
      } else if (response.statusCode == 404) {
        var jsonResponse = jsonDecode(response.body);
        toastMessage(message: jsonResponse["message"]);
      } else {
        toastMessage(message: "❌ Something went wrong! Please try again.");
      }
    } catch (e) {
      isDeleteLoading.value = false;
      toastMessage(
          message: "❌ An error occurred. Please check your connection.");
      print("❌ Error: $e");
    }
  }
}
