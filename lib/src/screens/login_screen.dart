import 'package:flutter/material.dart';
import '../blocs/state_mgmt_bloc.dart';
import '../blocs/application_state_provider.dart';

class LoginScreen extends StatelessWidget {
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
  Widget build(context) {
    final stateMgmtBloc = ApplicationStateProvider.of(
        context); //Get access to the bloc in the Provider
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
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
        child: Container(
          margin: EdgeInsets.all(30.0),
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
              SizedBox(height: 100,),
              emailField(stateMgmtBloc),
              SizedBox(
                height: 10.0,
              ),
              passwordField(stateMgmtBloc),
              SizedBox(
                height: 40.0,
              ),
              loginButton(stateMgmtBloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailField(StateMgmtBloc stateMgmtBloc) {
    return StreamBuilder(
      stream: stateMgmtBloc.usernameStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        //Anytime the builder sees new data in the emailStream, it will re-render the TextField widget
        return TextField(
          onChanged: stateMgmtBloc
              .updateUsername, //Wire up TextField widget to the email stream and add the email to the stream sink
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Enter Username',
            labelText: 'Username',
            labelStyle: TextStyle(color: Colors.white),
            errorText: snapshot
                .error, //retrieve the error message from the stream and display it
          ),
        );
      },
    );
  }

  Widget passwordField(StateMgmtBloc stateMgmtBloc) {
    return StreamBuilder(
      stream: stateMgmtBloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return TextField(
          onChanged: stateMgmtBloc.updatePassword,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter Password',
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white),
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget loginButton(StateMgmtBloc stateMgmtBloc) {
    return StreamBuilder(
      stream: stateMgmtBloc.submitValid,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return RaisedButton(
          child: Text('Login',style: TextStyle(color: Colors.blue),),
          color: Colors.white,
          disabledColor: Colors.white,
          onPressed: snapshot.hasData
              ? () => Navigator.pushReplacementNamed(context,
                  "/home") //If both email and password are valid, enable login button. Navigate to second screen when user presses the login button
              : null, //Disable the button if there is an error
        );
      },
    );
  }
}
