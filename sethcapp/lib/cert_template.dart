import 'package:covid_19/cert_made.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/main.dart';
import 'package:covid_19/makecert3.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter/material.dart';

class cert_template extends StatefulWidget {
  cert_template({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _cert_templateState createState() => _cert_templateState();
}

class _cert_templateState extends State<cert_template> {
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
      body:
      SingleChildScrollView(
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
                    leading: const Icon(Icons.person, color: Colors.blueAccent,),
                    title: const Text('Name'),
                    subtitle: const Text('Kimi no nawa'),
                    trailing: const Icon(Icons.check_circle, color: Colors.green,),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.blueAccent,),
                    title: const Text('Date'),
                    subtitle: const Text('06-03-2021'),
                    trailing: const Icon(Icons.check_circle, color: Colors.green,),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.confirmation_number, color: Colors.blueAccent,),
                    title: const Text('ID Certificate'),
                    subtitle: const Text('123456789'),
                    trailing: const Icon(Icons.check_circle, color: Colors.green,),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.local_hospital, color: Colors.blueAccent,),
                    title: const Text('Hospital'),
                    subtitle: const Text('RS Pondok Indah'),
                    trailing: const Icon(Icons.check_circle, color: Colors.green,),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.note_add, color: Colors.blueAccent,),
                    title: const Text('Test'),
                    subtitle: const Text('PCR'),
                    trailing: const Icon(Icons.check_circle, color: Colors.green,),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.check_circle_outline, color: Colors.blueAccent,),
                    title: const Text('Result'),
                    subtitle: const Text('NEGATIVE'),
                    trailing: const Icon(Icons.check_circle, color: Colors.green,),
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
                    child:
                    Text(
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


/*
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text("Result", style: kTitleTextstyle),
                  PreventCard(
                    text:
                    "PCR / Rapid / Swab tests available" + "\n" + "1.8 kilometers from you",
                    image: "assets/images/place.png",
                    title: "RS Cilandak",
                  ),
                  SizedBox(height: 20),
                  Text("Recommended hospitals", style: kTitleTextstyle),
                  PreventCard(
                    text:
                    "PCR / Rapid / Swab tests available" + "\n" + "1.8 kilometers from you",
                    image: "assets/images/place.png",
                    title: "RS Fatmawati",
                  ),
                  PreventCard(
                    text:
                    "PCR " + "/ Swab tests available" + "\n" + "1.8 kilometers from you",
                    image: "assets/images/place.png",
                    title: "Puskesmas Pondok Indah",
                  ),
                  PreventCard(
                    text:
                    "PCR test available" + "\n" + "1.8 kilometers from you",
                    image: "assets/images/place.png",
                    title: "RSUD Pasar Minggu",
                  ),
                  Text("Maps View", style: kTitleTextstyle),
                  SizedBox(height: 20),
                  MapsCard(
                    image: "",
                  ),
                  SizedBox(height: 80),
                ],
              ),
            )
          ],
        ),
      ),

       */
    );
  }
}

/*
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
        height: 120,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 100,
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
                height: 110,
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
                          color: kBodyTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return make_cert_2();
                              },
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset("assets/icons/forward.svg"),
                        )
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
 */

/*
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
 */