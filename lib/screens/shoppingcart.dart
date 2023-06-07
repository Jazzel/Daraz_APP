import 'package:daraz_app/app.dart';
import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

typedef DecrementFunc = void Function();
typedef IncrementFunc = void Function();
typedef RemoveFunc = void Function();

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  double calculateTotal(List<CartItem> cartItems) {
    double total = 0.0;
    for (CartItem item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          StoreConnector<AppState, AppState>(
              builder: (_, state) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.shoppingcart.length,
                    itemBuilder: (BuildContext context, int index) {
                      CartItem item = state.shoppingcart[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: \$${item.price.toStringAsFixed(2)}'),
                            Text('Quantity: ${item.quantity}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StoreConnector<AppState, DecrementFunc>(
                                builder: (_, callback) {
                              return IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: callback,
                              );
                            }, converter: (store) {
                              return () {
                                store.dispatch(
                                    decrementItemInShoppingCart(item));
                              };
                            }),
                            StoreConnector<AppState, IncrementFunc>(
                                builder: (_, callback) {
                              return IconButton(
                                icon: Icon(Icons.add),
                                onPressed: callback,
                              );
                            }, converter: (store) {
                              return () {
                                store.dispatch(
                                    incrementItemInShoppingCart(item));
                              };
                            }),
                            StoreConnector<AppState, RemoveFunc>(
                                builder: (_, callback) {
                              return IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: callback,
                              );
                            }, converter: (store) {
                              return () {
                                store
                                    .dispatch(removeItemFromShoppingCart(item));
                              };
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              converter: (store) => store.state),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StoreConnector<AppState, AppState>(
                    builder: (_, state) {
                      return Text(
                        '\$${calculateTotal(state.shoppingcart).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                    converter: (store) => store.state),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          InkWell(
            onTap: () {
              // Handle checkout logic here
              Navigator.of(context).pushNamed(CheckoutRoute);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
