import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class RecordSuccess extends StatelessWidget {
  final String message;
  const RecordSuccess({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: Center(
        child: Text(message, style: TextStyle(fontSize: 16),),
      ),
    );
  }
}
