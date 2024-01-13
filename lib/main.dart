import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wastewisee/Driver/Pages/home.dart';
import 'package:wastewisee/Driver/Pages/intro.dart';
import 'package:wastewisee/Driver/Pages/profile.dart';
import 'package:wastewisee/Driver/Pages/route.dart';
import 'package:wastewisee/Driver/Pages/status.dart';
import 'package:wastewisee/Driver/Pages/settings.dart';
import 'package:wastewisee/api/firebase_api.dart';
import 'package:wastewisee/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: IntroPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  String name = '';
  String email = '';
  String _driverProfileImageUrl = '';

  final List<Widget> _pages = [
    HomeScreen(),
    MapPage(),
    CollectionStatusPage(),
    SettingsPage(),
  ];

// Function to fetch driver information from Firestore
  Future<void> _fetchDriverInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot driverSnapshot =
        await FirebaseFirestore.instance.collection('Driver').doc(user.uid).get();

        if (driverSnapshot.exists) {
          setState(() {
            name = driverSnapshot['name'] ?? '';
            email = user.email ?? '';
            _driverProfileImageUrl = driverSnapshot['profileImageUrl'] ?? '';
          });

          print('Name: $name');
          print('Email: $email');
          print('Profile Image URL: $_driverProfileImageUrl');
        } else {
          print("User document does not exist in Firestore.");
        }
      } catch (e) {
        print("Error fetching driver info: $e");
      }
    }
  }

  void initState() {
    super.initState();
    _fetchDriverInfo();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroPage()),
      );
    } catch (e) {
      print("Error while signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/wastewise.png', height: 45),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: (_driverProfileImageUrl.isNotEmpty
                              ? NetworkImage(_driverProfileImageUrl)
                              : AssetImage('assets/profile_image.jpg')) as ImageProvider<Object>?,
                        ),
                        SizedBox(height: 10),
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Driver Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DriverProfilePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Help Center'),
                    onTap: () {
                      // Add your help center logic here
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About Us'),
                    onTap: () {
                      // Add your about us logic here
                    },
                  ),
                ],
              ),
            ),
            Divider(), // Add a divider for visual separation
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Call the sign-out function when the logout button is tapped
                _signOut();
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Route',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl),
            label: 'Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
    );
  }
}
