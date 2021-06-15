import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class Api {
  static final secureStorage = new FlutterSecureStorage();
  static final String server = 'http://linux5.csie.ntu.edu.tw:8888';
  static final String loginUrl = server + '/auth/user/login';
  static final String signupUrl = server + '/auth/user/signup';
  static final String checkInUrl = server + '/records';

  static Future<Tuple2<bool, String>> checkin(String storeId) async {
    String? token = await Api.secureStorage.read(key: 'token');
    final url = Uri.parse(checkInUrl);

    final headers = {"Content-type": "application/json", "Authorization": "Bearer ${token}"};
    final json = jsonEncode({"store_id": "${storeId}"});

    try {
      final response = await http.post(url, headers: headers, body: json);
      if (response.statusCode != 200) throw Exception("something went wrong");
      Map<String, dynamic> result = jsonDecode(response.body);
      print("checkin : ");
      print(result);
      String time = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(result['time']*1000));
      return Tuple2<bool, String>(true, 'Successfully checked in at ${result['store_name']} at ${time}.');
    } on Exception catch (e) {
      return Tuple2<bool, String>(false, 'Something went wrong');
    }
  }

  static Future<bool> login(String username, String password) async {
    print('login here');
    final url = Uri.parse(loginUrl);

    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({"phone": "${username}", "password": "${password}"});

    try {
      final response = await http.post(url, headers: headers, body: json);
      if (response.statusCode != 200) throw Exception("wrong username/password");
      Map<String, dynamic> user = jsonDecode(response.body);
      Api.secureStorage.write(key: 'username', value: username);
      Api.secureStorage.write(key: 'token', value: user['token']);
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  static Future<bool> signup(String username, String password) async {
    print('signup here');
    final url = Uri.parse(signupUrl);

    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({"phone": "${username}", "password": "${password}"});

    print(url);
    print(headers);
    print(json);

    try {
      final response = await http.post(url, headers: headers, body: json);
      print(response.body);
      if (response.statusCode != 200) throw Exception("username/password invalid");
      return login(username, password);
    } on Exception catch (e) {
      return false;
    }
  }

  static Future<bool> logout() async {
    Api.secureStorage.delete(key: 'token');
    Api.secureStorage.delete(key: 'username');
    return true;
  }
}