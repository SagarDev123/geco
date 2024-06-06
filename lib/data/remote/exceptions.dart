import 'dart:io';

class ApiErrorException implements Exception {
  String? message = '';
  int statusCode = 200;

  ApiErrorException({this.statusCode = 0, this.message});

  String toString() {
    String? message = this.message;
    if (message == null) return "Server Communication Error";
    return message;
  }
}
