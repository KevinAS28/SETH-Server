import 'package:sethcapp/cert_template.dart';
import 'package:sethcapp/constant.dart';
import 'package:sethcapp/pages/dashboard.dart';
import 'package:sethcapp/pages/fab_bottom_app_bar.dart';
import 'package:sethcapp/widgets/my_header.dart';
import 'package:sethcapp/qr_code.dart';
import 'package:sethcapp/pages/place.dart';
import 'package:sethcapp/info_screen.dart';
import 'package:sethcapp/info_rs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sethcapp/history_pass.dart';

class cert_made extends StatefulWidget {
  @override
  _cert_madeState createState() => _cert_madeState();
}

class _cert_madeState extends State<cert_made> {
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
    } else if (index==3) {
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
    var listItems = <Widget>[
      SizedBox(height: 20),
      Text("Result", style: kTitleTextstyle),
    ];
    var text = [
      'Test Result : NEGATIVE',
      'Test Result : NEGATIVE',
      'Test Result : NEGATIVE',
      'Test Result : NEGATIVE',
      'Test Result : NEGATIVE',
      'Test Result : NEGATIVE',
      'Test Result : NEGATIVE',
      'Test Result : NEGATIVE',
      'Test Result : NEGATIVE',
      'Test Result : NEGATIVE',
    ];

    var title = [
      'Swab',
      'Rapid',
      'PCR',
      'PCR1',
      'PCR4',
      'PCR5',
      'PCR6',
      'PCR',
      'PCR',
      'PCR'
    ];

    var subtitle = [
      'Date Made: 26-02-2020',
      'Date Made: 26-02-2020',
      'Date Made: 26-02-2020',
      'Date Made: 26-02-2020',
      'Date Made: 26-02-2020',
      'Date Made: 26-02-2020',
      'Date Made: 26-02-2020',
      'Date Made: 26-02-2020',
      'Date Made: 26-02-2020',
      'Date Made: 26-02-2020',
    ];

    var image = [
      "assets/images/swab.png",
      "assets/images/Rapid.png",
      "assets/images/swab.png",
      "assets/images/Rapid.png",
      "assets/images/swab.png",
      "assets/images/Rapid.png",
      "assets/images/swab.png",
      "assets/images/Rapid.png",
      "assets/images/swab.png",
      "assets/images/Rapid.png",
    ];

    var id = [
      'ID Certificate : 12345678',
      'ID Certificate : 23456781',
      'ID Certificate : 12567852',
      'ID Certificate : 12756782',
      'ID Certificate : 12223678',
      'ID Certificate : 23645678',
      'ID Certificate : 62354978',
      'ID Certificate : 78232948',
      'ID Certificate : 47432978',
      'ID Certificate : 63685678',
    ];

    for (var i = 0; i < 10; i++) {
      listItems.add(PreventCard(
        text: text[i],
        subtitle: subtitle[i],
        image: image[i],
        title: title[i],
        id: id[i],
      ));
      listItems.add(SizedBox(height: 20));
    }
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Certificate",
              textBottom: "Made",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listItems),
            )
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
}

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  final String subtitle;
  final String id;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
    this.subtitle,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 140,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image),
            Positioned(
              left: 115,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                height: 130,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: kTitleTextstyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        subtitle,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        id,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return cert_template();
                            },
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset("assets/icons/forward.svg"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
