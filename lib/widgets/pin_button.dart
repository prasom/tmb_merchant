import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';

class PinButton extends StatelessWidget {
  final String pinNumber;

  const PinButton({Key key, @required this.pinNumber}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);
    return Center(
      child: StreamBuilder(
        stream: bloc.pintSize,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final pinSize = snapshot.data;
          return OutlineButton(
            shape: CircleBorder(),
            padding: EdgeInsets.all(15.0),
            onPressed: () {
              if (pinSize < 6) {
                bloc.enterPin(pinNumber);
              }
            },
            child: Text(
              pinNumber,
              style: TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
