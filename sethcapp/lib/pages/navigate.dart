import 'package:url_launcher/url_launcher.dart';
void navigateTo(double lat, double lng) async {
   var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
   if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
   } else {
      throw 'Could not launch ${uri.toString()}';
   }
}