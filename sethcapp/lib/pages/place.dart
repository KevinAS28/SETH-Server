import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:sethcapp/constant.dart';
import 'package:sethcapp/domain/user.dart';
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

class PlaceItem0{
  String name;
  String placeId;
  List<String> certificates;
  PlaceItem0({this.name, this.placeId, this.certificates});
  
}

class Place extends StatefulWidget {
  @override
  _PlaceState createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
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
    Map<String, dynamic> response = await hitApiUs(user, AppUrl.placeInput, data);
    List<String> names = [];
    if (response["status"]=="OK"){
      for (var pred in response["predictions"]){
        names.add(pred["description"]);

      }
    }
    return names;
  }

  Widget _customDropDownExample(
      BuildContext context, String item, String itemDesignation) {
    print(" _customDropDownExample");
    return Container(
      child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(),
              title: Text((item==null ? "Place undefined" : item) ),
            )
    );
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
      decoration:  BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item),
        onTap: () => {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var listItems = <Widget>[
      SizedBox(height: 20),
      Text("Result", style: kTitleTextstyle),
    ];
    var text = [
      'PCR',
      'Rapid',
      'Swab',
      'PCR',
      'Rapid',
      'Swab',
      'PCR',
      'Rapid',
      'Swab',
      'PCR',
      'Rapid',
      'Swab',
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

    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Info",
              textBottom: "Place",
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
                      label: 'Find a place to go',
                      dropdownSearchDecoration: InputDecoration(
                        filled: true,
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
