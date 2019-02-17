import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/bloc_widgets/bloc_state_builder.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_state.dart';
import 'package:tmb_merchant/models/user_model.dart';
import 'package:tmb_merchant/widgets/bound_text.dart';
import 'package:tmb_merchant/widgets/home_image_view.dart';
import 'package:tmb_merchant/widgets/home_share.dart';
import 'package:tmb_merchant/widgets/merchant_header.dart';
import 'package:tmb_merchant/widgets/pending_action.dart';
import 'package:tmb_merchant/widgets/pending_action_no_bg.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_share/image_share.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatelessWidget {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

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
    return BlocEventStateBuilder<AuthenticationState>(
      bloc: bloc,
      builder: (BuildContext context, AuthenticationState state) {
        if (state.isAuthenticating) {
          return PendingActionNoBg();
        }

        List<Widget> children = <Widget>[];
        children.add(
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
        );
        children.add(
          Divider(),
        );
        children.add(
          SizedBox(
            height: 20,
          ),
        );
        children.add(Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width - 40,
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border.all(color: Color(getColorHexFromStr('#0569a8'))),
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.shade100,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    height: 80,
                    image: AssetImage('assets/promptpay_icon.jpg'),
                  ),
                ),
                HomeImageView(),
              ],
            ),
          ),
        ));

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(getColorHexFromStr('#0569a8')),
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text('HOME'),
            actions: <Widget>[
              HomeShareButton(),
            ],
          ),
          body: Container(
            child: Center(child: Column(children: children)),
          ),
        );
      },
    );
  }
}
