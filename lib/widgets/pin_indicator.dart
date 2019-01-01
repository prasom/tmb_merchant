import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class PinIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);
    return Center(
      child: StreamBuilder(
        stream: bloc.pintSize,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final total = snapshot.data != null ? snapshot.data : 0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildIcon(total >= 1),
              _buildIcon(total >= 2),
              _buildIcon(total >= 3),
              _buildIcon(total >= 4),
              _buildIcon(total >= 5),
              _buildIcon(total >= 6),
            ],
          );
        },
      ),
    );
  }

  Icon _buildIcon(bool filled) {
    if (filled) {
      return Icon(Icons.fiber_manual_record);
    } else {
      return Icon(OMIcons.fiberManualRecord);
    }
  }
}
