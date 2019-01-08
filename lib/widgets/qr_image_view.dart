import 'package:flutter/material.dart';

const String _imageUrl = ' https://i.ibb.co/GFtPFpH/qr-home.png';

class QrImageView extends StatelessWidget {
  final String imageUrl;

  const QrImageView({Key key, @required this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Image.network(
      _imageUrl,
      fit: BoxFit.cover,
    );
  }
}
