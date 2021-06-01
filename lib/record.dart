import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class RecordScan extends StatefulWidget {
  //const RecordScan({Key key}) : super(key: key);

  @override
  _RecordScanState createState() => _RecordScanState();
}

class _RecordScanState extends State<RecordScan> {
  String _scanBarcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RecordSuccess extends StatelessWidget {
  final String location;
  const RecordSuccess({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: Center(
        child: Text('Successfully checked in at $location'),
      ),
    );
  }
}
