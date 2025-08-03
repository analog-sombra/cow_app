import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../utils/const.dart';

class ApiResponse {
  bool status;
  dynamic data;
  String message;

  ApiResponse({
    required this.status,
    required this.data,
    required this.message,
  });
}

Future<ApiResponse> apiCall({
  required String query,
  Map<String, dynamic>? variables,
  Map<String, String>? headers,
}) async {
  try {
    // final bool isConnected =
    //     await InternetConnectionChecker.instance.hasConnection;

    bool result = await InternetConnection().hasInternetAccess;

    if (!result) {
      return ApiResponse(
        status: false,
        data: [],
        message: 'No Internet Connection',
      );
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'query': query,
        'variables': variables,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (responseData['data'] == null || responseData['data'] == '') {
      if (responseData['errors'][0]['originalError'] == "" ||
          responseData['errors'][0]['originalError'] == null) {
        return ApiResponse(
          status: false,
          data: [],
          message: responseData['errors'][0]['message'],
        );
      }

      final errorMessage =
          responseData['errors'][0]['originalError']['message'];

      return ApiResponse(
        status: false,
        data: [],
        message: errorMessage is List ? errorMessage[0] : errorMessage,
      );
    }

    return ApiResponse(
      status: true,
      data: responseData['data'],
      message: '',
    );
  } catch (e) {
    return ApiResponse(
      status: false,
      data: [],
      message: e.toString(),
    );
  }
}

class UploadResponse {
  bool status;
  dynamic data;
  String message;
  String function;

  UploadResponse({
    required this.status,
    required this.data,
    required this.message,
    required this.function,
  });
}

Future<UploadResponse> uploadFile(
  File file,
  String path,
) async {
  try {
    var request = http.MultipartRequest('POST', Uri.parse("$fileUrl$path"));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseString = await response.stream.bytesToString();
      var responseData = jsonDecode(responseString);
      return UploadResponse(
          status: true,
          function: "uploadFile",
          message: responseData["message"],
          data: responseData["data"]);
    } else {
      return UploadResponse(
        status: false,
        data: [],
        message: 'Image upload failed with status code: ${response.statusCode}',
        function: 'uploadFile',
      );
    }
  } catch (e) {
    return UploadResponse(
      status: false,
      data: [],
      message: e.toString(),
      function: "uploadFile",
    );
  }
}

Future<ApiResponse> getrequestApi(String url) async {
  try {
    var request = await http.get(Uri.parse(url));
    final data = jsonDecode(request.body);

    return ApiResponse(
      status: true,
      data: data,
      message: "Data fetched Successfully",
    );
  } catch (e) {
    return ApiResponse(
      status: false,
      data: [],
      message: e.toString(),
    );
  }
}
