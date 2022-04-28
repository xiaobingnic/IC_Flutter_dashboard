import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'main.screen.dart';
import 'manualDoc.dart';
import 'blue.dart';
import 'wifi.dart';

class MakeDashboardItems extends StatefulWidget {
  const MakeDashboardItems({Key? key}) : super(key: key);

  @override
  _MakeDashboardItemsState createState() => _MakeDashboardItemsState();
}

class _MakeDashboardItemsState extends State<MakeDashboardItems> {
  Card makeDashboardItem(String title, String img, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFF00728f),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFF01aaeb),
              ),
        child: InkWell(
          onTap: () {
            print(index);
            if (index == 0) {
              //1.bluetooth
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => FlutterBlueApp(),
              ));
            }
            if (index == 1) {
              //2.Wifi
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => FlutterWifiIoT(),
              ));
            }
            if (index == 2) {
              //3.config
              // Navigator.of(context).push(_createRoute());
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => InAppWebViewMainScreen(),
              ));
            }
            if (index == 3) {
              //4.manual
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => ManualDocPage(),
              ));
            }
            if (index == 4) {
              //5.account
            }
            if (index == 5) {
              //6.Pin
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Icon(
                  MdiIcons.fromString(img),
                  color: Colors.white,
                  size: 100.0,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //Color.fromARGB(255, 170, 193, 232),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(2),
              children: [
                makeDashboardItem("Bluetooth connect", 'bluetooth-audio', 0),
                makeDashboardItem("Wifi", 'wifi', 1),
                makeDashboardItem("Config", 'traffic-light', 2),
                makeDashboardItem("Manual", 'file-document', 3),
                makeDashboardItem("Account", 'account-arrow-left-outline', 4),
                makeDashboardItem("Pin Test", "database-check", 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Route _createRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) =>
//         InAppWebViewMainScreen(),
// transitionsBuilder: (context, animation, secondaryAnimation, child) {
//   const begin = Offset(0.0, 1.0);
//   const end = Offset.zero;
//   const curve = Curves.ease;

//   var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//   return SlideTransition(
//     position: animation.drive(tween),
//     child: child,
//   );
// },
//   );
// }
