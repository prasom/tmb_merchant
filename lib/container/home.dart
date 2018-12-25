import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tmb_merchant/src/blocs/application_state_provider.dart';
import 'package:tmb_merchant/src/blocs/state_mgmt_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [];

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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<Directory> _tempDirectory;
  Future<Directory> _appDocumentsDirectory;
  Future<Directory> _externalDocumentsDirectory;

  void _requestTempDirectory() {
    setState(() {
      _tempDirectory = getTemporaryDirectory();
    });
  }

  Widget _buildDirectory(
      BuildContext context, AsyncSnapshot<Directory> snapshot) {
    Text text = const Text('');
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = new Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        text = new Text('path: ${snapshot.data.path}');
      } else {
        text = const Text('path unavailable');
      }
    }
    return new Padding(padding: const EdgeInsets.all(16.0), child: text);
  }

  void _requestAppDocumentsDirectory() {
    setState(() {
      _appDocumentsDirectory = getApplicationDocumentsDirectory();
    });
  }

  void _requestExternalStorageDirectory() {
    setState(() {
      _externalDocumentsDirectory = getExternalStorageDirectory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ApplicationStateProvider.of(context);
    return new ConstrainedBox(
      constraints: new BoxConstraints.expand(),
      child: Column(children: <Widget>[
        Container(
          child: new AppBar(
            backgroundColor: Color(getColorHexFromStr('#0569a8')),
            elevation: 0,
            leading: null,
            title: new Text("HOME"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // _shareImage();
                  final RenderBox box = context.findRenderObject();
                  Share.share('ร้านค้าสุขใจ',
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
              )
            ],
          ),
        ),
        Container(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 80,
                        padding: EdgeInsets.all(10),
                        child: Image(
                          image: AssetImage('assets/blue_logo.png'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildUsernameText(bloc),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Comp Code : 12345',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width - 40,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Color(getColorHexFromStr('#0569a8'))),
                  borderRadius: BorderRadius.circular(15),
                  // image: new DecorationImage(
                  //     image: new NetworkImage(
                  //         'https://i.ibb.co/GFtPFpH/qr-home.png'),
                  //     fit: BoxFit.cover)
                ),
                child: FadeInImage.memoryNetwork(
                  image: 'https://i.ibb.co/GFtPFpH/qr-home.png',
                  placeholder: kTransparentImage,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget buildUsernameText(StateMgmtBloc bloc) {
    return StreamBuilder(
      stream: bloc.usernameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(
          'ร้าน ${snapshot.data}',
          style: TextStyle(color: Colors.black),
        );
      },
    );
  }

  _shareImage() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/qr_home.png');
      final Uint8List list = bytes.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(list);

      final channel = const MethodChannel('channel:me.albie.share/share');
      channel.invokeMethod('shareFile', 'image.jpg');
    } catch (e) {
      print('Share error: $e');
    }
  }
}
