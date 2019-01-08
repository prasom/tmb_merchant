import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/bloc_event_state.dart';
import 'package:tmb_merchant/models/qr_model.dart';

class QrState extends BlocState {
  final bool isLoading;
  final bool isGenerateButtonEnabled;
  final String error;
  final String qr;
  final QrRequest request;

  QrState({
    @required this.isLoading,
    @required this.isGenerateButtonEnabled,
    @required this.error,
    @required this.qr,
    @required this.request,
  });

  factory QrState.initial() {
    return QrState(
        isLoading: false,
        isGenerateButtonEnabled: true,
        error: '',
        qr: '',
        request: null);
  }

  factory QrState.loading() {
    return QrState(
      isLoading: true,
      isGenerateButtonEnabled: false,
      error: '',
      qr: '',
    );
  }

  factory QrState.failure(String error) {
    return QrState(
      isLoading: false,
      isGenerateButtonEnabled: true,
      error: error,
      qr: '',
    );
  }

  factory QrState.success(String redponse, QrRequest request) {
    return QrState(
        isLoading: false,
        isGenerateButtonEnabled: true,
        error: '',
        qr: redponse,
        request: request);
  }

  factory QrState.edit() {
    return QrState(
      isLoading: false,
      isGenerateButtonEnabled: false,
      error: '',
      qr: null,
    );
  }

  @override
  bool operator ==(
    Object other,
  ) =>
      identical(
        this,
        other,
      ) ||
      other is QrState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          isGenerateButtonEnabled == other.isGenerateButtonEnabled &&
          error == other.error &&
          qr == other.qr;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      isGenerateButtonEnabled.hashCode ^
      error.hashCode ^
      qr.hashCode;

  @override
  String toString() =>
      'LoginState { isLoading: $isLoading, isGenerateButtonEnabled: $isGenerateButtonEnabled, error: $error, qr: $qr }';
}
