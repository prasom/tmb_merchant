import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_bloc.dart';
import 'package:tmb_merchant/models/qr_model.dart';
import 'package:tmb_merchant/models/user_model.dart';

const String _imageUrl = ' https://i.ibb.co/GFtPFpH/qr-home.png';

class QrImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QrBloc bloc = BlocProvider.of<QrBloc>(context);
    return StreamBuilder(
      stream: bloc.qr,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final QrRequest qr = snapshot.data;
          final String _logo = qr.qrUrl;

          return new Image.network(
            _logo,
            fit: BoxFit.contain,
          );
        } else {
           return Container(child: Center(child: Text('Loading...'),),);
        }
      },
    );
  }
}
