import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/scheduler.dart';

class WelcomeScreen extends StatefulWidget {
  //const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  Future<void> move() async {
    await Future.delayed(Duration(seconds: 1));
    var secureStorage = new FlutterSecureStorage();
    print(await secureStorage.readAll());
    final haveCookie = await secureStorage.containsKey(key: 'cookie');
    final haveAccount = await secureStorage.containsKey(key: 'username');
    if (haveCookie && haveAccount) {
      Navigator.pushNamed(context, '/home');
    } else {
      Navigator.pushNamed(context, '/auth');
    }
  }

  @override
  void initState() {
    super.initState();
    move();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text('WTF', style: TextStyle(fontSize: 50))
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/auth');
          },
          child: Text('Login/Signup'),
        ),
      ),
    );
  }
}
