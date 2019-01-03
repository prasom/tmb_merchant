import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';

class DisableBioButton extends StatefulWidget {
  @override
  _DisableBioButtonState createState() => _DisableBioButtonState();
}

class _DisableBioButtonState extends State<DisableBioButton> {
  bool _giveVerse = false;
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);
    return Container(
      child: StreamBuilder(
        stream: bloc.activateFaceId,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            _giveVerse = snapshot.data;
            // _setDefault(bloc, faceId);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Activate Touch ID or Face ID',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Switch(
                  onChanged: (bool value) {
                    _setDefault(bloc, value);
                  },
                  value: _giveVerse,
                )
              ],
            );
          }

          return Container();
        },
      ),
    );
  }

  _setDefault(bloc, bool value) {
    setState(() {
      _giveVerse = value;
    });
    bloc.toggleActiveFaceId(value);
  }
}
