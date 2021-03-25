import 'dart:async';
import 'dart:io';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sethcapp/domain/user.dart';
import 'package:sethcapp/pages/fab_bottom_app_bar.dart';
import 'package:sethcapp/cert_made.dart';
import 'package:sethcapp/pages/dashboard.dart';
import 'package:sethcapp/pages/place.dart';
import 'package:sethcapp/info_screen.dart';
import 'package:sethcapp/history_pass.dart';
import 'package:sethcapp/info_rs.dart';
import 'package:sethcapp/providers/user_provider.dart';
import 'package:sethcapp/util/api.dart';
import 'package:sethcapp/util/app_url.dart';
import 'package:sethcapp/widgets/my_header.dart';

class qr_code extends StatefulWidget {
  @override
  _qr_codeState createState() => new _qr_codeState();
}

class _qr_codeState extends State<qr_code> {
  // _qr_codeState(){

  // }

  String _lastSelected = 'TAB: 0';

  void _logoutDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirmation"),
          content: new Text("Are you sure you want to logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeScreen(),

                ));
              },
            ),

          ],
        );
      },
    );
  }

  void _selectedTab(int index) {
    if (index == 0) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new DashBoard()));
    } else if (index == 1) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new cert_made()));
    } else if (index == 2) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new qr_code()));
    } else if (index == 3) {
      return _logoutDialog();
    }
    print("selectedTab: $index");
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  void _selectedFab(int index) {
    if (index == 0) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new Place()));
    } else if (index == 1) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new info_screen()));
    } else if (index == 3) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new history_pass()));
    } else if (index == 2) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new info_rs()));
    }
    print("selectedFab: $index");
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  String barcode = "";
  int status = 0;

  @override
  initState() {
    super.initState();
  }

  final controller = ScrollController();

  double offset = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Future<bool> _onBackPressed() async {
    print('Back Pressed');
  }

  @override
  Widget build(BuildContext context) {
    if (this.status == 0) {
      scan();
      print('Barcode: ${this.barcode}');
    } 
    else {
      // this.dispose();
      // sleep(Duration(seconds:1));
      if (this.status==-1){
        User user = Provider.of<UserProvider>(context, listen: false).user;
        Map<String, dynamic> data = {"user_id": user.nik};
        hitApiUs(user, AppUrl.qr, data);
        print('Sent data to B QR ${AppUrl.qr}');
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new DashBoard()));
      });
    }

    return Scaffold();

    // if (this.barcode==""){
    //   Navigator.push(context,
    //       new MaterialPageRoute(builder: (context) => new DashBoard()));

    // }
    // this.dispose();
    // Navigator.push(context,
    //     new MaterialPageRoute(builder: (context) => new DashBoard()));
    // Navigator.pop(context);
    // return Scaffold();

    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Scan",
              textBottom: "Qr Code",
              offset: offset,
            ),
            new Container(
              child:
              new ElevatedButton(onPressed: scan, child: new Text("Scan")),
              padding: const EdgeInsets.all(10.0),
            ),
            Text(
              "Click to scan!",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            new Text(barcode),
          ],
        ),
      ),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'Info',
        color: Colors.grey,
        selectedColor: Colors.red,
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.layers, text: 'Certificate'),
          FABBottomAppBarItem(iconData: Icons.settings_overscan, text: 'Scan'),
          FABBottomAppBarItem(iconData: Icons.logout, text: 'Logout'),
        ],
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(
        () => this.barcode = barcode
        );
      this.status = -1;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          var msg = 'The user did not grant the camera permission!';
          this.barcode = msg;
          print(msg);
          this.status = 1;
        });
      } else {
        setState(() {
          var msg = 'Unknown error: $e';
          this.barcode = msg;
          print(msg);
          this.status = 2;
        });
      }
    } on FormatException {
      setState(() {
        var msg =
            'null (User returned using the "back"-button before scanning anything. Result)';
        this.barcode = msg;
        print(msg);
        this.status = 3;
      });
    } catch (e) {
      setState(() {
        var msg = 'Unknown error: $e';
        this.barcode = msg;
        print(msg);
        this.status = 4;
      });
    }
  }
}
