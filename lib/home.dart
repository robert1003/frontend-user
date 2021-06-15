import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:tracking/record.dart';
import 'api.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  //const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _url = "None";
  String _message = "Null";
  bool _success = false;

  Future<void> check() async {
    Tuple2<bool, String> t = await Api.checkin(_url);
    setState(() {
      _success = t.item1;
      _message = t.item2;
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      print('failed');
      return;
    }

    setState(() {
      _url = barcodeScanRes;
    });
  }

  Future<String> getAccount() async {
    var secureStorage = new FlutterSecureStorage();
    String? username = await secureStorage.read(key: 'username');
    return username == null ? 'NONE' : username;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: const Text('Home'),
              actions: [
                IconButton(
                  onPressed: () async {
                    bool result = await Api.logout();
                    if (result) {
                      Navigator.pop(context);
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Logout failed'),
                          content: const Text('Please try again'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.logout),
                )
              ],
            ),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: FutureBuilder<String>(
                            future: getAccount(),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text('loading...', style: TextStyle(fontSize: 16));
                              } else {
                                if (snapshot.hasError) return Text("Error: Can't load username", style: TextStyle(fontSize: 16));
                                else return Text("${snapshot.data}", style: TextStyle(fontSize: 50));
                              }
                            }
                          ),
                        ),
                        SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: () async {
                              await scanQR();
                              await check();
                              print('success $_success');
                              if (_success) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RecordSuccess(message: _message)),
                                );
                              } else {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Invalid QR Code'),
                                    content: const Text('Please scan it again'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                            },
                            child: Text('Scan QR Code')),
                        //Text('Scan result : $_url\n',
                        //    style: TextStyle(fontSize: 20))
                      ]
                  )
              );}
            )
        )
    );
  }
}
