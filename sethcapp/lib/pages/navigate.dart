import 'package:url_launcher/url_launcher.dart';

/*

THE PROJECT IS NOT DONE YET, SO IT'S ONLY PROTOTYPE

*/

void navigateTo(double lat, double lng) async {
  var uri = Uri.parse("https://www.google.com/maps?cid=15546286145103784455");
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    throw 'Could not launch ${uri.toString()}';
  }
}

void navigateToBHC() async {
  var uri = Uri.parse("https://www.google.com/maps?cid=14064355031271158402");
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    throw 'Could not launch ${uri.toString()}';
  }
}

void navigateToGambir() async {
  var uri = Uri.parse("https://www.google.com/maps?cid=3754899700886139786");
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    throw 'Could not launch ${uri.toString()}';
  }
}
