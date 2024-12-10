import 'dart:convert';
import 'dart:io';
import 'package:account_management_client/model/wrapped_response.dart';
import 'package:account_management_client/store/app_global_store.dart';
import 'package:http/http.dart' as http;

abstract class BaseService {
  Map<String, String> _constructHeaders(Map<String, String>? headers) {
    headers ??= {};

    // Insert Authorization Header
    final jwtToken = AppGlobalStore().getToken();
    headers.putIfAbsent("Authorization", () => "Bearer $jwtToken");
    return headers;
  }

  Future<WrappedResponse> _wrappedHttpRequest(
      Future<http.Response> Function() httpReqFunc) async {
    WrappedResponse wrappedResponse = WrappedResponse();
    try {
      final response = await httpReqFunc();
      wrappedResponse.hasErrorOccurred = response.statusCode >= 400;
      wrappedResponse.response = response;
      if (response.body.isNotEmpty) {
        wrappedResponse.response = jsonDecode(response.body);
      }
    } on SocketException {
      wrappedResponse.hasErrorOccurred = true;
      wrappedResponse.response = 'No Internet connection';
    } on HttpException {
      wrappedResponse.hasErrorOccurred = true;
      wrappedResponse.response = 'Unable to find endpoint';
    } on Exception catch (ex) {
      wrappedResponse.hasErrorOccurred = true;
      wrappedResponse.response = ex.toString();
    }
    return wrappedResponse;
  }

  Future<WrappedResponse> wrappedPostRequest(
      {required String url,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding}) async {
    return _wrappedHttpRequest(() => http.post(
          Uri.parse(url),
          headers: _constructHeaders(headers),
          body: body,
          encoding: encoding,
        ));
  }

  Future<WrappedResponse> wrappedGetRequest(
      {required String url, Map<String, String>? headers}) async {
    return _wrappedHttpRequest(() => http.get(
          Uri.parse(url),
          headers: _constructHeaders(headers),
        ));
  }

  Future<WrappedResponse> wrappedPutRequest(
      {required String url,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding}) async {
    return _wrappedHttpRequest(() => http.put(Uri.parse(url),
        headers: _constructHeaders(headers), body: body, encoding: encoding));
  }

  Future<WrappedResponse> wrappedDeleteRequest(
      {required String url,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding}) async {
    return _wrappedHttpRequest(() => http.delete(Uri.parse(url),
        headers: _constructHeaders(headers), body: body, encoding: encoding));
  }
}
