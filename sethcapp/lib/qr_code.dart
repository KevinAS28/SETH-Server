import 'dart:async';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sethcapp/pages/fab_bottom_app_bar.dart';
import 'package:sethcapp/cert_made.dart';
import 'package:sethcapp/pages/dashboard.dart';
import 'package:sethcapp/pages/place.dart';
import 'package:sethcapp/info_screen.dart';
import 'package:sethcapp/history_pass.dart';
import 'package:sethcapp/info_rs.dart';
import 'package:sethcapp/widgets/my_header.dart';

class qr_code extends StatefulWidget {
  @override
  _qr_codeState createState() => new _qr_codeState();
}

class _qr_codeState extends State<qr_code> {
  String _lastSelected = 'TAB: 0';
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
  Widget build(BuildContext context) {
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
              textBottom: "Qr",
              offset: offset,
            ),
            new Container(
              child:
                  new ElevatedButton(onPressed: scan, child: new Text("Scan")),
              padding: const EdgeInsets.all(10.0),
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
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
