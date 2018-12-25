import 'package:flutter/material.dart';
import 'package:tmb_merchant/container/qr_detail.dart';
import 'package:tmb_merchant/src/blocs/application_state_provider.dart';
import 'package:tmb_merchant/src/blocs/state_mgmt_bloc.dart';

class QrPage extends StatefulWidget {
  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    final bloc = ApplicationStateProvider.of(context);
    return Column(children: <Widget>[
      Container(
        child: new AppBar(
          backgroundColor: Color(getColorHexFromStr('#0569a8')),
          elevation: 0,
          leading: null,
          title: new Text("CREATE QR"),
        ),
      ),
      Container(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('เลขที่สัญญา/ref1'),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Material(
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(2.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก เลขที่สัญญา/ref1';
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'เลขที่สัญญา/ref1',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('หมายเลขอ้างอิง/ref2'),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Material(
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(2.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก หมายเลขอ้างอิง/ref2';
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'หมายเลขอ้างอิง/ref2',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('จำนวนเงิน'),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Material(
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(2.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก จำนวนเงิน';
                            }
                          },
                          textAlign: TextAlign.right,
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(color: Colors.blue, fontSize: 20),
                              contentPadding: EdgeInsets.all(10),
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: ButtonTheme(
                          minWidth: double.infinity,
                          child: MaterialButton(
                            color: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QrDetailPage(
                                            price: this.priceController.text,
                                          )),
                                );
                              }
                            },
                            child: Text(
                              'สร้าง QR Code',
                              style: TextStyle(color: Colors.blue),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
