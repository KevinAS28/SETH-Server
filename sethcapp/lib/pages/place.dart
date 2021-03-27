import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:sethcapp/constant.dart';
import 'package:sethcapp/domain/user.dart';
import 'package:sethcapp/pages/fab_with_icons.dart';
import 'package:sethcapp/pages/layout.dart';
import 'package:sethcapp/pages/login.dart';
import 'package:sethcapp/providers/user_provider.dart';
import 'package:sethcapp/util/app_url.dart';
import 'package:sethcapp/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sethcapp/user_model.dart';
import 'package:sethcapp/qr_code.dart';
import 'package:sethcapp/info_screen.dart';
import 'package:sethcapp/history_pass.dart';
import 'package:sethcapp/info_rs.dart';
import 'package:sethcapp/cert_made.dart';
import 'package:sethcapp/pages/dashboard.dart';
import 'package:sethcapp/util/api.dart';

import 'fab_bottom_app_bar.dart';
import 'navigate.dart';

class PlaceItem0 {
  String name;
  String placeId;
  List<String> certificates;
  PlaceItem0({this.name, this.placeId, this.certificates});
}

class Place extends StatefulWidget {
  var data;

  Place({this.data});

  @override
  _PlaceState createState() => _PlaceState(this.data);
}

class _PlaceState extends State<Place> {
  List<List<String>> data = [];
  // _PlaceState({this.data});
  _PlaceState(var data) {
    this.data = data;
  }

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

  Future<List<String>> getData(filter, context) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    Map<String, dynamic> data = {"place": filter};
    Map<String, dynamic> response =
        await hitApiUs(user, AppUrl.placeInput, data);
    List<String> names = [];
    if (response["status"] == "OK") {
      for (var pred in response["predictions"]) {
        names.add(pred["description"]);
      }
    }
    return names;
  }

  Future<List<List<List<String>>>> getPlaceDetail(filter, context) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    Map<String, dynamic> data = {"place": filter};
    Map<String, dynamic> response =
        await hitApiUs(user, AppUrl.findPlacesModel, data);

    if (response["success"] == true) {
      List<List<String>> requiredCerts = [];
      List<List<String>> notRequiredCerts = [];
      for (var rc in response["require_certs"]) {
        for (var pl in rc.keys) {
          requiredCerts.add([pl, rc[pl].join(" / ")]);
        }
      }

      for (var rc in response["not_required_certs"]) {
        notRequiredCerts.add([rc, "No Certificate Needed"]);
      }
      print('OK');
      return [requiredCerts, notRequiredCerts];
    } else {
      print('Not OK');
    }
  }

  Widget _customDropDownExample(
      BuildContext context, String item, String itemDesignation
      ) {
    print(" _customDropDownExample");
    return Container(
        child: ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(),
      title: Text((item == null ? "Place undefined" : item)),
      onTap: () => print("Cliecked 1"),
    ));
  }

  // Widget _customPopupItemBuilderExample2(
  //     BuildContext context, String item, bool isSelected) {
  //       print(" _customPopupItemBuilderExample2");
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 8),
  //     decoration:
  //          BoxDecoration(
  //             border: Border.all(color: Theme.of(context).primaryColor),
  //             borderRadius: BorderRadius.circular(5),
  //             color: Colors.white,
  //           ),
  //     child: ListTile(
  //       selected: isSelected,
  //       title: Text(item),
  //       onTap: () => {},
  //     ),
  //   );
  // }

  Widget _customPopupItemBuilderExample(
      BuildContext context, String item, bool isSelected) {
    print("_customPopupItemBuilderExample");
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
          List<List<List<String>>> result = await getPlaceDetail(item, context);
          // print(result);
          var allPlaces = result[0] + result[1];
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Place(
                      data: allPlaces,
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
    ];

    if (this.data != null) {
      listItems.add(Text("Result", style: kTitleTextstyle));
      print('Length: ${this.data.length}');

      for (List<String> p in this.data) {
        listItems.add(GestureDetector(
            child: PreventCard(
              text: p[1],
              image: "assets/images/place.png",
              title: p[0],
            ),
            onTap: () => navigateTo(7.7714, 110.3775)));
        listItems.add(SizedBox(height: 20));
      }
    } else {
      listItems.add(Text("Recommendations", style: kTitleTextstyle));
      print('Length: 0');
      var text = [
        'PCR',
        'Rapid',
        'Genose',
        'PCR',
        'Rapid',
        'Genose',
        'PCR',
        'Rapid',
        'Genose',
        'PCR',
        'Rapid',
        'Genose',
      ];

      var title = [
        'Pondok Indah Mall',
        'Rempah Asia',
        'Soekarno Hatta Airport',
        'Mall Grand Indonesia',
        'PCR4',
        'PCR5',
        'PCR6',
        'PCR',
        'PCR',
        'PCR'
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

    return SafeArea(child: Scaffold(
      floatingActionButtonLocation: (this.data!=null)?FloatingActionButtonLocation.centerDocked:null,
      floatingActionButton: (this.data!=null)?_buildFab1(context):null,
      body: (
          SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Place",
              textBottom: "Information",
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
                      label: 'Find a place to go',
                      dropdownSearchDecoration: InputDecoration(
                        filled: false,
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      onFind: (String filter) {
                        print("Filter2: $filter");
                        return getData(filter, context);
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
                          color: kPrimaryColor,
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
