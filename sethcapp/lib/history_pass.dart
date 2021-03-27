import 'package:provider/provider.dart';
import 'package:sethcapp/cert_template.dart';
import 'package:sethcapp/constant.dart';
import 'package:sethcapp/pages/dashboard.dart';
import 'package:sethcapp/pages/fab_bottom_app_bar.dart';
import 'package:sethcapp/providers/user_provider.dart';
import 'package:sethcapp/util/api.dart';
import 'package:sethcapp/util/app_url.dart';
import 'package:sethcapp/widgets/my_header.dart';
import 'package:sethcapp/cert_made.dart';
import 'package:sethcapp/qr_code.dart';
import 'package:sethcapp/pages/place.dart';
import 'package:sethcapp/info_screen.dart';
import 'package:sethcapp/info_rs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'domain/user.dart';

class history_pass extends StatefulWidget {
  @override
  _history_passState createState() => _history_passState();
}

class _history_passState extends State<history_pass> {
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

  var data;

  Future<List<List<String>>> getHistory(context) async {
    print('getHistory() called');
    User user = Provider.of<UserProvider>(context, listen: false).user;
    Map<String, String> data = {"nik": user.nik};
    var response = await hitApiUs(user, AppUrl.historyA, data);
    List<List<String>> history = [];
    for (var i in response["history"]) {
      history.add([i[0], i[1], i[2], "assets/images/place.png"]);
    }
    return history;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
    getHistory(context).then((history) {
      setState(() {
        this.data = history;
      });
    });
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

  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {}

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    var listItems = <Widget>[
      SizedBox(height: 20),
      Text((this.data != null) ? "Result" : "Loading...",
          style: kTitleTextstyle),
    ];

    if (this.data != null) {
      for (List<String> hist in this.data) {
        listItems.add(PreventCard(
            text: hist[1], subtitle: hist[2], title: hist[0], image: hist[3]));
        listItems.add(SizedBox(height: 20));
      }
    } else {
      return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
              key: _keyLoader,
              backgroundColor: Colors.black54,
              children: <Widget>[
                Center(
                  child: Column(children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please Wait....",
                      style: TextStyle(color: Colors.blueAccent),
                    )
                  ]),
                )
              ]));
    }

    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Pass",
              textBottom: "History",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listItems),
              /*
                  Text(
                    "Jenis Sertifikat",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                   */
              /*
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SymptomCard(
                          image: "assets/images/headache.png",
                          title: "PCR",
                          isActive: true,
                        ),
                        SymptomCard(
                          image: "assets/images/caugh.png",
                          title: "Swab",
                        ),
                        SymptomCard(
                          image: "assets/images/fever.png",
                          title: "Rapid",
                        ),
                      ],
                    ),
                  ),
                  
                  PreventCard(
                    text: "Pass Date: 26-02-2020" +
                        "\n" +
                        "Test Type: PCR " +
                        "\n" +
                        "ID Certificate: 123456",
                    image: "assets/images/airport.png",
                    title: "Soekarno-Hatta",
                  ),
                  PreventCard(
                    text: "Pass Date: 26-02-2020" +
                        "\n" +
                        "Test Type: PCR " +
                        "\n" +
                        "ID Certificate: 123456",
                    image: "assets/images/food.png",
                    title: "Cilandak Town Square",
                  ),
                  SizedBox(height: 50),
                ],
              ),
            */
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
  // final String id;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
    this.subtitle,
    // this.id,
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
