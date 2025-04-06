import 'package:dansal_app/constent_values/const_colors.dart';
import 'package:dansal_app/providers/auth_provider.dart';
import 'package:dansal_app/widgets/add_event_bottom_sheet.dart';
import 'package:dansal_app/widgets/login_bottom_sheet.dart';
import 'package:dansal_app/widgets/register_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _username = 'Guest';
  String _email = '';
  bool _isAuthenticated = false;

  // Colors for event types
  final Map<String, Color> eventTypeColors = {
    "දන්සල්": Colors.orange, // Dansal - Orange
    "තොරණ": Colors.blue, // Thorana - Blue
    "පහන් කූඩු": Colors.green, // Pahan Kudu - Green
    "වෙනත්": Colors.purple, // Other - Purple
  };

  @override
  void initState() {
    super.initState();
    _checkAuthAndFetchUserInfo();
  }

  Future<void> _checkAuthAndFetchUserInfo() async {
    try {
      // Check if user is authenticated first
      final isAuth = await ref.read(authServiceProvider).isAuthenticated();

      if (isAuth) {
        // If authenticated, fetch user info
        final user = await ref.read(authServiceProvider).getCurrentUser();
        if (user != null && mounted) {
          setState(() {
            _username = user.username;
            _email = user.email;
            _isAuthenticated = true;
          });
          print('User info fetched: ${user.username}, ${user.email}');
        }
      } else {
        setState(() {
          _isAuthenticated = false;
          _username = 'Guest';
          _email = '';
        });
        print('Not authenticated, viewing as guest');
      }
    } catch (e) {
      print('Error checking auth/fetching user info: $e');
    }
  }

  Future<void> _logout() async {
    try {
      final success = await ref.read(authNotifierProvider.notifier).logout();
      if (success && mounted) {
        setState(() {
          _isAuthenticated = false;
          _username = 'Guest';
          _email = '';
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logged out successfully')));

        // Don't navigate away from home screen, just update UI
        Navigator.pop(context); // Close drawer
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed, please try again')),
        );
      }
    } catch (e) {
      print('Logout error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _showLoginBottomSheet() {
    // Close the drawer if it's open
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // Show login bottom sheet
    LoginBottomSheet.show(context, onSuccess: _checkAuthAndFetchUserInfo);
  }

  void _showRegisterBottomSheet() {
    // Close the drawer if it's open
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // Show register bottom sheet
    RegisterBottomSheet.show(context, onSuccess: _checkAuthAndFetchUserInfo);
  }

  Future<void> _handleAddEvent() async {
    // Check if user is authenticated
    final isAuth = await ref.read(authServiceProvider).isAuthenticated();

    if (isAuth) {
      // User is authenticated, show add event bottom sheet
      AddEventBottomSheet.show(context);
    } else {
      // User is not authenticated, directly show login bottom sheet
      LoginBottomSheet.show(
        context,
        onSuccess: () {
          // After successful login, show add event bottom sheet
          _checkAuthAndFetchUserInfo();
          AddEventBottomSheet.show(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 254, 140, 69),
        child: ListView(
          children: [
            // Different drawer header based on authentication status
            if (_isAuthenticated)
              // Authenticated user header
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: mainThemeColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: mainThemeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                accountName: Text(
                  _username,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  _email.isNotEmpty ? _email : 'Welcome back!',
                  style: TextStyle(color: Colors.white),
                ),
                otherAccountsPictures: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    child: Icon(Icons.verified_user, color: Colors.green),
                  ),
                ],
              )
            else
              // Guest user header
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: mainThemeColor.withOpacity(0.85),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: Icon(
                    Icons.person_outline,
                    size: 40,
                    color: mainThemeColor,
                  ),
                ),
                accountName: Text(
                  'Guest User',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  'Sign in to add events and more',
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                ),
              ),

            // Authenticated users section
            if (_isAuthenticated) ...[
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text(
                  "My Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile page when available
                },
              ),
              ListTile(
                leading: Icon(Icons.event_note, color: Colors.white),
                title: Text(
                  "My Events",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to my events page when available
                },
              ),
              Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
            ],

            // Common items for both authenticated and guest users
            SizedBox(height: _isAuthenticated ? 0 : 20),
            // ListTile(
            //   leading: Icon(Icons.location_on, color: Colors.white),
            //   title: Text(
            //     "All Event Categories",
            //     style: TextStyle(
            //       fontWeight: FontWeight.w600,
            //       color: Colors.white,
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Add navigation to categories page when available
            //   },
            // ),
            // SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.info_outline, size: 30, color: Colors.white),
              title: Text(
                "About",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to about page when available
              },
            ),

            // Login/Logout option
            Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
            SizedBox(height: 10),
            if (_isAuthenticated)
              ListTile(
                leading: Icon(Icons.logout, size: 30, color: Colors.white),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                onTap: _logout,
              )
            else
              ListTile(
                leading: Icon(Icons.login, size: 30, color: Colors.white),
                title: Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
                onTap: _showLoginBottomSheet,
              ),

            // if (!_isAuthenticated)
            //   ListTile(
            //     leading: Icon(
            //       Icons.app_registration,
            //       size: 30,
            //       color: Colors.white,
            //     ),
            //     title: Text(
            //       "Register",
            //       style: TextStyle(
            //         fontWeight: FontWeight.w600,
            //         color: Colors.white,
            //       ),
            //     ),
            //     trailing: Icon(
            //       Icons.arrow_forward_ios,
            //       color: Colors.white,
            //       size: 16,
            //     ),
            //     onTap: _showRegisterBottomSheet,
            //   ),
          ],
        ),
      ),

      body: Builder(
        builder:
            (context) => Stack(
              children: [
                // to Show the map
                FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(7.8731, 80.7718),
                    initialZoom: 8,
                    interactionOptions: InteractionOptions(),
                  ),
                  children: [
                    openStreetMap,
                    MarkerLayer(
                      markers: [
                        // Example marker
                        Marker(
                          point: LatLng(7.8731, 80.7718),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_on,
                            color: eventTypeColors["දන්සල්"],
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Hamburger menu in top left corner
                Positioned(
                  top: 40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.menu, color: mainThemeColor, size: 26),
                    ),
                  ),
                ),

                // Event type color references in top right corner
                Positioned(
                  top: 40,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children:
                          eventTypeColors.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: entry.value,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: blackFontColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),

                // Add Event Button (existing)
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: FloatingActionButton(
                    backgroundColor: mainThemeColor,
                    child: Icon(Icons.add, color: Colors.white),
                    onPressed: _handleAddEvent,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

TileLayer get openStreetMap => TileLayer(
  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);
