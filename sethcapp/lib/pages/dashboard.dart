import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sethcapp/domain/user.dart';
import 'package:sethcapp/pages/place.dart';
import 'package:sethcapp/pages/fab_bottom_app_bar.dart';
import 'package:sethcapp/pages/fab_with_icons.dart';
import 'package:sethcapp/pages/layout.dart';
import 'package:sethcapp/providers/user_provider.dart';
import 'package:sethcapp/constant.dart';
import 'package:sethcapp/qr_code.dart';
import 'package:sethcapp/info_screen.dart';
import 'package:sethcapp/history_pass.dart';
import 'package:sethcapp/info_rs.dart';
import 'package:sethcapp/cert_made.dart';
import 'package:sethcapp/widgets/my_header.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sethcapp/widgets/counter.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Battle COVID-19",
              textBottom: "with SETH.",
              offset: offset,
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 20),
            //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            //   height: 60,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(25),
            //     border: Border.all(
            //       color: Color(0xFFE5E5E5),
            //     ),
            //   ),
            //   // child: Row(
            //   //   children: <Widget>[
            //   //     SvgPicture.asset("assets/icons/maps-and-flags.svg"),
            //   //     SizedBox(width: 20),
            //   //     Expanded(
            //   //       child: DropdownButton(
            //   //         isExpanded: true,
            //   //         underline: SizedBox(),
            //   //         icon: SvgPicture.asset("assets/icons/dropdown.svg"),
            //   //         value: "Jakarta",
            //   //         items: [
            //   //           'Jakarta',
            //   //           'Yogyakarta',
            //   //           'DKI Jakarta',
            //   //           'Banten',
            //   //           'Listprovinsi'
            //   //         ].map<DropdownMenuItem<String>>((String value) {
            //   //           return DropdownMenuItem<String>(
            //   //             value: value,
            //   //             child: Text(value),
            //   //           );
            //   //         }).toList(),
            //   //         onChanged: (value) {},
            //   //       ),
            //   //     ),
            //   //   ],
            //   // ),
            // ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Case update\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: "Last Update 7 Maret",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new qr_code()));
                        },
                        child: new Text("See details"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: kInfectedColor,
                          number: 1046,
                          title: "Infected",
                        ),
                        Counter(
                          color: kDeathColor,
                          number: 87,
                          title: "Deaths",
                        ),
                        Counter(
                          color: kRecovercolor,
                          number: 46,
                          title: "Recovered",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Where do you want to go?\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text:
                                  "Check certificate info at your destination!",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new Place()));
                        },
                        child: new Text("Search"),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(20),
                    height: 178,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/map.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'My Info',
        color: Colors.grey,
        selectedColor: Colors.red,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.layers, text: 'Certificate'),
          FABBottomAppBarItem(iconData: Icons.settings_overscan, text: 'Scan'),
          FABBottomAppBarItem(iconData: Icons.logout, text: 'Logout'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab1(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildFab1(BuildContext context) {
    final icons = [
      Icons.place,
      Icons.article,
      Icons.local_hospital,
      Icons.history
    ];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Info',
        child: Icon(Icons.info),
        elevation: 2.0,
      ),
    );
  }

  var date = DateTime.now();
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
}
