import 'package:flutter/material.dart';

class PendingActionNoBg extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ),
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withOpacity(0.3),
        ),
      ],
    );
  }
}
