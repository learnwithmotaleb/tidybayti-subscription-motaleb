import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/global/helper/connection_checker.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/logger/logger.dart';

final log = logger(ApiClient);

Map<String, String> basicHeaderInfo() {
  return {
    HttpHeaders.acceptHeader: "application/json",
    // HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.contentTypeHeader: "multipart/form-data",
  };
}

Future<Map<String, String>> bearerHeaderInfo() async {
  final token = await SharePrefsHelper.getString(AppConstants.token);
  debugPrint("Token _________ $token");
  return {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
}

String noInternetConnection = "No internet connection.!";

ConnectionChecker connectionChecker = serviceLocator();

class ApiClient {
  //=========================== Get method ======================

  Future<Response> get(
      {required String url,
      bool isBasic = false,
      int duration = 30,
      bool showResult = false,
      BuildContext? context}) async
  {
    /// ======================- Check Internet ===================

    if (!await (connectionChecker.isConnected)) {
      return Response(statusCode: 503, statusText: noInternetConnection);
    }



    if (showResult) {
      log.i(
          '|📍📍📍|----------------- [[ GET ]] method details start -----------------|📍📍📍|');
      log.i(url);
    }

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));
      if (response.statusCode == 401) {
        await SharePrefsHelper.remove(AppConstants.token);
        Get.offAllNamed(AppRoutes.signInScreen);
        return Response(body: {}, statusCode: 401, statusText: 'Unauthorized');
      }

      if (showResult) {
        log.d("Body => ${response.body}");
        log.d("Status Code => ${response.statusCode}");

        log.i(
            '|📒📒📒|-----------------[[ GET ]] method response end -----------------|📒📒📒|');
      }

      var body = jsonDecode(response.body);

      return Response(
        body: body ?? response.body,
        bodyString: response.body.toString(),
        request: Request(
            headers: response.request!.headers,
            method: response.request!.method,
            url: response.request!.url),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.reasonPhrase,
      );
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      //showSnackBar(context!, 'Check your Internet Connection and try again!');
      //context.pushNamed(RoutePath.errorScreen);

      if (context != null && context.mounted) {
        // showSnackBar(
        //     context: context, content: 'Error Alert on Socket Exception');
        // context.pushNamed(RoutePath.errorScreen);
      }
      return const Response(
          body: {},
          statusCode: 400,
          statusText: 'Error Alert on Socket Exception');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');

      log.e('Time out exception$url');

      return const Response(
          body: {}, statusCode: 400, statusText: 'Time out exception');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception 🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());
      if (context != null && context.mounted) {
        // context.pushNamed(RoutePath.errorScreen);
      }
      return const Response(
          body: {},
          statusCode: 400,
          statusText: 'Error Alert Client Exception');
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return const Response(
          body: {}, statusCode: 400, statusText: "Something went wrong");
    }
  }

  Future<Response> patchMultipart({
    required String url,
    bool isBasic = false,
    Map<String, String>? body,
    required List<MultipartBody> multipartBody,
    bool showResult = true,
  }) async
  {
    try {
      if (!await (connectionChecker.isConnected)) {
        return Response(statusCode: 503, statusText: noInternetConnection);
      }

      if (showResult) {
        log.i(
            '|📍📍📍|-----------------[[ MULTIPART PATCH ]] start -----------------|📍📍📍|');
        log.i("URL => $url");
        log.i("Body => $body");
      }

      final request = http.MultipartRequest(
        'PATCH', // 👈 PATCH instead of POST
        Uri.parse(url),
      )
        ..fields.addAll(body ?? {})
        ..headers.addAll(
          isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
        );

      for (var element in multipartBody) {
        if (element.file.path.isEmpty) continue;

        var mimeType =
            lookupMimeType(element.file.path) ?? 'application/octet-stream';

        var multipartFile = await http.MultipartFile.fromPath(
          element.key,
          element.file.path,
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var jsonData = await http.Response.fromStream(streamedResponse);

      if (showResult) {
        log.i("Response Body => ${jsonData.body}");
        log.i("Status Code => ${streamedResponse.statusCode}");
        log.i(
            '|📒📒📒|-----------------[[ MULTIPART PATCH ]] end --------------------|📒📒📒|');
      }

      var decodedBody = jsonDecode(jsonData.body);

      return Response(
        body: decodedBody,
        statusCode: streamedResponse.statusCode,
      );
    } on SocketException {
      return const Response(
          body: {}, statusCode: 400, statusText: 'Socket Exception');
    } on TimeoutException {
      return const Response(
          body: {}, statusCode: 400, statusText: 'Timeout Exception');
    } on http.ClientException catch (err, stacktrace) {
      log.e(err.toString());
      log.e(stacktrace.toString());
      return const Response(
          body: {}, statusCode: 400, statusText: 'Client Exception');
    } catch (e) {
      log.e("Unhandled error: $e");
      return const Response(
          body: {}, statusCode: 400, statusText: 'Unhandled Error');
    }
  }

  //========================== Post Method =======================
  Future<Response> post(
      {required String url,
      bool isBasic = false,
      Map<String, dynamic>? body,
      // required BuildContext context,
      int duration = 30,
      bool showResult = true}) async
  {
    try {
      /// ======================- Check Internet ===================

      if (!await (connectionChecker.isConnected)) {
        return Response(statusCode: 503, statusText: noInternetConnection);
      }

      if (showResult) {
        log.i(
            '|📍📍📍|-----------------[[ POST ]] method details start -----------------|📍📍📍|');

        log.i("URL => $url");

        log.i("Body => $body");
      }

      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log.i("response.body => ${response.body}");
      }

      log.i("response.statusCode => ${response.statusCode}");

      log.i(
          '|📒📒📒|-----------------[[ POST ]] method response end --------------------|📒📒📒|');

      body = jsonDecode(response.body);

      return Response(
        body: body ?? response.body,
        bodyString: response.body.toString(),
        request: Request(
            headers: response.request!.headers,
            method: response.request!.method,
            url: response.request!.url),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.reasonPhrase,
      );
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      // if (context.mounted) {
      //   // showSnackBar(
      //   //     context: context, content: 'Error Alert on Socket Exception');
      //   // // context.pushNamed(RoutePath.errorScreen);
      // }

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');

      log.e('Time out exception$url');

      return Response(
          body: {}, statusCode: 400, statusText: 'Time out exception $url');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return Response(
          body: {},
          statusCode: 400,
          statusText: 'client exception hitted $url');
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    }
  }

  Future<Response> patch(
      {required String url,
      bool isBasic = false,
      Map<String, dynamic>? body,
      int duration = 30,
      bool showResult = false}) async
  {
    try {
      /// ======================- Check Internet ===================

      if (!await (connectionChecker.isConnected)) {
        return Response(statusCode: 503, statusText: noInternetConnection);
      }

      if (showResult) {
        log.i(
            '|📍📍📍|-----------------[[ PATCH ]] method details start -----------------|📍📍📍|');

        log.i("URL => $url");

        log.i("Body => $body");
      }

      final response = await http
          .patch(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (response.statusCode == 401) {
        await SharePrefsHelper.remove(AppConstants.token);
        Get.offAllNamed(AppRoutes.signInScreen);
        return Response(body: {}, statusCode: 401, statusText: 'Unauthorized');
      }

      if (showResult) {
        log.i("response.body => ${response.body}");
        log.i("response.statusCode =>=>=>=>=> ${response.statusCode}");
        log.i(
            '|📒📒📒|-----------------[[ PATCH ]] method response end --------------------|📒📒📒|');
      }

      body = jsonDecode(response.body);

      return Response(
        body: body ?? response.body,
        bodyString: response.body.toString(),
        request: Request(
            headers: response.request!.headers,
            method: response.request!.method,
            url: response.request!.url),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.reasonPhrase,
      );
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');

      log.e('Time out exception$url');

      return Response(
          body: {}, statusCode: 400, statusText: 'Time out exception $url');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return Response(
          body: {},
          statusCode: 400,
          statusText: 'client exception hitted $url');
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    }
  }

  // Param get method
  Future<Map<String, dynamic>?> paramGet(
      {String? url,
      bool? isBasic,
      Map<String, String>? body,
      int code = 200,
      int duration = 15,
      bool showResult = false}) async
  {
    log.i(
        '|Get param📍📍📍|----------------- [[ GET ]] param method Details Start -----------------|📍📍📍|');

    log.i("##body given --> ");

    if (showResult) {
      log.i(body);
    }

    log.i("##url list --> $url");

    log.i(
        '|Get param📍📍📍|----------------- [[ GET ]] param method details ended ** ---------------|📍📍📍|');

    try {
      final response = await http
          .get(
            Uri.parse(url!).replace(queryParameters: body),
            headers: isBasic! ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(const Duration(seconds: 15));

      log.i(
          '|📒📒📒| ----------------[[ Get ]] Peram Response Start---------------|📒📒📒|');



      if (showResult) {
        log.i(response.body.toString());
      }

      log.i(
          '|📒📒📒| ----------------[[ Get ]] Peram Response End **-----------------|📒📒📒|');

      if (response.statusCode == code) {
        return jsonDecode(response.body);
      } else {
        log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

        log.e(
            'unknown error hitted in status code  ${jsonDecode(response.body)}');

        return null;
      }
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      return null;
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('Time out exception$url');

      return null;
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return null;
    } catch (e) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('#url->$url||#body -> $body');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return null;
    }
  }

  /// ========================= MaltiPart Request =====================
  Future<Response> multipartRequest(
      {required String url,
      required String reqType,
      bool isBasic = false,
      Map<String, String>? body,
      required List<MultipartBody> multipartBody,
      bool showResult = true}) async
  {
    try {
      /// ======================- Check Internet ===================

      if (!await (connectionChecker.isConnected)) {
        return Response(statusCode: 503, statusText: noInternetConnection);
      }


      if (showResult) {
        log.i(
            '|📍📍📍|-----------------[[ MULTIPART $reqType]] method details start -----------------|📍📍📍|');

        log.i("===> URL => $url");

        log.i("====> body => $body");
      }

      final request = http.MultipartRequest(
        reqType,
        Uri.parse(url),
      )
        ..fields.addAll(body ?? {})
        ..headers.addAll(
          isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
        );

      if (multipartBody.isNotEmpty) {
        // ignore: avoid_function_literals_in_foreach_calls
        multipartBody.forEach((element) async {
          if (element.file.path.isEmpty) {
            return;
          }
          debugPrint("path : ${element.file.path}");

          var mimeType = lookupMimeType(element.file.path);

          debugPrint("MimeType================$mimeType");

          var multipartImg = await http.MultipartFile.fromPath(
            element.key,
            element.file.path,
            contentType: MediaType.parse(mimeType!),
          );
          request.files.add(multipartImg);
          //request.files.add(await http.MultipartFile.fromPath(element.key, element.file.path,contentType: MediaType('video', 'mp4')));
        });
      }

      // ..files.add(await http.MultipartFile.fromPath(filedName!, filepath!));
      var response = await request.send();
      var jsonData = await http.Response.fromStream(response);

      if (showResult) {
        log.i("===> Response Body => ${jsonData.body}");

        log.i("===> Status Code =>${response.statusCode}");

        log.i(
            '|📒📒📒|-----------------[[ MULTIPART $reqType ]] method response end --------------------|📒📒📒|');
      }

      var decodeBody = jsonDecode(jsonData.body);

      return Response(
        body: decodeBody,
        statusCode: response.statusCode,
      );
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');

      log.e('Time out exception$url');

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Error Alert Timeout Exception 🐞🐞🐞');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return const Response(
          body: {}, statusCode: 400, statusText: 'client exception hitted');
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    }
  }



  Future<Response> delete(
      {required String url,
      bool isBasic = false,
      Map<String, dynamic>? body,
      // required BuildContext context,
      int duration = 30,
      bool showResult = true}) async {
    try {
      /// ======================- Check Internet ===================

      if (!await (connectionChecker.isConnected)) {
        return Response(statusCode: 503, statusText: noInternetConnection);
      }

      if (showResult) {
        log.i(
            '|📍📍📍|-----------------[[ POST ]] method details start -----------------|📍📍📍|');

        log.i("URL => $url");

        log.i("Body => $body");
      }

      final response = await http
          .delete(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));



      if (response.statusCode == 401) {
        _handle401();
        return const Response(body: {}, statusCode: 401, statusText: 'Unauthorized');
      }

      if (showResult) {
        log.i("response.body => ${response.body}");
      }

      log.i("response.statusCode => ${response.statusCode}");

      log.i(
          '|📒📒📒|-----------------[[ POST ]] method response end --------------------|📒📒📒|');

      body = jsonDecode(response.body);

      return Response(
        body: body ?? response.body,
        bodyString: response.body.toString(),
        request: Request(
            headers: response.request!.headers,
            method: response.request!.method,
            url: response.request!.url),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.reasonPhrase,
      );
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');

      log.e('Time out exception$url');

      return Response(
          body: {}, statusCode: 400, statusText: 'Time out exception $url');
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return Response(
          body: {},
          statusCode: 400,
          statusText: 'client exception hitted $url');
    } catch (e) {
      log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');

      log.e('❌❌❌ unlisted error received');

      log.e("❌❌❌ $e");

      return const Response(
          body: {},
          statusCode: 400,
          statusText: '🐞🐞🐞 Other Error Alert 🐞🐞🐞');
    }
  }


  Future<Map<String, dynamic>?> put(
      {String? url,
      bool? isBasic,
      Map<String, dynamic>? body,
      int code = 202,
      int duration = 15,
      bool showResult = false}) async {
    try {
      log.i(
          '|📍📍📍|-------------[[ PUT ]] method details start-----------------|📍📍📍|');

      log.i(url);

      log.i(body);

      log.i(
          '|📍📍📍|-------------[[ PUT ]] method details end ------------|📍📍📍|');

      final response = await http
          .put(
            Uri.parse(url!),
            body: jsonEncode(body),
            headers: isBasic! ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      log.i(
          '|📒📒📒|-----------------[[ PUT ]] AKA Update method response start-----------------|📒📒📒|');

      if (showResult) {
        log.i(response.body);
      }

      log.i(response.statusCode);

      log.i(
          '|📒📒📒|-----------------[[ PUT ]] AKA Update method response End -----------------|📒📒📒|');

      if (response.statusCode == code) {
        return jsonDecode(response.body);
      } else {
        log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

        log.e(
            'unknown error hitted in status code  ${jsonDecode(response.body)}');

        return null;
      }
    } on SocketException {
      log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

      return null;
    } on TimeoutException {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('Time out exception$url');

      return null;
    } on http.ClientException catch (err, stackrace) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('client exception hitted');

      log.e(err.toString());

      log.e(stackrace.toString());

      return null;
    } catch (e) {
      log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

      log.e('unlisted catch error received');

      log.e(e.toString());

      return null;
    }
  }

}

class MultipartBody {
  String key;
  File file;
  MultipartBody(this.key, this.file);
}

void _handle401() {
  SharePrefsHelper.remove(AppConstants.token);

  Get.snackbar(
    '',
    'Session expired, please login again.',
    titleText: const SizedBox.shrink(), // title hide করবে
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    snackPosition: SnackPosition.BOTTOM,
  );

  Future.delayed(const Duration(seconds: 3), () {
    Get.offAllNamed(AppRoutes.signInScreen);
  });
}