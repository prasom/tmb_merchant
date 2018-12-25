import 'package:flutter/material.dart';
import 'package:tmb_merchant/container/index.dart';
import 'package:tmb_merchant/src/blocs/application_state_provider.dart';
import 'package:tmb_merchant/src/screens/loading_screen.dart';
import 'package:tmb_merchant/src/screens/login_screen.dart';
import 'package:tmb_merchant/src/screens/second_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(context) {
    return ApplicationStateProvider(
      child: MaterialApp(
        home: new LoadingPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new IndexPage(),
          '/login': (BuildContext context) => new LoginScreen(),
          '/pin': (BuildContext context) => new IndexPage(),
        },
        // routes: {
        //   '/': (context) => LoginScreen(),
        //   '/secondscreen': (context) => SecondScreen(),
        //   '/home': (context) => IndexPage(),
        // },
      ),
    );
  }
}
