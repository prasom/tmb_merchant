import 'package:tmb_merchant/bloc_helpers/bloc_provider.dart';
import 'package:tmb_merchant/blocs/shopping/shopping_bloc.dart';
import 'package:tmb_merchant/models/shopping_item.dart';
import 'package:tmb_merchant/widgets/shopping_basket.dart';
import 'package:tmb_merchant/widgets/shopping_item_widget.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ShoppingBloc bloc = BlocProvider.of<ShoppingBloc>(context);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Shopping Page'),
        actions: <Widget>[
          ShoppingBasket(),
        ],
      ),
      body: Container(
        child: StreamBuilder<List<ShoppingItem>>(
          stream: bloc.items,
          builder: (BuildContext context,
              AsyncSnapshot<List<ShoppingItem>> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ShoppingItemWidget(
                  shoppingItem: snapshot.data[index],
                );
              },
            );
          },
        ),
      ),
    ));
  }
}
