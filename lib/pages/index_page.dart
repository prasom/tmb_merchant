import 'package:flutter/material.dart';
import 'package:tmb_merchant/pages/home_page.dart';
import 'package:tmb_merchant/pages/qr_generate_page.dart';
import 'package:tmb_merchant/pages/setting_page.dart';
import 'package:tmb_merchant/my_flutter_app_icons.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    new HomePage(),
    new QrGeneratePage(),
    new SettingPage()
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('HOME'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.qr_code),
            title: new Text('CREATE QR'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu), title: Text('SETTING'))
        ],
      ),
    );
  }
}
