import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sethcapp/constant.dart';
import 'package:sethcapp/pages/fab_bottom_app_bar.dart';
import 'package:sethcapp/pages/fab_with_icons.dart';
import 'package:sethcapp/pages/layout.dart';
import 'package:sethcapp/pages/login.dart';
import 'package:sethcapp/pages/navigate.dart';
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

class info_rs extends StatefulWidget {
  var data;

  info_rs({this.data = null});

  @override
  _info_rsState createState() => _info_rsState(data);
}

class _info_rsState extends State<info_rs> {
  List<String> data;

  _info_rsState(data) {
    this.data = data;
  }

  _info_rsState.noArgs() {}

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
                  builder: (context) => Login(),
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
    if (name == '') {
      return <String>[];
    }
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
    SystemChrome.setEnabledSystemUIOverlays([]);
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
        title: Text((item == null) ? '' : item),
        subtitle: Text(
          'Genose/Rapid/PCR test available',
        ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, String item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item),
        onTap: () async {
          print('Clicked 2');
          List<String> result = await findAplaces(context, item);
          // print(result);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => info_rs(
                      data: result,
                    )),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var listItems = <Widget>[
      SizedBox(height: 20),
      Text((this.data != null) ? "Result" : "Recommendations",
          style: kTitleTextstyle),
    ];

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

    if (this.data != null) {
      for (var i = 0; i < this.data.length; i++) {
        listItems.add(GestureDetector(
            onTap: () => navigateToBHC(),
            child: PreventCard(
              text: text[i],
              image: "assets/images/place.png",
              title: this.data[i],
            )));

        listItems.add(SizedBox(height: 20));
      }
    } else {
      var title = [
        'Hospital Cilandak',
        'Hospital Fatmawati',
        'Puskesmas Pondok Indah',
        'RSUD Pasar Minggu',
        'Hospital Pondok Indah',
        'Hospital Fatmawati',
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

    return Container(
        child: Scaffold(
      floatingActionButtonLocation: (this.data != null)
          ? FloatingActionButtonLocation.centerDocked
          : null,
      floatingActionButton: (this.data != null) ? _buildFab1(context) : null,
      body: (SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Find",
              textBottom: "Health Centers",
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
                  Expanded(
                    child: DropdownSearch<String>(
                      searchBoxController: TextEditingController(text: ''),
                      mode: Mode.DIALOG,
                      isFilteredOnline: true,
                      showClearButton: true,
                      showSearchBox: true,
                      label: 'Find health centers',
                      dropdownSearchDecoration: InputDecoration(
                        filled: false,
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      onFind: (String filter) {
                        print("Filter2: $filter");
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
      )),
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
    ));
  }

  void _selectedFabb(int index) {
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
            onIconTapped: _selectedFabb,
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
