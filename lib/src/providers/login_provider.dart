import 'package:flutter/material.dart';
import 'package:tmb_merchant/src/blocs/login_bloc.dart';

class LoginStateProvider extends InheritedWidget {
  final loginBloc = LoginBloc();

  //Take the LoginScreen Widget and push it to the InheritedWidget super class
  LoginStateProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LoginStateProvider)
            as LoginStateProvider)
        .loginBloc;
  }
}
