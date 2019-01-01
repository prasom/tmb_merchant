import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/shopping/shopping_bloc.dart';
import 'package:flutter/material.dart';

class ShoppingBasketPrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ShoppingBloc bloc = BlocProvider.of<ShoppingBloc>(context);
    
    return StreamBuilder<double>(
      stream: bloc.shoppingBasketTotalPrice,
      initialData: 0.0,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot){
        return Text('Total: ${snapshot.data} €', style: TextStyle(fontSize: 12.0,));
      },
    );
  }
}