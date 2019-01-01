import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_bloc.dart';
import 'package:tmb_merchant/blocs/shopping/shopping_bloc.dart';
import 'package:tmb_merchant/pages/decision_page.dart';
import 'package:tmb_merchant/pages/initialization_page.dart';
import 'package:tmb_merchant/pages/pin_login_page.dart';
import 'package:tmb_merchant/pages/pin_setup_page.dart';
import 'package:tmb_merchant/pages/registration_page.dart';
import 'package:tmb_merchant/pages/shopping_basket_page.dart';
import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: AuthenticationBloc(),
      child: BlocProvider<QrBloc>(
        bloc: QrBloc(),
        child: MaterialApp(
          title: 'BLoC Samples',
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/decision': (BuildContext context) => DecisionPage(),
            '/register': (BuildContext context) => RegistrationPage(),
            '/shoppingBasket': (BuildContext context) => ShoppingBasketPage(),
            '/pinsetup': (BuildContext context) => PinSetUpPage(),
            '/loginpin': (BuildContext context) => PinLoginPage(),
          },
          home: InitializationPage(),
        ),
      ),
    );
  }
}
