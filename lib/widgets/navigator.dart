import 'package:daraz_app/screens/settings.dart';
import 'package:daraz_app/screens/home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Widget> _children = [
    HomePage(),
    SettingsPage(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          color: Colors.black,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Color(0xFFEB5757),
          height: 50,
          animationCurve: Curves.bounceInOut,
          animationDuration: Duration(milliseconds: 200),
          index: 0,
          items: [
            Icon(Icons.home, size: 20, color: Colors.white),
            Icon(Icons.settings, size: 20, color: Colors.white),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}
