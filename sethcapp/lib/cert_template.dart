import 'package:sethcapp/cert_made.dart';
import 'package:sethcapp/constant.dart';
import 'package:sethcapp/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:sethcapp/pages/dashboard.dart';
import 'package:sethcapp/pages/fab_bottom_app_bar.dart';
import 'package:sethcapp/cert_made.dart';
import 'package:sethcapp/qr_code.dart';
import 'package:sethcapp/pages/place.dart';
import 'package:sethcapp/info_screen.dart';
import 'package:sethcapp/info_rs.dart';
import 'package:sethcapp/history_pass.dart';
import 'package:flutter_svg/flutter_svg.dart';


class cert_template extends StatefulWidget {
  cert_template({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _cert_templateState createState() => _cert_templateState();
}

class _cert_templateState extends State<cert_template> {
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

  var subtitle;
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

  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
  }

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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MyHeader(
                image: "assets/icons/Drcorona.svg",
                textTop: "Certificate",
                textBottom: "Details",
                offset: offset,
              ),
              new Column(
                children: <Widget>[
                  new ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('Name'),
                    subtitle: const Text('Kimi no nawa'),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('Date'),
                    subtitle: const Text('06-03-2021'),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(
                      Icons.confirmation_number,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('ID Certificate'),
                    subtitle: const Text('123456789'),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(
                      Icons.local_hospital,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('Hospital'),
                    subtitle: const Text('RS Pondok Indah'),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(
                      Icons.note_add,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('Test'),
                    subtitle: const Text('PCR'),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  new ListTile(
                    leading: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('Result'),
                    subtitle: const Text('NEGATIVE'),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return cert_made();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 120),
                ],
              ),
            ]),
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
}
