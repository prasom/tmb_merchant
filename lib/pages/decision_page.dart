import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/bloc_widgets/bloc_state_builder.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_event.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_state.dart';
import 'package:tmb_merchant/pages/authentication_page.dart';
import 'package:tmb_merchant/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:tmb_merchant/pages/index_page.dart';
import 'package:tmb_merchant/pages/pin_login_page.dart';
import 'package:tmb_merchant/pages/pin_setup_page.dart';

class DecisionPage extends StatefulWidget {
  @override
  DecisionPageState createState() {
    return new DecisionPageState();
  }
}

class DecisionPageState extends State<DecisionPage> {
  AuthenticationState oldAuthenticationState;

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocEventStateBuilder<AuthenticationState>(
        bloc: bloc,
        builder: (BuildContext context, AuthenticationState state) {
          if (state != oldAuthenticationState) {
            oldAuthenticationState = state;

            if (state.isAuthenticated && state.isPinAuthenticated) {
              _redirectToPage(context, IndexPage());
            } else if (state.isAuthenticating || state.hasFailed) {
              //do nothing
            } else if (state.isAuthenticated && !state.isPinAuthenticated) {
              _redirectToPage(context, PinSetUpPage());
            } else {
              _redirectToPage(context, AuthenticationPage());
            }
          }

          // This page does not need to display anything since it will
          // always remain behind any active page (and thus 'hidden').
          return Container();
        });
  }

  void _redirectToPage(BuildContext context, Widget page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MaterialPageRoute newRoute =
          MaterialPageRoute(builder: (BuildContext context) => page);

      Navigator.of(context)
          .pushAndRemoveUntil(newRoute, ModalRoute.withName('/decision'));
    });
  }
}
