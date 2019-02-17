import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_bloc.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_event.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_state.dart';
import 'package:tmb_merchant/models/qr_model.dart';
import 'package:tmb_merchant/models/user_model.dart';
import 'package:tmb_merchant/pages/qr_detail_page.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:tmb_merchant/widgets/merchant_header.dart';

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

  FocusNode _nodeText1 = FocusNode();
  FocusNode _nodeText2 = FocusNode();
  FocusNode _nodeText3 = FocusNode();
  FocusNode _nodeText4 = FocusNode();
  FocusNode _nodeText5 = FocusNode();

  @override
  Widget build(BuildContext context) {
    QrBloc bloc = BlocProvider.of<QrBloc>(context);
    AuthenticationBloc userBloc = BlocProvider.of<AuthenticationBloc>(context);

    return StreamBuilder(
      stream: userBloc.streamCurrentUser,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        String _compcode = '';
        if (snapshot.data != null) {
          _compcode = snapshot.data.compcode;
          ref1Controller.text =_compcode;
        }
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
              child: FormKeyboardActions(
                keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                keyboardBarColor: Colors.grey[200],
                nextFocus: true,
                actions: [
                  KeyboardAction(
                    focusNode: _nodeText1,
                  ),
                  KeyboardAction(
                    focusNode: _nodeText2,
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              MerchantHeader(),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Text(
                            'เบอร์โทรศัพท์ / เลขประจำตัวประชาชน',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey.shade600),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            focusNode: _nodeText2,
                            controller: ref1Controller,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'เบอร์โทรศัพท์ / เลขประจำตัวประชาชน';
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                              hintText: 'เบอร์โทรศัพท์ / เลขประจำตัวประชาชน',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        //   child: Text(
                        //     'หมายเลขอ้างอิง/ref2',
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 18,
                        //         color: Colors.grey.shade600),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        //   child: TextFormField(
                        //     controller: ref2Controller,
                        //     validator: (value) {
                        //       if (value.isEmpty) {
                        //         return 'กรุณากรอก หมายเลขอ้างอิง/ref2';
                        //       }
                        //     },
                        //     decoration: InputDecoration(
                        //         contentPadding: EdgeInsets.all(10),
                        //         border: OutlineInputBorder(),
                        //         hintText: 'หมายเลขอ้างอิง/ref2',
                        //         hintStyle: TextStyle(color: Colors.grey)),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        Container(
                          color: Colors.grey.shade300,
                          child: Container(
                            width: double.maxFinite,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: Text(
                                'จำนวนเงิน',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Material(
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(2.0),
                            child: TextFormField(
                              focusNode: _nodeText1,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณากรอก จำนวนเงิน';
                                }
                              },
                              textAlign: TextAlign.right,
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color(getColorHexFromStr('#0569a8')),
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Colors.blue, fontSize: 20),
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
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: ButtonTheme(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            minWidth: double.infinity,
                            child: MaterialButton(
                              padding: EdgeInsets.all(18),
                              color: Color(getColorHexFromStr('#0569a8')),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  final request = new QrRequest(
                                    ref1: ref1Controller.text,
                                    ref2: ref2Controller.text,
                                    price: priceController.text,
                                    compcode: _compcode,
                                  );
                                  bloc.emitEvent(GenerateQr(request: request));
                                  // bloc.submitQrRequest(QrRequest(
                                  //   ref1: ref1Controller.text,
                                  //   ref2: ref2Controller.text,
                                  //   price: priceController.text,
                                  //   compcode: _compcode,
                                  // ));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QrDetail()),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
        );
      },
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
