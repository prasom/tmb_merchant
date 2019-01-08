import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/models/user_model.dart';

const String _imageUrl = ' https://i.ibb.co/GFtPFpH/qr-home.png';

class HomeImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);
    return StreamBuilder(
      stream: bloc.streamCurrentUser,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final User user = snapshot.data;
          final String _logo = user.logo;

          return new Image.network(
            _logo,
            fit: BoxFit.cover,
          );
        } else {
           return Container(child: Center(child: Text('Loading...'),),);
        }
      },
    );
  }
}
