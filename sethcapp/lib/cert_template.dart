import 'package:sethcapp/cert_made.dart';
import 'package:sethcapp/constant.dart';
import 'package:sethcapp/widgets/my_header.dart';
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
    );
  }
}
