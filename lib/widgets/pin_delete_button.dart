import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';

class PinDeleteButton extends StatelessWidget {
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
            child: Icon(Icons.backspace),
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
            onPressed: () {
             bloc.removePin();
            },
          );
          // return OutlineButton(
          //   shape: CircleBorder(),
          //   padding: EdgeInsets.all(20.0),
          //   onPressed: () {
          //     if (pinSize < 6) {
          //       bloc.enterPin(pinNumber);
          //     }
          //   },
          //   child: Text(
          //     pinNumber,
          //     style: TextStyle(fontSize: 20),
          //   ),
          // );
        },
      ),
    );
  }
}
