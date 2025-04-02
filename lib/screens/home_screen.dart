import 'package:dansal_app/constent_values/const_colors.dart';
import 'package:dansal_app/screens/event_add_screeen.dart';
import 'package:dansal_app/screens/login_screen.dart';
import 'package:dansal_app/screens/user_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainThemeColor),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 254, 140, 69),

        child: ListView(
          children: [
            SizedBox(height: 200),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.white),
              title: Text(
                "All Event Categories",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.login, size: 30, color: Colors.white),
                title: Text(
                  "Log in",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.info_outline, size: 30, color: Colors.white),
              title: Text(
                "About",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          // to Show the map
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(7.8731, 80.7718),
              initialZoom: 8,
              interactionOptions: InteractionOptions(),
            ),
            children: [openStreetMap],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 10),
                    child: FloatingActionButton(
                      backgroundColor: mainThemeColor,
                      child: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventAddScreeen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

TileLayer get openStreetMap => TileLayer(
  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);
