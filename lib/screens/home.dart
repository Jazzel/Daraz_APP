import 'package:daraz_app/app.dart';
import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';

typedef Func = void Function();

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Store'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(ShoppingCartRoute),
            icon: Icon(Icons.shopping_bag),
          ),
        ],
      ),
      body: Column(
        children: [
          StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (_, state) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final Map product = state.products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsPage(product: product),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: Image.network(product["image"]),
                            title: Text(product["name"]),
                            subtitle: Text(product["description"]),
                            trailing: Text(product["price"].toString() + "\$"),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Map product;

  ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(product["image"]),
            SizedBox(height: 16.0),
            Text(product["description"]),
            SizedBox(height: 16.0),
            StoreConnector<AppState, Func>(
              converter: (store) {
                return () async {
                  CartItem cartItem = CartItem(
                      name: product["name"],
                      quantity: 1,
                      price: product["price"]);
                  store.dispatch(addItemInShoppingCart(cartItem));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to Cart'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                };
              },
              builder: (_, callback) {
                return ElevatedButton(
                  onPressed: callback,
                  child: Text('Add to Cart'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
