import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/bloc_widgets/bloc_state_builder.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_event.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_state.dart';
import 'package:tmb_merchant/pages/index_page.dart';
import 'package:tmb_merchant/widgets/bio_metric_button.dart';
import 'package:tmb_merchant/widgets/pending_action.dart';
import 'package:tmb_merchant/widgets/pin_button.dart';
import 'package:tmb_merchant/widgets/pin_delete_button.dart';
import 'package:tmb_merchant/widgets/pin_indicator.dart';

class PinLoginPage extends StatefulWidget {
  @override
  _PinLoginPageState createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  Future<bool> _onWillPopScope() async {
    return false;
  }

  AuthenticationState oldAuthenticationState;
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: Center(
            child: BlocEventStateBuilder<AuthenticationState>(
          bloc: bloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state != oldAuthenticationState) {
              if (state.isAuthenticating) {
                return PendingAction();
              }
              if (state.isAuthenticated && state.isPinAuthenticated) {
                // _redirectToPage(context, IndexPage());
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/decision');
                });
              }
            }

            List<Widget> children = <Widget>[];

            children.add(
              new Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 36,
                  ),
                  onPressed: () {
                    bloc.emitEvent(AuthenticationEventLogout());
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacementNamed('/decision');
                    });
                  },
                ),
              ),
            );

            children.add(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    width: 80,
                    padding: EdgeInsets.all(12),
                    child: Image(
                      image: AssetImage('assets/blue_logo.png'),
                    ),
                  ),
                  Text('กรุณาใส่รหัสผ่าน'),
                  SizedBox(
                    height: 20,
                  ),
                  PinIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(left: 45, right: 45),
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: <Widget>[
                        PinButton(
                          pinNumber: '1',
                        ),
                        PinButton(
                          pinNumber: '2',
                        ),
                        PinButton(
                          pinNumber: '3',
                        ),
                        PinButton(
                          pinNumber: '4',
                        ),
                        PinButton(
                          pinNumber: '5',
                        ),
                        PinButton(
                          pinNumber: '6',
                        ),
                        PinButton(
                          pinNumber: '7',
                        ),
                        PinButton(
                          pinNumber: '8',
                        ),
                        PinButton(
                          pinNumber: '9',
                        ),
                        BioMetricButton(),
                        PinButton(
                          pinNumber: '0',
                        ),
                        PinDeleteButton()
                      ],
                    ),
                  )),
                ],
              ),
            );

            // Display a text if the authentication failed
            if (state.hasFailed) {
              _onWidgetDidBuild(() {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('รหัสผ่านไม่ถูกต้อง!'),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            }

            return StreamBuilder<int>(
              stream: bloc.pintSize,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                final totalPin = snapshot.data;
                if (totalPin == 6) {
                  bloc.emitEvent(AuthenticationEventPinLogin());
                }
                return SafeArea(
                  child: Stack(
                    children: children,
                  ),
                );
              },
            );
          },
        )),
      ),
    );
  }

  _buildNumberButton(String numb) {
    return Center(
      child: OutlineButton(
        shape: CircleBorder(),
        padding: EdgeInsets.all(20.0),
        onPressed: () {},
        child: Text(
          numb,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  void _redirectToPage(BuildContext context, Widget page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MaterialPageRoute newRoute =
          MaterialPageRoute(builder: (BuildContext context) => page);

      Navigator.of(context)
          .pushAndRemoveUntil(newRoute, ModalRoute.withName('/pinlogin'));
    });
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
