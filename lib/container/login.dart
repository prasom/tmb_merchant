import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc/login_bloc.dart';
import 'package:tmb_merchant/container/home.dart';
import 'package:tmb_merchant/container/index.dart';
import 'package:tmb_merchant/models/login_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  final _api = Api();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSubmited = false;

  LoginBloc _bloc;
  StreamSubscription<Response> _subscription;

  @override
  void initState() {
    super.initState();
    _bloc = LoginBloc(_api);
    _subscription = _bloc.results.listen(_handleResponse);
  }

  _handleResponse(Response response) {
    if (response is SuccessResponse) {
      final route = MaterialPageRoute(
        builder: (BuildContext context) => IndexPage(),
      );
      Navigator.pushReplacement(context, route);
      return;
    }
    if (response is ErrorResponse) {
      _showSnackBar(response.error.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _bloc.dispose();
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
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: RadialGradient(
              center: const Alignment(0, -0.5), // near the top right
              radius: 0.5,
              colors: <Color>[
                // const Color.fromRGBO(1, 6, 100, 162),
                // const Color.fromRGBO(0, 10, 74, 130),
                Color(getColorHexFromStr('#049ede')),
                Color(getColorHexFromStr('#0569a8'))
              ]),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 70),
                child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                            image: AssetImage('assets/white_logo.png'),
                            fit: BoxFit.contain))),
              ),
              SizedBox(
                height: 100,
              ),
              _buildUserNameField(),
              SizedBox(
                height: 5,
              ),
              _buildPasswordField(),
              SizedBox(
                height: 10,
              ),
              _buildLoadingIndicator(),
              SizedBox(
                height: 10,
              ),
              _buildLoginButton(),
              SizedBox(
                height: 10,
              ),
              new InkWell(
                child: Text(
                  'ลืมรหัสผ่าน',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return new Container(
      constraints: new BoxConstraints.expand(
        height: 48.0,
        width: double.infinity,
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        shadowColor: Theme.of(context).accentColor,
        child: new StreamBuilder<bool>(
          stream: _bloc.validSubmit,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            debugPrint('Call builder');
            return MaterialButton(
              minWidth: double.infinity,
              splashColor: Colors.white70,
              disabledColor: Colors.white,
              color: Colors.white,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                this.isSubmited = true;
                snapshot.data ? _bloc.submitLogin() : null;
              },
            );
          },
        ),
        elevation: 4.0,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return StreamBuilder<bool>(
      stream: _bloc.isLoading,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        debugPrint('Call builder');
        return Opacity(
          opacity: snapshot.data ? 1.0 : 0.0,
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return StreamBuilder<String>(
      stream: _bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        debugPrint('Call builder');
        return TextFormField(
          keyboardType: TextInputType.text,
          obscureText: true,
          maxLines: 1,
          onFieldSubmitted: _bloc.passwordChanged,
          decoration: InputDecoration(
            errorText: this.isSubmited ? snapshot.error : '',
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white)
          ),
        );
      },
    );
  }

  Widget _buildUserNameField() {
    return StreamBuilder<String>(
      stream: _bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        debugPrint('Call builder');
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          maxLines: 1,
          onFieldSubmitted: _bloc.emailChanged,
          decoration: InputDecoration(
            errorText: this.isSubmited ? snapshot.error : '',
            labelText: 'User Name',
            labelStyle: TextStyle(color: Colors.white)
          ),
        );
      },
    );
  }

  _showSnackBar(String msg) =>
      _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(msg)));
}
