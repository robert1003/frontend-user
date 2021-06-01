import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  static final secureStorage = new FlutterSecureStorage();
  static final String loginUrl = 'http://google.com';
  static final String signupUrl = 'http://google.com';

  static Future<Tuple2<bool, String>> checkin(String _url) async {
    String? token = await Api.secureStorage.read(key: 'cookie');
    final url = Uri.parse(_url);

    final headers = {"Content-type": "application/json"};
    final json = '{"title": "Hello", "body": "body text", "userId": 1}';

    try {
      final response = await http.post(url, headers: headers, body: json);
      return Tuple2<bool, String>(true, token != null ? token : 'null');
    } on SocketException catch (e) {
      return Tuple2<bool, String>(false, '456');
    }
  }

  static Future<bool> login(String username, String password) async {
    final url = Uri.parse(loginUrl);

    final headers = {"Content-type": "application/json"};
    final json = '{"title": "Hello", "body": "body text", "userId": 1}';

    try {
      final response = await http.post(url, headers: headers, body: json);
      Api.secureStorage.write(key: 'username', value: username);
      Api.secureStorage.write(key: 'cookie', value: '${username}Cookie');
      return true;
    } on SocketException catch (e) {
      return false;
    }
  }

  static Future<bool> signup(String username, String password) async {
    final url = Uri.parse(signupUrl);

    final headers = {"Content-type": "application/json"};
    final json = '{"title": "Hello", "body": "body text", "userId": 1}';

    try {
      final response = await http.post(url, headers: headers, body: json);
      Api.secureStorage.write(key: 'username', value: username);
      Api.secureStorage.write(key: 'cookie', value: 'testCookie');
      return true;
    } on SocketException catch (e) {
      return false;
    }
  }

  static Future<bool> logout() async {
    Api.secureStorage.delete(key: 'cookie');
    Api.secureStorage.delete(key: 'username');
    return true;
  }
}