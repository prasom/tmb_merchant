import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/bloc_widgets/bloc_state_builder.dart';
import 'package:tmb_merchant/blocs/application_initialization/application_initialization_bloc.dart';
import 'package:tmb_merchant/blocs/application_initialization/application_initialization_state.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_event.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_state.dart';
import 'package:tmb_merchant/pages/authentication_page.dart';
import 'package:tmb_merchant/pages/decision_page.dart';
import 'package:tmb_merchant/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:tmb_merchant/pages/index_page.dart';
import 'package:tmb_merchant/pages/pin_login_page.dart';
import 'package:tmb_merchant/pages/pin_setup_page.dart';

class DecisionBeforeLoginPage extends StatefulWidget {
  @override
  DecisionBeforeLoginPageState createState() {
    return new DecisionBeforeLoginPageState();
  }
}

class DecisionBeforeLoginPageState extends State<DecisionBeforeLoginPage> {
  ApplicationInitializationState oldAuthenticationState;

  @override
  Widget build(BuildContext context) {
    ApplicationInitializationBloc bloc = BlocProvider.of<ApplicationInitializationBloc>(context);
    return BlocEventStateBuilder<ApplicationInitializationState>(
        bloc: bloc,
        builder: (BuildContext context, ApplicationInitializationState state) {
          if (state != oldAuthenticationState) {
            oldAuthenticationState = state;

            if (state.isInitialized && !state.isIgnoreDecisionPage) {
              _redirectToPage(context, PinLoginPage());
            } else{
              _redirectToPage(context, DecisionPage());
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
