import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class qr_code extends StatefulWidget {
  qr_code({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _qr_codeState createState() => _qr_codeState();
}

class _qr_codeState extends State<qr_code> {
  String qrData = "https://www.google.com/";
  final qrdataFeed = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar having title
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          //Scroll view given to Column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QrImage(data: qrData),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                //Button for generating QR code
                child: FlatButton(
                  onPressed: () async {
                    //a little validation for the textfield
                    if (qrdataFeed.text.isEmpty) {
                      setState(() {
                        qrData = "";
                      });
                    } else {
                      setState(() {
                        qrData = qrdataFeed.text;
                      });
                    }
                  },
                  //Title given on Button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
