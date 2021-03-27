import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import 'package:sethcapp/constant.dart';
import 'package:sethcapp/pages/fab_bottom_app_bar.dart';
import 'package:sethcapp/providers/user_provider.dart';
import 'package:sethcapp/util/api.dart';
import 'package:sethcapp/util/app_url.dart';
import 'package:sethcapp/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:sethcapp/pages/dashboard.dart';
import 'package:sethcapp/cert_made.dart';
import 'package:sethcapp/qr_code.dart';
import 'package:sethcapp/pages/place.dart';
import 'package:sethcapp/info_screen.dart';
import 'package:sethcapp/history_pass.dart';
import 'package:dio/dio.dart';
import 'package:sethcapp/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'domain/user.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
    MapUtils.openMap(-3.823216, -38.481700);
    ;
  }
}

class info_rs extends StatefulWidget {
  @override
  _info_rsState createState() => _info_rsState();
}

class _info_rsState extends State<info_rs> {
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

  final controller = ScrollController();
  double offset = 0;

  Future<List<String>> findAplaces(context, name) async {
    print('findAplaces() called');
    User user = Provider.of<UserProvider>(context, listen: false).user;
    Map<String, String> data = {"aplace_name": name};
    var response = await hitApiUs(user, AppUrl.findAplaces, data);
    List<dynamic> listItems0 = response["aplaces"];
    List<String> listItems = [];
    for (var i in listItems0) {
      listItems.add(i as String);
    }
    return listItems;
  }

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

  Widget _customDropDownExample(
      BuildContext context, String item, String itemDesignation) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(item),
        subtitle: Text(
          'Genose/Rapid/PCR test available',
        ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, String item, bool isSelected) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(item),
        subtitle: Text(
          'Genose/Rapid/PCR test available',
        ),
      ),
    );
  }

  Center LayoutRS(List<Map> RSData, Function detailRS) {
    return new Center(
        child: ListView.builder(
      itemCount: RSData.length,
      itemBuilder: (context, pos) {
        return Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: new GestureDetector(
                    child: Text(
                      "RS Cilandak" +
                          RSData[pos]["Tests available: "] +
                          "PCR / Rapid / Swab",
                      style: TextStyle(
                        fontSize: 18.0,
                        height: 1.6,
                      ),
                    ),
                    onTap: () => {detailRS(RSData[pos])}),
              ),
            ));
      },
    ));
  }

  var data;

  @override
  Widget build(BuildContext context) {
    var listItems = <Widget>[
      SizedBox(height: 20),
      Text((this.data != null) ? "Result" : "Recommendations",
          style: kTitleTextstyle),
    ];

    if (this.data != null) {
      for (var i = 0; i < 10; i++) {
        listItems.add(PreventCard(
          text: this.data[i],
          image: "assets/images/place.png",
          title: this.data[i],
        ));
        listItems.add(SizedBox(height: 20));
      }
    } else {
      var text = [
        'Genose/Rapid/PCR test available',
        'Genose test available',
        'PCR/Swab test available',
        'Genose/Rapid/PCR test available',
        'Genose test available',
        'PCR/Swab test available',
        'Genose/Rapid/PCR test available',
        'Genose test available',
        'PCR/Swab test available',
        'PCR/Swab test available'
      ];

      var title = [
        'RS Cilandak',
        'RS Fatmawati',
        'Puskesmas Pondok Indah',
        'RSUD Pasar Minggu',
        'RS Pondok Indah',
        'RS Fatmawati',
        'Puskesmas Pondok Indah',
        'RSUD Pasar Minggu',
        'Puskesmas Pondok Indah',
        'RSUD Pasar Minggu',
      ];
      for (var i = 0; i < 10; i++) {
        listItems.add(PreventCard(
          text: text[i],
          image: "assets/images/place.png",
          title: title[i],
        ));
        listItems.add(SizedBox(height: 20));
      }
    }
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Health Centers",
              textBottom: "Informations",
              offset: offset,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownSearch<String>(
                      searchBoxController: TextEditingController(text: ''),
                      mode: Mode.BOTTOM_SHEET,
                      isFilteredOnline: true,
                      showClearButton: true,
                      showSearchBox: true,
                      label: 'Find health centers',
                      dropdownSearchDecoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      onFind: (String filter) {
                        return findAplaces(context, filter);
                      },
                      onChanged: (var data) {
                        print(data);
                      },
                      dropdownBuilder: _customDropDownExample,
                      popupItemBuilder: _customPopupItemBuilderExample,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listItems),
            ),
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
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 85,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 80,
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
              left: 70,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                height: 80,
                width: MediaQuery.of(context).size.width - 100,
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
                          fontSize: 12,
                          color: kRecovercolor,
                          fontWeight: FontWeight.w600,
                        ),
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

class MapsCard extends StatelessWidget {
  final String image;
  const MapsCard({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 320,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 300,
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
              left: 50,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 90,
                width: MediaQuery.of(context).size.width - 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
