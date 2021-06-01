import 'package:flutter/material.dart';
import 'package:tracking/welcome.dart';
import 'package:tracking/auth.dart';
import 'package:tracking/home.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/auth': (context) => AuthSigninScreen(),
        '/home': (context) => HomeScreen(),
      },
    ),
  );
}