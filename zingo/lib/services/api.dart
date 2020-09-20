import 'dart:io';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';

enum API_METHOD { GET, POST, PUT }

class API {
  static const String EMU_URL = "10.0.2.2";
  static const String DEVICE_URL = "192.168.0.103";
  static const String BASE_API_URL = "http://$EMU_URL:8000/api/v1/";

  Map<String, String> getTokenAuthHeader({@required String token}) =>
      <String, String>{HttpHeaders.authorizationHeader: "Token " + token};

  Function requestMethod({API_METHOD apiMethod}) {
    switch (apiMethod) {
      case API_METHOD.POST:
        return http.post;
      case API_METHOD.PUT:
        return http.put;
      default:
        return http.get;
    }
  }

  String paramsToString(List<String> params) => params.join("/") + "/";

  Future get(List<String> params, {Map<String, dynamic> headers}) async {
    http.Response response;
    try {
      response = await requestMethod(apiMethod: API_METHOD.GET)(
          BASE_API_URL + paramsToString(params),
          headers: headers);
    } catch (e) {
      throw "GET Request failed";
    }
    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future post(List<String> params, Map body,
      {Map<String, String> headers}) async {
    http.Response response;
    try {
      response = await requestMethod(apiMethod: API_METHOD.POST)(
          BASE_API_URL + paramsToString(params),
          headers: headers,
          body: body);
    } catch (e) {
      throw "POST Request failed";
    }
    return json.decode(response.body);
  }

  Future postMultiPartFormData(List<String> params, Map body, Map headers,
      {String requestType, String key}) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(body['image'].openRead()));
    var length = await body['image'].length();

    var uri = Uri.parse(BASE_API_URL + paramsToString(params));

    var request = new http.MultipartRequest(requestType ?? "POST", uri);
    var multipartFile = new http.MultipartFile(key ?? 'image', stream, length,
        filename: basename(body['image'].path));
    body.remove('image');
    if (body.keys.isNotEmpty) {
      request.fields.addAll(Map.from(body));
    }
    request.headers.addAll(headers);

    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {});
  }

  Future delete(List<String> params, Map headers) async {
    await http.delete(BASE_API_URL + paramsToString(params), headers: headers);
  }
}
