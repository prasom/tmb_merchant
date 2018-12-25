import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc/merchant_bloc.dart';

class MerchantProvider extends InheritedWidget {
  MerchantProvider({Key key, Widget child}) : super(key: key, child: child);

  final MerchantBloc merchantBloc = MerchantBloc();
  @override
  bool updateShouldNotify(MerchantProvider oldWidget) => (oldWidget.merchantBloc != merchantBloc);

  static MerchantBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MerchantProvider) as MerchantProvider)
        .merchantBloc;
  }
  
}
