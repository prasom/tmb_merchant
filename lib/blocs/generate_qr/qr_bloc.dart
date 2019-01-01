import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/models/qr_model.dart';
import 'package:tmb_merchant/models/shopping_item.dart';
import 'package:rxdart/rxdart.dart';

class QrBloc implements BlocBase {
  // Reactive variables
  final _qrRequest = BehaviorSubject<QrRequest>();

  // Streams
  Observable<QrRequest> get qr => _qrRequest.stream;

  // Sinks
  Function(QrRequest) get _changeQr => _qrRequest.sink.add;

  void submitQrRequest(QrRequest request) {
    _changeQr(request);
  }

  @override
  void dispose() {
    
  }
}
