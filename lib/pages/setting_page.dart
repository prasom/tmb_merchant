import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_event.dart';

class SettingPage extends StatelessWidget {
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
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(getColorHexFromStr('#0569a8')),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('SETTING'),
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.only(left: 20, right: 20),
              title: const Text('Logout'),
              trailing: const Icon(Icons.power_settings_new),
              onTap: () {
                bloc.emitEvent(AuthenticationEventLogout());
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.only(left: 20, right: 20),
              title: const Text('Disable FACE ID'),
              trailing: const Icon(Icons.face),
              onTap: () {
                bloc.emitEvent(AuthenticationEventLogout());
              },
            ),
            Divider(),
          ],
        ));
  }
}
