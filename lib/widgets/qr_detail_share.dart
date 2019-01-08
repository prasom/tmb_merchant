
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_share/image_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_bloc.dart';
import 'package:tmb_merchant/blocs/authentication/authentication_event.dart';
import 'package:flutter/material.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_bloc.dart';
import 'package:tmb_merchant/models/qr_model.dart';

class QrShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QrBloc bloc = BlocProvider.of<QrBloc>(context);
    return StreamBuilder(
      stream: bloc.qr,
      builder: (BuildContext context, AsyncSnapshot<QrRequest> snapshot) {
        final fileUrl = snapshot.data;
        return IconButton(
          icon: Icon(Icons.share),
          onPressed: () async {
            try {
              final File imageUri = await _downloadFile(fileUrl.qrUrl, 'merchant_qr');
              ImageShare.shareImage(filePath: imageUri.path);
            } catch (e) {}
          },
        );
      },
    );
  }

  static var httpClient = new HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
