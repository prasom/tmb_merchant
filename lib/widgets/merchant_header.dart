import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/models/user_model.dart';

class MerchantHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);

    return StreamBuilder(
      stream: bloc.streamCurrentUser,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          String _name = user.name;
          String _compCode = user.compcode;
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600)),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Comp Code : $_compCode',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                )
              ],
            ),
          );
        } else {
          return Container(child: Center(child: Text('Loading...'),),);
        }
      },
    );
  }
}
