import 'dart:io';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_share/image_share.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatelessWidget {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  ///
  /// Prevents the use of the "back" button
  ///
  Future<bool> _onWillPopScope() async {
    return false;
  }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(getColorHexFromStr('#0569a8')),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text('HOME'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              try {
                final File imageUri = await _downloadFile(
                    'https://i.ibb.co/GFtPFpH/qr-home.png', 'merchant_qr');
                ImageShare.shareImage(filePath: imageUri.path);
              } catch (e) {}
            },
          )
        ],
      ),
      body: Container(
        child: Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 80,
                    padding: EdgeInsets.all(12),
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
                        // BoundText(widget.loginBloc.outCurrentUser),
                        Text('Demo',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Comp Code : 12345',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 16),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                border: Border.all(color: Color(getColorHexFromStr('#0569a8'))),
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
                child: FadeInImage.memoryNetwork(
                  image: 'https://i.ibb.co/GFtPFpH/qr-home.png',
                  placeholder: kTransparentImage,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        )),
      ),
    );
    // return WillPopScope(
    //   onWillPop: _onWillPopScope,
    //   child: SafeArea(
    //     top: false,
    //     bottom: false,
    //     child: Scaffold(
    //       appBar: AppBar(
    //         title: Text('Home Page'),
    //         leading: Container(),
    //         actions: <Widget>[
    //           LogOutButton(),
    //         ],
    //       ),
    //       body: Container(
    //         child: Column(
    //           children: <Widget>[

    //             ListTile(
    //               title: RaisedButton(
    //                 child: Text('Shopping'),
    //                 onPressed: () {
    //                   Navigator.of(context).push(
    //                     MaterialPageRoute(
    //                       builder: (BuildContext context) => ShoppingPage(),
    //                     ),
    //                   );
    //                 },
    //               ),
    //             ),
    //             ListTile(
    //               title: RaisedButton(
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     Text('Shopping Basket'),
    //                     SizedBox(
    //                       width: 16.0,
    //                     ),
    //                     ShoppingBasket(),
    //                     SizedBox(
    //                       width: 16.0,
    //                     ),
    //                     ShoppingBasketPrice(),
    //                   ],
    //                 ),
    //                 onPressed: () {
    //                   Navigator.of(context).pushNamed('/shoppingBasket');
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  static var httpClient = new HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
