import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'global_config.dart';
import 'dart:convert';
import 'dart:io';


class HttpHelper {

  String noInternetMessage = 'لا يوجد إتصال بالإنترنت';

  String connectionTimeOutMessage = 'خطأ فى الإتصال بالخادم';

  String sendingTimeOutMessage = 'خطأ فى الإتصال بالخادم';

  String notSuccessResponse = 'خطأ فى الإتصال بالخادم';

  String recivingTimeOutMessage = 'خطأ فى الإتصال بالخادم';

  String authorizationMessage = 'غير مسموح الإتصال بالخادم';

  Dio _getDio() {
    Dio dio = new Dio()..options.baseUrl = apiUrl;
    return dio;
  }

  Future<Map<String,dynamic>> postJsonData(
      {@required String url,
        @required Map<String, dynamic> data,
        String token}) async {
    url = 'https://cms.gdforce.com'+url;

    data["lang"]= "ar";
    data["loginuid"]= "9458b0ad-80fb-4c0f-a515-58159c1f51fb";

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    Map<String, dynamic> map = json.decode(reply);
    //    for (dynamic data in map['data']) {
//      returnedMap.add({
//        'name': data['name'] ?? 'noName',
//        'image': data['logo']['url'] ?? 'noUrl',
//        'id': data['id'].toString(),
//      });
//    }
//    print(apiUrl+""+url);
//    var response = await _getDio()
//        .post(url,data: jsonEncode(data)   , options: _getRequestOptions(token))
//        .catchError((e) => mapErrorResponse(e));
//print(response);
    return map ;
  }

  Future<Response> putJsonData(
      {@required String url,
        @required Map<String, dynamic> data,
        String token}) async {
    var response = await _getDio()
        .put(url, data: data, options: _getRequestOptions(token))
        .catchError((e) => mapErrorResponse(e));
    return response;
  }



  Future<Response> deleteData({@required String url, String token}) async {
    var response = await _getDio()
        .delete(url, options: _getRequestOptions(token))
        .catchError((e) => mapErrorResponse(e));
    return response;
  }


  Future<Response> postFile(
      {@required String url, @required File file, token}) async {


    FormData formData = FormData.fromMap({
      "image":
      await MultipartFile.fromFile(file.path, filename:path.basename(file.path)),
    });

    print(apiUrl+""+url);
    var response = await _getDio()
        .post(
      url,
      data: formData,
      options: Options(headers: {"Authorization": "Bearer " + token}),
    )
        .catchError((e) => mapErrorResponse(e));


    return response;

  }

  Future<dynamic> getJsonData(
      {@required String url, String token, Map<String, dynamic> params}) async {
    var response = await _getDio()
        .get(
      url,
      queryParameters: params,
      options: _getRequestOptions(token),
    )
        .catchError((e) => mapErrorResponse(e));
    return response.data;
  }

  Future<dynamic> getResponse(
      {@required String url, String token, Map<String, dynamic> params}) async {
    var response = await _getDio()
        .get(
      url,
      queryParameters: params,
      options: _getRequestOptions(token),
    )
        .catchError((e) => mapErrorResponse(e));
    return response;
  }

  Options _getRequestOptions(token) {
    var headers = {
      "content-type": "application/json",
      //  "accept": "application/json",

    };
    //  if (token != null) headers["Authorization"] = "Bearer " + token;
    var options = Options(
      headers: headers,
      //connectTimeout: 90000,
      receiveTimeout: 90000,
      sendTimeout: 90000,
      validateStatus: (s) => true,
      receiveDataWhenStatusError: false,
    );
    return options;
  }


  void mapErrorResponse(dynamic e) {
    /*
    if (e is DioError) {
      DioError error = e;
      if (error.type == DioErrorType.DEFAULT && error.error is SocketException)
        throw HttpException(noInternetMessage );
      else if (error.type == DioErrorType.CONNECT_TIMEOUT)
        throw HttpException(connectionTimeOutMessage);
      else if (error.type == DioErrorType.RECEIVE_TIMEOUT)
        throw HttpException(recivingTimeOutMessage);
      else if (error.type == DioErrorType.SEND_TIMEOUT)
        throw HttpException(sendingTimeOutMessage );
      else if (error.type == DioErrorType.RESPONSE)
        throw HttpException(notSuccessResponse);
      else if (error.type != DioErrorType.CANCEL)
        throw HttpException(error.message);
    } else*/
    //  throw HttpException(e.toString());
  }

}