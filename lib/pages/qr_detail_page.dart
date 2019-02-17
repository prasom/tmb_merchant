import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_share/image_share.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/bloc_widgets/bloc_state_builder.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_bloc.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_state.dart';
import 'package:tmb_merchant/models/qr_model.dart';
import 'package:tmb_merchant/widgets/pending_action_no_bg.dart';
import 'package:tmb_merchant/widgets/qr_detail_share.dart';
import 'package:tmb_merchant/widgets/qr_image_view.dart';
import 'package:transparent_image/transparent_image.dart';

class QrDetail extends StatefulWidget {
  @override
  _QrDetailState createState() => _QrDetailState();
}

class _QrDetailState extends State<QrDetail> {
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

  final formatter = new NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    QrBloc bloc = BlocProvider.of<QrBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(getColorHexFromStr('#0569a8')),
        elevation: 0,
        title: Text('QR CODE'),
        actions: <Widget>[
          QrShareButton(),
        ],
      ),
      body: Container(
          child: BlocEventStateBuilder<QrState>(
        bloc: bloc,
        builder: (BuildContext context, QrState state) {
          if (state.isLoading) {
            return PendingActionNoBg();
          }
          if (state.error.isNotEmpty) {
            return Center(
              child: Text(
                'เกิดข้อผิดพลาดกรุณาลองให่อีกครั้ง!',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          List<Widget> children = <Widget>[];
          children.add(Center(
            child: StreamBuilder(
              stream: bloc.qr,
              builder:
                  (BuildContext context, AsyncSnapshot<QrRequest> snapshot) {
                if (!snapshot.hasData) {
                  return PendingActionNoBg();
                }
                final price = snapshot.data != null ? snapshot.data.price : '0';
                final ref1 = snapshot.data != null ? snapshot.data.ref1 : '';
                return Column(
                  children: <Widget>[
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/blue_logo.png'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'แสดง QR Code นี้เพื่อรับเงิน',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      height: 10,
                      width: double.maxFinite,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      height: MediaQuery.of(context).size.height / 2 - 180,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: new Image.network(
                              'https://promptpay.io/$ref1/$price.png',
                              fit: BoxFit.contain,
                            ),
                            // child: Image.network(
                            //     'https://promptpay.io/$ref1/$price'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            formatter.format(double.parse('$price')),
                            style: TextStyle(
                                color: Color(getColorHexFromStr('#0569a8')),
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'บาท (BAHT)',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: ButtonTheme(
                          minWidth: double.infinity,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: MaterialButton(
                            padding: EdgeInsets.all(18),
                            color: Color(getColorHexFromStr('#0569a8')),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'แก้ไข QR Code',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                );
              },
            ),
          ));

          return Column(children: children);
        },
      )),
    );
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
