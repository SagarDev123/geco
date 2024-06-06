import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/remote/api_config.dart';
import '../data/remote/exceptions.dart';

class RemoteDataRepository {
  Future<dynamic> requestRemotePost({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    // Construct the base URL
    Uri uri = Uri.parse('${Config.baseUrl}$endpoint');

    // Set up headers for a JSON content type
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded"
    };

    // Make the HTTP POST request
    http.Response response;
    try {
      response = await http.post(uri,
          headers: headers, body: body // Encode the body map as a JSON string
          );

      // Debugging: Print only status code and body for security reasons
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } catch (e) {
      // Handle any errors that occur during the POST request
      print('Error during HTTP POST: $e');
      throw Exception('Failed to post data to $endpoint');
    }

    // Process the response (assuming processResponse is a function that handles the response)
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
