import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_bloc.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_event.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_state.dart';
import 'package:tmb_merchant/models/qr_model.dart';
import 'package:tmb_merchant/pages/qr_detail_page.dart';

class QrGeneratePage extends StatelessWidget {
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

  final priceController = TextEditingController();
  final ref1Controller = TextEditingController();
  final ref2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    QrBloc bloc = BlocProvider.of<QrBloc>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(getColorHexFromStr('#0569a8')),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('CREATE QR'),
      ),
      body: Container(
          child: Padding(
        padding: EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Comp Code : 12345',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
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
              _form(context, bloc)
            ],
          ),
        ),
      )),
    );
  }

  Widget _form(_context, _bloc) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'เลขที่สัญญา/ref1',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Material(
                elevation: 0.0,
                borderRadius: BorderRadius.circular(2.0),
                child: TextFormField(
                  controller: ref1Controller,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'กรุณากรอก เลขที่สัญญา/ref1';
                    }
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'เลขที่สัญญา/ref1',
                      hintStyle: TextStyle(color: Colors.grey)),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'หมายเลขอ้างอิง/ref2',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Material(
                elevation: 0.0,
                borderRadius: BorderRadius.circular(2.0),
                child: TextFormField(
                  controller: ref2Controller,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'กรุณากรอก หมายเลขอ้างอิง/ref2';
                    }
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'หมายเลขอ้างอิง/ref2',
                      hintStyle: TextStyle(color: Colors.grey)),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'จำนวนเงิน',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
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
                      labelStyle: TextStyle(color: Colors.blue, fontSize: 20),
                      contentPadding: EdgeInsets.all(10),
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey)),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: ButtonTheme(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                minWidth: double.infinity,
                child: MaterialButton(
                  padding: EdgeInsets.all(10),
                  color: Colors.blue,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _bloc.submitQrRequest(QrRequest(
                          ref1: ref1Controller.text,
                          ref2: ref2Controller.text,
                          price: priceController.text));
                      Navigator.push(
                        _context,
                        MaterialPageRoute(builder: (context) => QrDetail()),
                      );
                    }
                  },
                  child: Text(
                    'สร้าง QR Code',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  bool _generateSucceeded(QrState state) => state.qr.isNotEmpty;
  bool _generateFailed(QrState state) => state.error.isNotEmpty;

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onGenerateQrButtonPressed({QrBloc bloc}) {
    bloc.submitQrRequest(QrRequest(
        ref1: ref1Controller.text,
        ref2: ref2Controller.text,
        price: priceController.text));
  }
}
