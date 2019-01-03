import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class DemoKeyboard extends StatelessWidget {
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Keyboard Actions Sample"),
      ),
      body: Container(
        child: Form(
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
                closeWidget: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close),
                ),
              ),
              KeyboardAction(
                focusNode: _nodeText3,
                onTapAction: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text("Custom Action"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("OK"),
                              onPressed: () => Navigator.of(context).pop(),
                            )
                          ],
                        );
                      });
                },
              ),
              KeyboardAction(
                focusNode: _nodeText4,
                displayCloseWidget: false,
              ),
              KeyboardAction(
                focusNode: _nodeText5,
                closeWidget: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("CLOSE"),
                ),
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
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                      color: Colors.grey.shade400,
                                      fontSize: 16),
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(
                        'เลขที่สัญญา/ref1',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey.shade600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                        controller: ref1Controller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'กรุณากรอก เลขที่สัญญา/ref1';
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          hintText: 'เลขที่สัญญา/ref1',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(
                        'หมายเลขอ้างอิง/ref2',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey.shade600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                        controller: ref2Controller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'กรุณากรอก หมายเลขอ้างอิง/ref2';
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            hintText: 'หมายเลขอ้างอิง/ref2',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                                labelStyle:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                                contentPadding: EdgeInsets.all(10),
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey)),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
