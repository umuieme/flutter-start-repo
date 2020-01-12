import 'package:dio/dio.dart';

Dio dio = new Dio(BaseOptions(
  //todo setupbase helper
    baseUrl:
        "",
    connectTimeout: 5000,
    receiveTimeout: 3000,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }));
