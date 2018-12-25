import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(getColorHexFromStr('#0569a8')),
          title: Text('SETTINGS'),
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this would produce 2 rows.
          crossAxisCount: 2,
          // Generate 100 Widgets that display their index in the List
          children: <Widget>[
            Center(
                child: GridTile(
              child: new Card(
                  color: Colors.blue.shade200,
                  child: new Center(
                    child: new Text('PIN'),
                  )),
            )),
             Center(
                child: GridTile(
              child: new Card(
                  color: Colors.blue.shade200,
                  child: new Center(
                    child: new Text('FACE ID'),
                  )),
            )),
             Center(
                child: GridTile(
              child: new Card(
                  color: Colors.blue.shade200,
                  child: new Center(
                    child: new Text('Logout'),
                  )),
            ))
          ],
        ),
      ),
    );
  }
}
