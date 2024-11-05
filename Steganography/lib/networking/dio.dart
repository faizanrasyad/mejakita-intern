import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Dio Client for Setup
class DioClient {
  // Declare the baseUrl (API Url)
  final baseUrl = "http://192.168.1.7:7212/api";

// Setup your Dio Settins
  Future<Dio> getClient() async {
    Dio dio = new Dio();

    // Headers
    Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
    };
    dio.options.headers = headers;

    // Timeout
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    // Interceptors (Logging for easier maintenance)
    dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true));

    return dio;
  }
}

// Dio Commands
class DioCommands {
  Future<void> postCatatan(String name, int userId, String description) async {
    try {
      Dio dio = await DioClient().getClient();
      Response newCatatan = await dio.post("${DioClient().baseUrl}/catatans",
          data: {'name': name, 'author': userId, 'description': description});
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  Future<void> postImage(String image, int catatanId) async {
    try {
      Dio dio = await DioClient().getClient();
      Response newImage = await dio.post("${DioClient().baseUrl}/images",
          data: {'image1': image, 'catatanId': catatanId});
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  Future<void> postUser(String name, String username, String password) async {
    try {
      Dio dio = await DioClient().getClient();
      Response newUser = await dio.post("${DioClient().baseUrl}/users",
          data: {'name': name, 'username': username, 'password': password});
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }
}
