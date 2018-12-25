import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:tmb_merchant/src/blocs/application_state_provider.dart';
import 'package:tmb_merchant/src/blocs/state_mgmt_bloc.dart';

class QrDetailPage extends StatelessWidget {
  final String price;
  final formatter = new NumberFormat("#,###");


  // In the constructor, require a Todo
  QrDetailPage({Key key, @required this.price}) : super(key: key);

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

    final bloc = ApplicationStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(getColorHexFromStr('#0569a8')),
        title: Text('QR Code'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
               final RenderBox box = context.findRenderObject();
                  Share.share('ร้านค้าสุขใจ',
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 80,
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
                height: 10,
              ),
              Text('แสดง Qr Code นี้เพื่อรับเงิน'),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2 - 80,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new QrImage(
                      data: "ร้านค้าสุขใจ $price",
                      size: 200.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildUsernameText(bloc),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(formatter.format( double.parse(this.price)),
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'บาท(BAHT)',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: ButtonTheme(
                    minWidth: double.infinity,
                    child: MaterialButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'แก้ไข QR Code',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
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
}
