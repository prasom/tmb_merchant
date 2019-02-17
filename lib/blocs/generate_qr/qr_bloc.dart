import 'package:tmb_merchant/apis/qr_api.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_event_state.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_event.dart';
import 'package:tmb_merchant/blocs/generate_qr/qr_state.dart';
import 'package:tmb_merchant/models/qr_model.dart';
import 'package:tmb_merchant/models/shopping_item.dart';
import 'package:rxdart/rxdart.dart';

class QrBloc extends BlocEventStateBase<QrEvent, QrState> {
  QrBloc()
      : super(
          initialState: QrState.initial(),
        ) {}
  // Reactive variables
  final _qrRequest = BehaviorSubject<QrRequest>();
  final _qrUrl = BehaviorSubject<String>();

  QrApi api = new QrApi();

  // Streams
  Observable<QrRequest> get qr => _qrRequest.stream;
  Observable<String> get outQrUrl => _qrUrl.stream;

  // Sinks
  Function(QrRequest) get _changeQr => _qrRequest.sink.add;
  Function(String) get inQrUrl => _qrUrl.sink.add;
  @override
  Stream<QrState> eventHandler(QrEvent event, QrState currentState) async* {
    if (event is GenerateQr) {
      try {
        yield QrState.loading();
        _changeQr(event.request);
        final qrUrl = await _genrateQr(event.request.compcode,
            event.request.ref1, event.request.ref2, event.request.price);
        final merchantId = event.request.ref1;
        final merchantPrice = event.request.price;
        if (qrUrl.isNotEmpty) {
          final QrRequest response = new QrRequest(
            compcode: event.request.compcode,
            price: event.request.price,
            ref1: event.request.ref1,
            ref2: event.request.ref2,
            qrUrl: qrUrl,
          );
          _changeQr(response);
          yield QrState.success(qrUrl, event.request);
        } else {
          yield QrState.failure(qrUrl);
        }
      } catch (e) {
        yield QrState.failure(e.toString());
      }
    }
  }

  Future<String> _genrateQr(compcode, ref1, ref2, price) async {

    final String qrUrl = await api.generateQr(compcode, ref1, ref2, price);
    return qrUrl;
  }

  void submitQrRequest(QrRequest request) {
    _changeQr(request);
  }
}
