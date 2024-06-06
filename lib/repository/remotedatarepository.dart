import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/remote/api_config.dart';
import '../data/remote/exceptions.dart';

class RemoteDataRepository {
  Future<dynamic> requestRemotePost(
      {required String endpoint, dynamic param, dynamic apiQuerymap}) async {
    final urlEndpoint = '${Config.baseUrl}$endpoint';
    Uri uri = Uri.parse(urlEndpoint);
    var header = <String, String>{
      'Content-Type': Config.contentType,
      'User-Agent': 'Mobile'
    };
    if (apiQuerymap != null) {
      uri = Uri.parse(urlEndpoint);
      uri = uri.replace(queryParameters: apiQuerymap);
    } else {
      uri = Uri.parse(urlEndpoint);
    }
    final http.Response response =
        await http.post(uri, headers: header, body: jsonEncode(param));
    return processResponse(response);
  }
}

dynamic processResponse(http.Response response) {
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 403) {
    throw ApiErrorException(statusCode: 403, message: 'Auth Token Expired');
  } else {
    throw ApiErrorException(
        statusCode: 500, message: jsonDecode(response.body)['message']);
  }
}
