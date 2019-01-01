import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/bloc_widgets/bloc_state_builder.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_event.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_state.dart';
import 'package:tmb_merchant/widgets/pending_action.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
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

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                    center: const Alignment(0, -0.5),
                    radius: 0.5,
                    colors: <Color>[
                      Color(getColorHexFromStr('#049ede')),
                      Color(getColorHexFromStr('#0569a8'))
                    ]),
              ),
              child: BlocEventStateBuilder<AuthenticationState>(
                bloc: bloc,
                builder: (BuildContext context, AuthenticationState state) {
                  if (state.isAuthenticating) {
                    return PendingAction();
                  }

                  if (state.isAuthenticated) {
                    return Container();
                  }

                  List<Widget> children = <Widget>[];

                  // Button to fake the authentication (success)
                  children.add(
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: AssetImage('assets/white_logo.png'),
                                  fit: BoxFit.contain))),
                    ),
                  );

                  children.add(
                    SizedBox(
                      height: 10,
                    ),
                  );
                  children.add(
                    ListTile(
                      title: Container(
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก Username';
                            }
                          },
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white)),
                            labelText: 'username',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          controller: _usernameController,
                        ),
                        // decoration: new BoxDecoration(
                        //   color: Colors.transparent,
                        //   border: new Border(
                        //     bottom: new BorderSide(
                        //         color: Colors.white,
                        //         style: BorderStyle.solid,
                        //         width: 2),
                        //   ),
                        // ),
                      ),
                    ),
                  );
                  children.add(
                    ListTile(
                      title: Container(
                        // decoration: new BoxDecoration(
                        //   color: Colors.transparent,
                        //   border: new Border(
                        //     bottom: new BorderSide(
                        //         color: Colors.white,
                        //         style: BorderStyle.solid,
                        //         width: 2),
                        //   ),
                        // ),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก Password';
                            }
                          },
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white)),
                            labelText: 'password',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          controller: _passwordController,
                          obscureText: true,
                        ),
                      ),
                    ),
                  );

                  children.add(
                    ListTile(
                      title: ButtonTheme(
                          minWidth: double.infinity,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: MaterialButton(
                            padding: EdgeInsets.all(10),
                            color: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                bloc.emitEvent(AuthenticationEventLogin(
                                    name: _usernameController.text));
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue),
                            ),
                          )),
                    ),
                  );

                  // Display a text if the authentication failed
                  if (state.hasFailed) {
                    children.add(
                      Text(
                        'Authentication failure!',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }

                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
